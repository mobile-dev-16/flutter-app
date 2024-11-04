import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';
import 'package:eco_bites/features/profile/domain/repositories/user_profile_repository.dart';

class UpdateUserProfileUseCase {

  UpdateUserProfileUseCase(this.repository);
  final UserProfileRepository repository;

  Future<void> call(UserProfile userProfile) async {
    await repository.updateUserProfile(userProfile);
  }
}
