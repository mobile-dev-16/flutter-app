// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';

// Definimos los diferentes estados que puede tener el perfil
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  ProfileLoaded(this.profile, {this.isUpdated = false});
  final UserProfile profile;
  final bool isUpdated;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileLoaded &&
          runtimeType == other.runtimeType &&
          profile == other.profile &&
          isUpdated == other.isUpdated;

  @override
  int get hashCode => profile.hashCode ^ isUpdated.hashCode;
}

class ProfileError extends ProfileState {

  ProfileError(this.message);
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
