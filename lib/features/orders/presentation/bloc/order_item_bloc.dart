import 'package:eco_bites/features/orders/presentation/bloc/order_item_event.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_item_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class OrderItemBloc extends Bloc<OrderItemEvent, OrderItemState> {
  OrderItemBloc(OrderItemStatus initialStatus)
      : super(OrderItemState(status: initialStatus)) {
    on<OrderStatusChanged>(_onOrderStatusChanged);
  }

  void _onOrderStatusChanged(
    OrderStatusChanged event,
    Emitter<OrderItemState> emit,
  ) {
    emit(OrderItemState(status: OrderItemStatus.values.firstWhere((OrderItemStatus e) => e.toString() == event.newStatus)));
  }
}
