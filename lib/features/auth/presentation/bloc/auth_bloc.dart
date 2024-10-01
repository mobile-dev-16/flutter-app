import 'package:eco_bites/features/auth/presentation/bloc/auth_event.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_state.dart';
import 'package:eco_bites/features/auth/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested); // Added event for sign up
    on<SignUpWithGoogleRequested>(_onSignUpWithGoogleRequested); // Added event for Google sign up
    on<SignOutRequested>(_onSignOutRequested);
  }

  final AuthRepository authRepository;

  // Handle sign-in request
  Future<void> _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final User? user = await authRepository.signIn(email: event.email, password: event.password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Sign in failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Handle sign-up request with email and password
  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final User? user = await authRepository.signUp(email: event.email, password: event.password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Sign up failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Handle sign-up with Google
  Future<void> _onSignUpWithGoogleRequested(SignUpWithGoogleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final User? user = await authRepository.signUpWithGoogle();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Sign up with Google failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Handle sign-out request
  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    await authRepository.signOut();
    emit(AuthUnauthenticated());
  }
}
