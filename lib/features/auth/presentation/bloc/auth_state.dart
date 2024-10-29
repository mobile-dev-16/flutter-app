// auth_state.dart
import 'package:eco_bites/features/auth/domain/entities/user.dart';

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
