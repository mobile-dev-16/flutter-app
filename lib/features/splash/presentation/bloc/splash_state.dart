import 'package:equatable/equatable.dart';
abstract class SplashState extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class SplashInitial extends SplashState {}

class Authenticated extends SplashState {}

class Unauthenticated extends SplashState {}

class SplashError extends SplashState {

  SplashError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
