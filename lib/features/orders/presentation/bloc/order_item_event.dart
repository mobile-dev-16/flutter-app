import 'package:equatable/equatable.dart';

abstract class OrderItemEvent extends Equatable {
  const OrderItemEvent();

  @override
  List<Object> get props => <Object>[];
}

class OrderStatusChanged extends OrderItemEvent {
  const OrderStatusChanged(this.newStatus);

  final String newStatus;

  @override
  List<Object> get props => <Object>[newStatus];
}
