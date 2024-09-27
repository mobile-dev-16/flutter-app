import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class LoginSubmitted extends LoginEvent {

  LoginSubmitted({required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object> get props => <Object>[username, password];
}
