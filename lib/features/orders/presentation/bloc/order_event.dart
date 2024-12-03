import 'package:eco_bites/features/orders/data/models/order_model.dart';
import 'package:eco_bites/features/orders/domain/entities/order.dart';
import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadOrders extends OrderEvent {}

class UpdateOrder extends OrderEvent {
  const UpdateOrder({
    required this.orderId,
    required this.newStatus,
  });

  final String orderId;
  final OrderStatus newStatus;

  @override
  List<Object?> get props => <Object?>[orderId, newStatus];
}

class CreateOrderEvent extends OrderEvent {
  const CreateOrderEvent({required this.order});

  final OrderModel order;

  @override
  List<Object?> get props => <Object?>[order];
}
