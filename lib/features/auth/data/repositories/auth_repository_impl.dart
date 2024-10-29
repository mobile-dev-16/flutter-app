import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/core/network/network_info.dart';
import 'package:eco_bites/features/auth/data/datasources/user_local_data_source.dart';
import 'package:eco_bites/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:eco_bites/features/auth/domain/entities/user.dart';
import 'package:eco_bites/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        await localDataSource.cacheUser(user);
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signUpWithEmailAndPassword(
          email: email,
          password: password,
        );
        await localDataSource.cacheUser(user);
        await localDataSource.cacheUserId(user.id);
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signInWithGoogle();
        await localDataSource.cacheUser(user);
        await localDataSource.cacheUserId(user.id);
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signUpWithGoogle();
        await localDataSource.cacheUser(user);
        await localDataSource.cacheUserId(user.id);
        return Right(user);
      } on AuthException catch (e) {
        return Left(AuthFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearUserCache();
      await localDataSource.clearUserId();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
}
