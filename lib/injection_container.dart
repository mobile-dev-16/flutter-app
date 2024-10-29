import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_bloc.dart';
import 'package:eco_bites/features/food/repository/food_business_repository.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:eco_bites/core/network/network_info.dart';
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

final serviceLocator = GetIt.instance;

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

  // Other Blocs
  serviceLocator.registerFactory(() => AddressBloc());
  serviceLocator.registerFactory(() => OrderBloc());

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

  // Core
  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(serviceLocator()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => GoogleSignIn());
  serviceLocator.registerLazySingleton(() => Connectivity());
}
