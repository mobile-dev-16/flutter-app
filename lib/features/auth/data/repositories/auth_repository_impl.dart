import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/core/network/network_info.dart';
import 'package:eco_bites/features/auth/data/datasources/user_local_data_source.dart';
import 'package:eco_bites/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:eco_bites/features/auth/data/models/user_model.dart';
import 'package:eco_bites/features/auth/domain/entities/user.dart';
import 'package:eco_bites/features/auth/domain/repositories/auth_repository.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.firestore,
  });

  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final FirebaseFirestore firestore;

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final UserModel user =
            await remoteDataSource.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        await localDataSource.cacheUser(user);
        return Right<Failure, User>(user);
      } on AuthException catch (e) {
        return Left<Failure, User>(AuthFailure(e.message));
      }
    } else {
      return const Left<Failure, User>(
        NetworkFailure('No internet connection'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String citizenId,
    required String phone,
    required DateTime birthDate,
    required CuisineType favoriteCuisine,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        // Crear el usuario en Firebase Authentication
        final UserModel user =
            await remoteDataSource.signUpWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Guardar datos adicionales en Firestore
        await firestore.collection('profiles').doc(user.id).set(<String, dynamic>{
          'name': name,
          'surname': surname,
          'citizenId': citizenId,
          'phone': phone,
          'birthDate': birthDate.toIso8601String(),
          'email': email,
          'favoriteCuisine': favoriteCuisine.name,
        });

        // Cachear el usuario localmente
        await localDataSource.cacheUser(user);
        await localDataSource.cacheUserId(user.id);
        return Right<Failure, User>(user);
      } on AuthException catch (e) {
        return Left<Failure, User>(AuthFailure(e.message));
      } catch (e) {
        return const Left<Failure, User>(ServerFailure('Failed to save user profile'));
      }
    } else {
      return const Left<Failure, User>(
        NetworkFailure('No internet connection'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        final UserModel user = await remoteDataSource.signInWithGoogle();
        await localDataSource.cacheUser(user);
        await localDataSource.cacheUserId(user.id);
        return Right<Failure, User>(user);
      } on AuthException catch (e) {
        return Left<Failure, User>(AuthFailure(e.message));
      }
    } else {
      return const Left<Failure, User>(
        NetworkFailure('No internet connection'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        final UserModel user = await remoteDataSource.signUpWithGoogle();
        await localDataSource.cacheUser(user);
        await localDataSource.cacheUserId(user.id);
        return Right<Failure, User>(user);
      } on AuthException catch (e) {
        return Left<Failure, User>(AuthFailure(e.message));
      }
    } else {
      return const Left<Failure, User>(
        NetworkFailure('No internet connection'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearUserCache();
      await localDataSource.clearUserId();
      return const Right<Failure, void>(null);
    } on AuthException catch (e) {
      return Left<Failure, void>(AuthFailure(e.message));
    }
  }
}
