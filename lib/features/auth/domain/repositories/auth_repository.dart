import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/auth/domain/entities/user.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String citizenId,
    required String phone,
    required DateTime birthDate,
    required CuisineType favoriteCuisine,
  });

  Future<Either<Failure, User>> signInWithGoogle();

  Future<Either<Failure, User>> signUpWithGoogle();

  Future<Either<Failure, void>> signOut();
}
