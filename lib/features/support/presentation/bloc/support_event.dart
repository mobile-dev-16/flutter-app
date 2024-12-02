part of 'support_bloc.dart';

abstract class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object> get props => <Object>[];
}

class SubmitTicketEvent extends SupportEvent {
  const SubmitTicketEvent({
    required this.category,
    required this.subOption,
    required this.reason,
    required this.description,
  });
  final String category;
  final String subOption;
  final String reason;
  final String description;

  @override
  List<Object> get props => <Object>[category, subOption, reason, description];
}

class RetryCachedTicketsEvent extends SupportEvent {}
