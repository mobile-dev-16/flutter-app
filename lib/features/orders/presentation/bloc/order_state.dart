import 'package:eco_bites/features/orders/domain/entities/order.dart';
import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => <Object?>[];
}

class OrdersInitial extends OrderState {}

class OrdersLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  const OrdersLoaded(this.orders);

  final List<Order> orders;

  @override
  List<Object?> get props => <Object?>[orders];
}

class OrdersError extends OrderState {
  const OrdersError(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
