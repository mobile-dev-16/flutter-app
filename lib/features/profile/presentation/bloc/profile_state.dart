import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';

// Definimos los diferentes estados que puede tener el perfil
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {

  ProfileLoaded(this.profile);
  final UserProfile profile;
}

class ProfileError extends ProfileState {

  ProfileError(this.message);
  final String message;
}
