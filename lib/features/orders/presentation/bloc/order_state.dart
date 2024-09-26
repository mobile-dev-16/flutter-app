import 'package:eco_bites/features/orders/domain/models/order.dart';
import 'package:equatable/equatable.dart';
abstract class OrderState extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class OrdersLoading extends OrderState {}
class OrdersLoaded extends OrderState {
  OrdersLoaded(List<Order>? orders) : orders = orders ?? <Order>[];

  final List<Order> orders;

  @override
  List<Object?> get props => <Object?>[orders];
}
