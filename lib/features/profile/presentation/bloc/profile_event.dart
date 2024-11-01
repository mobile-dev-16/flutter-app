import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';

abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {

  LoadProfileEvent(this.userId);
  final String userId;
}

class UpdateProfileEvent extends ProfileEvent {

  UpdateProfileEvent(this.userId, this.updatedProfile);
  final String userId;
  final UserProfile updatedProfile;
}
