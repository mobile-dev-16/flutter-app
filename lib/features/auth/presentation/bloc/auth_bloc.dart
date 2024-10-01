import 'package:eco_bites/features/auth/presentation/bloc/auth_event.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_state.dart';
import 'package:eco_bites/features/auth/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignUpWithGoogleRequested>(_onSignUpWithGoogleRequested);  // Sign up with Google
    on<SignInWithGoogleRequested>(_onSignInWithGoogleRequested);  // Sign in with Google
    on<SignOutRequested>(_onSignOutRequested);
  }

  final AuthRepository authRepository;

  // Handle sign-in request with email and password
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
      if (e is FirebaseAuthException) {
        emit(AuthError(e.message ?? 'An authentication error occurred'));
      } else {
        emit(AuthError('An unexpected error occurred'));
      }
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
      if (e is FirebaseAuthException) {
        emit(AuthError(e.message ?? 'An authentication error occurred'));
      } else {
        emit(AuthError('An unexpected error occurred'));
      }
    }
  }

  // Handle sign-up with Google (forces account selection)
  Future<void> _onSignUpWithGoogleRequested(SignUpWithGoogleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final User? user = await authRepository.signUpWithGoogle(); // Forces account chooser
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Sign up with Google failed'));
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(e.message ?? 'An authentication error occurred'));
      } else {
        emit(AuthError('An unexpected error occurred'));
      }
    }
  }

  // Handle sign-in with Google (remembers the account or tries silent login)
  Future<void> _onSignInWithGoogleRequested(SignInWithGoogleRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final User? user = await authRepository.signInWithGoogle(); // Silent sign-in or recall
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Sign in with Google failed'));
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(e.message ?? 'An authentication error occurred'));
      } else {
        emit(AuthError('An unexpected error occurred'));
      }
    }
  }

  // Handle sign-out request
  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Failed to sign out'));
    }
  }
}
