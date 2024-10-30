part of 'internet_connection_bloc.dart';

abstract class InternetConnectionEvent extends Equatable {
  const InternetConnectionEvent();

  @override
  List<Object> get props => <Object>[];
}

class ConnectedEvent extends InternetConnectionEvent {}

class DisconnectedEvent extends InternetConnectionEvent {}
