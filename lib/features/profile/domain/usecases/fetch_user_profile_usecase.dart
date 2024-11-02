import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';
import 'package:eco_bites/features/profile/domain/repositories/user_profile_repository.dart';

class FetchUserProfileUseCase {

  FetchUserProfileUseCase(this.repository);
  final UserProfileRepository repository;

  Future<UserProfile?> call(String userId) async {
    final Either<ServerFailure, UserProfile?> result = await repository.fetchUserProfile(userId);
    return result.fold(
      (ServerFailure failure) => null,
      (UserProfile? userProfile) => userProfile,
    );
  }
}
