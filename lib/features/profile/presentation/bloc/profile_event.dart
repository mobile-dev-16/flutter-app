import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class ProfileEvent extends Equatable{
  const ProfileEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadProfileEvent extends ProfileEvent {

  const LoadProfileEvent(this.userId);
  final String userId;
}

class UpdateProfileEvent extends ProfileEvent {
  UpdateProfileEvent({
    required this.userId,
    required this.updatedProfile,
    }) : assert(userId.isNotEmpty, 'userId cannot be empty');
  final String userId;
  final UserProfile updatedProfile;

  @override
  List<Object> get props => <Object>[userId, updatedProfile];
}
