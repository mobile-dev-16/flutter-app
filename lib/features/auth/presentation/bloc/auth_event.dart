// auth_event.dart
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';

abstract class AuthEvent {}

class SignInRequested extends AuthEvent {
  SignInRequested({required this.email, required this.password});

  final String email;
  final String password;
}

class SignUpRequested extends AuthEvent {
  SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.surname,
    required this.citizenId,
    required this.phone,
    required this.birthDate,
    required this.favoriteCuisine,
  });

  final String email;
  final String password;
  final String name;
  final String surname;
  final String citizenId;
  final String phone;
  final DateTime birthDate;
  final CuisineType favoriteCuisine;
}

class SignInWithGoogleRequested extends AuthEvent {}

class SignUpWithGoogleRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}
