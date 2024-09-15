import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => <Object>[];
}

class SplashInitial extends SplashState {}

class Authenticated extends SplashState {}

class Unauthenticated extends SplashState {}
