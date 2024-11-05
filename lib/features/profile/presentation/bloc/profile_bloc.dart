// ignore_for_file: unused_element

import 'dart:convert';
import 'package:eco_bites/core/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:eco_bites/core/blocs/resettable_mixin.dart';
import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';
import 'package:eco_bites/features/profile/domain/usecases/fetch_user_profile_usecase.dart';
import 'package:eco_bites/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_event.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>
    with ResettableMixin<ProfileEvent, ProfileState> {
  ProfileBloc({
    required this.fetchUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required InternetConnectionBloc internetConnectionBloc,
  })  : _internetConnectionBloc = internetConnectionBloc,
        super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  final InternetConnectionBloc _internetConnectionBloc;
  final FetchUserProfileUseCase fetchUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

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
      if (_internetConnectionBloc.state is DisconnectedInternet) {
        // Save to cache
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'cachedProfile',
          jsonEncode(event.updatedProfile.toMap()),
        );
        emit(
          ProfileError(
            'No internet connection. Your data will be saved when you are online.',
          ),
        );
      } else {
        await updateUserProfileUseCase(event.updatedProfile);
        final UserProfile? updatedProfile =
            await fetchUserProfileUseCase(userId);
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

  Future<void> _checkAndSaveCachedProfile(Emitter<ProfileState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cachedProfileString = prefs.getString('cachedProfile');
    if (cachedProfileString != null) {
      final Map<String, dynamic> cachedProfileMap =
          jsonDecode(cachedProfileString);
      final UserProfile cachedProfile = UserProfile.fromMap(cachedProfileMap);
      try {
        await updateUserProfileUseCase(cachedProfile);
        await prefs.remove('cachedProfile');
        final UserProfile? updatedProfile =
            await fetchUserProfileUseCase(cachedProfile.userId);
        if (updatedProfile != null) {
          emit(ProfileLoaded(updatedProfile, isUpdated: true));
        }
      } catch (e) {
        emit(ProfileError('Failed to update cached profile'));
      }
    }
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

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

  @override
  void reset() {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(ProfileInitial());
  }
}
