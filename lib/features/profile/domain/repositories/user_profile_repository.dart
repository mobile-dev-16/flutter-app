import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile?> fetchUserProfile(String citizenId);
  Future<void> updateUserProfile(UserProfile profile);
}
