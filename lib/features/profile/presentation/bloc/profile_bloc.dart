import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';
import 'package:eco_bites/features/profile/domain/usecases/fetch_user_profile_usecase.dart';
import 'package:eco_bites/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_event.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        throw Exception('Usuario no autenticado');
      }

      final UserProfile? userProfile = await fetchUserProfileUseCase(userId);

      if (userProfile != null) {
        emit(ProfileLoaded(userProfile)); // Emite estado de perfil cargado
      } else {
        emit(ProfileError('No se encontró el perfil')); // Manejo de error
      }
    } catch (e) {
      emit(ProfileError('Error al cargar el perfil: $e')); // Emite un error
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
    try {
      await updateUserProfileUseCase(event.updatedProfile);
      emit(ProfileLoaded(event.updatedProfile));
    } catch (e) {
      emit(ProfileError('Error al actualizar el perfil: $e'));
    }
  }
}
