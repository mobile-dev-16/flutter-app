import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {

  LoginFailure(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => <Object?>[errorMessage];
}
