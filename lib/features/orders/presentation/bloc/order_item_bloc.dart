import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderItemState extends Equatable {

  const OrderItemState({required this.status});
  final String status;

  @override
  List<Object> get props => <Object>[status];
}

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

class OrderItemBloc extends Bloc<OrderItemEvent, OrderItemState> {
  OrderItemBloc(String initialStatus)
      : super(OrderItemState(status: initialStatus)) {
    on<OrderStatusChanged>(_onOrderStatusChanged);
  }

  void _onOrderStatusChanged(
    OrderStatusChanged event,
    Emitter<OrderItemState> emit,
  ) {
    emit(OrderItemState(status: event.newStatus));
  }
}
