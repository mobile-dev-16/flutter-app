// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';
import 'package:eco_bites/features/profile/domain/usecases/fetch_user_profile_usecase.dart';
import 'package:eco_bites/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_event.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
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
    await _checkAndSaveCachedProfile();
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
      final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // Save to cache
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('cachedProfile', event.updatedProfile.toMap().toString());
        emit(ProfileError('No internet connection. Your data will be saved when you are online.'));
      } else {
        await updateUserProfileUseCase(event.updatedProfile);
        final UserProfile? updatedProfile = await fetchUserProfileUseCase(userId);
        if (updatedProfile != null) {
          emit(ProfileLoaded(updatedProfile, isUpdated: true));
        } else {
          emit(ProfileError('Failed to retrieve updated profile'));
        }
      }
    } catch (e) {
      emit(ProfileError('Failed to update profile'));
    }
  }

  Future<void> _checkAndSaveCachedProfile() async {
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? cachedProfileString = prefs.getString('cachedProfile');
      if (cachedProfileString != null) {
        final Map<String, dynamic> cachedProfileMap = jsonDecode(cachedProfileString);
        final UserProfile cachedProfile = UserProfile.fromMap(cachedProfileMap);
        await updateUserProfileUseCase(cachedProfile);
        await prefs.remove('cachedProfile');
      }
    }
  }
}
