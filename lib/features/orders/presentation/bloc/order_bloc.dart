import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/blocs/resettable_mixin.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/orders/domain/entities/order.dart'
    as order_entity;
import 'package:eco_bites/features/orders/domain/usecases/get_orders.dart';
import 'package:eco_bites/features/orders/domain/usecases/update_order_status.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_event.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState>
    with ResettableMixin<OrderEvent, OrderState> {
  OrderBloc({
    required GetOrders getOrders,
    required UpdateOrderStatus updateOrderStatus,
  })  : _getOrders = getOrders,
        _updateOrderStatus = updateOrderStatus,
        super(OrdersLoading()) {
    on<LoadOrders>(_onLoadOrders);
    on<UpdateOrder>(_onUpdateOrder);
  }

  final GetOrders _getOrders;
  final UpdateOrderStatus _updateOrderStatus;

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(OrdersLoading());

    final Either<Failure, List<order_entity.Order>> result = await _getOrders();

    result.fold(
      (Failure failure) {
        Logger().e('Failed to load orders: ${failure.message}');
        emit(OrdersError(failure.message));
      },
      (List<order_entity.Order> orders) {
        Logger().d('Loaded ${orders.length} orders');
        emit(OrdersLoaded(orders));
      },
    );
  }

  Future<void> _onUpdateOrder(
    UpdateOrder event,
    Emitter<OrderState> emit,
  ) async {
    final OrderState currentState = state;
    if (currentState is OrdersLoaded) {
      emit(OrdersLoading());

      final Either<Failure, void> result = await _updateOrderStatus(
        UpdateOrderStatusParams(
          orderId: event.orderId,
          newStatus: event.newStatus,
        ),
      );

      result.fold(
        (Failure failure) {
          Logger().e('Failed to update order: ${failure.message}');
          emit(OrdersError(failure.message));
        },
        (_) async {
          // Reload orders after successful update
          add(LoadOrders());
        },
      );
    }
  }

  @override
  void reset() {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(OrdersLoading());
  }
}
