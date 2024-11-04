import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eco_bites/core/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:eco_bites/core/network/network_info.dart';
import 'package:eco_bites/features/address/data/datasources/address_remote_data_source.dart';
import 'package:eco_bites/features/address/data/repositories/address_repository_impl.dart';
import 'package:eco_bites/features/address/domain/repositories/address_repository.dart';
import 'package:eco_bites/features/address/domain/usecases/fetch_user_addresses_usecase.dart';
import 'package:eco_bites/features/address/domain/usecases/save_address_usecase.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_bloc.dart';
import 'package:eco_bites/features/auth/data/datasources/user_local_data_source.dart';
import 'package:eco_bites/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:eco_bites/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:eco_bites/features/auth/domain/repositories/auth_repository.dart';
import 'package:eco_bites/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:eco_bites/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:eco_bites/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:eco_bites/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:eco_bites/features/auth/domain/usecases/sign_up_with_google_usecase.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eco_bites/features/food/data/datasources/food_business_remote_data_source.dart';
import 'package:eco_bites/features/food/data/repositories/food_business_repository_impl.dart';
import 'package:eco_bites/features/food/domain/repositories/food_business_repository.dart';
import 'package:eco_bites/features/food/domain/usecases/fetch_nearby_surplus_food_businesses.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_bloc.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_bloc.dart';
import 'package:eco_bites/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:eco_bites/features/profile/domain/repositories/user_profile_repository.dart';
import 'package:eco_bites/features/profile/domain/usecases/fetch_user_profile_usecase.dart';
import 'package:eco_bites/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  await _setupCoreDependencies();
  await _setupExternalDependencies();

  // Features
  _setupAuthFeature();
  _setupProfileFeature();
  _setupAddressFeature();
  _setupOrderFeature();
  _setupCartFeature();
  _setupFoodFeature();
}

Future<void> _setupCoreDependencies() async {
  // Core
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      serviceLocator<Connectivity>(),
      serviceLocator<InternetConnectionBloc>(),
    ),
  );

  // Core Blocs
  serviceLocator.registerFactory(() => InternetConnectionBloc());
}

Future<void> _setupExternalDependencies() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => GoogleSignIn());
  serviceLocator.registerLazySingleton(() => Connectivity());
}

void _setupAuthFeature() {
  // Bloc
  serviceLocator.registerFactory(
    () => AuthBloc(
      signInUseCase: serviceLocator(),
      signUpUseCase: serviceLocator(),
      signInWithGoogleUseCase: serviceLocator(),
      signUpWithGoogleUseCase: serviceLocator(),
      signOutUseCase: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator.registerLazySingleton(() => SignInUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignUpUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => SignInWithGoogleUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => SignUpWithGoogleUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignOutUseCase(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
      firestore: serviceLocator(),
    ),
  );

  // Data sources
  serviceLocator.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      firebaseAuth: serviceLocator(),
      googleSignIn: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );
}

void _setupProfileFeature() {
  // Bloc
  serviceLocator.registerFactory(
    () => ProfileBloc(
      fetchUserProfileUseCase: serviceLocator(),
      updateUserProfileUseCase: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator
      .registerLazySingleton(() => FetchUserProfileUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => UpdateUserProfileUseCase(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<UserProfileRepository>(
    () => ProfileRepositoryImpl(firestore: serviceLocator()),
  );
}

void _setupAddressFeature() {
  // Bloc
  serviceLocator.registerFactory(
    () => AddressBloc(
      saveAddressUseCase: serviceLocator(),
      fetchUserAddressUseCase: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator
      .registerLazySingleton(() => SaveAddressUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => FetchUserAddressUseCase(serviceLocator()));

  // Repository and Data Source
  serviceLocator.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(
      remoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(firestore: serviceLocator()),
  );
}

void _setupOrderFeature() {
  serviceLocator.registerFactory(() => OrderBloc());
}

void _setupCartFeature() {
  serviceLocator.registerFactory(
    () => CartBloc(<CartItemData>[
      CartItemData(
        id: '1',
        title: 'Pineapple Pizza',
        normalPrice: 32000,
        offerPrice: 28000,
      ),
      CartItemData(
        id: '2',
        title: 'Donut',
        normalPrice: 21000,
        offerPrice: 11000,
        quantity: 2,
      ),
      CartItemData(
        id: '3',
        title: 'Cheeseburger',
        normalPrice: 15000,
        offerPrice: 12000,
      ),
    ]),
  );
}

void _setupFoodFeature() {
  // Bloc
  serviceLocator.registerFactory(
    () => FoodBusinessBloc(
      fetchNearbySurplusFoodBusinesses: serviceLocator(),
    ),
  );

  // Use case
  serviceLocator.registerLazySingleton(
    () => FetchNearbySurplusFoodBusinesses(serviceLocator()),
  );

  // Repository and Data Source
  serviceLocator.registerLazySingleton<FoodBusinessRepository>(
    () => FoodBusinessRepositoryImpl(
      remoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<FoodBusinessRemoteDataSource>(
    () => FoodBusinessRemoteDataSourceImpl(
      firestore: serviceLocator(),
    ),
  );
}
