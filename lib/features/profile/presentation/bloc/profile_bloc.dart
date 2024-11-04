import 'package:eco_bites/core/blocs/resettable_mixin.dart';
import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';
import 'package:eco_bites/features/profile/domain/usecases/fetch_user_profile_usecase.dart';
import 'package:eco_bites/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_event.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>
    with ResettableMixin<ProfileEvent, ProfileState> {
  ProfileBloc({
    required this.fetchUserProfileUseCase,
    required this.updateUserProfileUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  final FetchUserProfileUseCase fetchUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  // Maneja el evento de carga del perfil
  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading()); // Emite estado de carga

    try {
      final String? userId = await _getUserId();
      if (userId == null) {
        emit(ProfileError('User not authenticated'));
        return;
      }

      final UserProfile? userProfile = await fetchUserProfileUseCase(userId);

      if (userProfile != null) {
        emit(ProfileLoaded(userProfile));
      } else {
        emit(ProfileError('Profile not found'));
      }
    } catch (e) {
      emit(ProfileError('Failed to load profile'));
    }
  }

  // Método auxiliar para obtener el UID del usuario
  Future<String?> _getUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final String? userId = await _getUserId();
    if (userId == null) {
      emit(ProfileError('User not authenticated'));
      return;
    }
    try {
      await updateUserProfileUseCase(event.updatedProfile);
      final String? userId = await _getUserId();
      if (userId != null) {
        final UserProfile? updatedProfile =
            await fetchUserProfileUseCase(userId);
        if (updatedProfile != null) {
          emit(ProfileLoaded(updatedProfile));
        } else {
          emit(ProfileError('Failed to retrieve updated profile'));
        }
      } else {
        emit(ProfileError('User not authenticated'));
      }
    } catch (e) {
      emit(ProfileError('Failed to update profile'));
    }
  }

  @override
  void reset() {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(ProfileInitial());
  }
}
