// auth_event.dart
abstract class AuthEvent {}

class SignInRequested extends AuthEvent {

  SignInRequested({required this.email, required this.password});

  final String email;
  final String password;

}

class SignUpRequested extends AuthEvent {

  SignUpRequested({required this.email, required this.password});

  final String email;
  final String password;

}

class SignUpWithGoogleRequested extends AuthEvent {}
class SignOutRequested extends AuthEvent {}
