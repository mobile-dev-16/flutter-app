import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<Either<ServerFailure, UserProfile?>> fetchUserProfile(String uid);
  Future<Either<ServerFailure, Unit>> updateUserProfile(UserProfile profile);
}
