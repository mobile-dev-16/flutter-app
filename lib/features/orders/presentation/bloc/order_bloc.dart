import 'package:eco_bites/features/orders/domain/models/order.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_event.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrdersLoading()) {
    on<LoadOrders>(_onLoadOrders);
  }

  void _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) {
    emit(OrdersLoading());

    final List<Order> orders = [
      Order(id: '1', title: 'Order 1', date: DateTime(2024, 9, 15)),
      Order(id: '2', title: 'Order 2', date: DateTime(2024, 8, 20)),
      Order(id: '3', title: 'Order 3', date: DateTime(2024, 7, 15)),
      Order(id: '4', title: 'Order 4', date: DateTime(2024, 6, 20)),
      Order(id: '5', title: 'Order 5', date: DateTime(2024, 5, 15)),
      Order(id: '6', title: 'Order 6', date: DateTime(2024, 3, 10)),
      Order(id: '7', title: 'Order 7', date: DateTime(2024, 2, 15)),
      Order(id: '8', title: 'Order 8', date: DateTime(2024, 1, 20)),
      Order(id: '9', title: 'Order 9', date: DateTime(2024, 1, 15)),
      Order(id: '10', title: 'Order 10', date: DateTime(2024, 1, 10)),
    ];

    emit(OrdersLoaded(orders));
  }
}
