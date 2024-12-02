part of 'support_bloc.dart';

abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object> get props => <Object>[];
}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class SupportSuccess extends SupportState {}

class SupportFailure extends SupportState {
  const SupportFailure({required this.error});
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class SupportCached extends SupportState {

  const SupportCached({required this.message});
  final String message;

  @override
  List<Object> get props => <Object>[message];
}
