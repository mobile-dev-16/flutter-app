part of 'internet_connection_bloc.dart';

abstract class InternetConnectionState extends Equatable {
  const InternetConnectionState();

  @override
  List<Object> get props => <Object>[];
}

class InternetConnectionInitial extends InternetConnectionState {}

class ConnectedInternet extends InternetConnectionState {
  const ConnectedInternet({required this.message});
  final String message;

  @override
  List<Object> get props => <Object>[message];
}

class DisconnectedInternet extends InternetConnectionState {
  const DisconnectedInternet({required this.message});
  final String message;

  @override
  List<Object> get props => <Object>[message];
}
