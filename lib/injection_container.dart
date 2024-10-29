import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eco_bites/core/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:eco_bites/core/network/network_info.dart';
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
import 'package:eco_bites/features/food/presentation/bloc/food_business_bloc.dart';
import 'package:eco_bites/features/food/repository/food_business_repository.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Features - Auth
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

  // Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(() => FoodBusinessRepository());

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

  // Features - Address
  serviceLocator.registerFactory(() => AddressBloc());

  // Features - Orders
  serviceLocator.registerFactory(() => OrderBloc());

  // Features - Cart
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

  // Features - Food
  serviceLocator.registerFactory(
    () => FoodBusinessBloc(
      foodBusinessRepository: serviceLocator(),
      addressBloc: serviceLocator(),
    ),
  );

  // Core
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );

  // External
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => GoogleSignIn());
  serviceLocator.registerLazySingleton(() => Connectivity());

  // Core Blocs
  serviceLocator.registerFactory(() => InternetConnectionBloc());
}
