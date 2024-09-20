import 'package:eco_bites/features/orders/domain/models/order.dart';
import 'package:equatable/equatable.dart';

abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrdersLoading extends OrderState {}

class OrdersLoaded extends OrderState {

  OrdersLoaded(this.orders);
  final List<Order> orders;

  @override
  List<Object?> get props => [orders];
}
