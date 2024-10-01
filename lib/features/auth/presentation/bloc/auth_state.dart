// auth_state.dart
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {

  AuthAuthenticated(this.user);

  final User user;

}

class AuthError extends AuthState {

  AuthError(this.errorMessage);

  final String errorMessage;

}

class AuthUnauthenticated extends AuthState {}
