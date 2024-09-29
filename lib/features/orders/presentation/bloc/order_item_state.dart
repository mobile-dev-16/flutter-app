import 'package:equatable/equatable.dart';

enum OrderItemStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}
class OrderItemState extends Equatable {
  const OrderItemState({required this.status});
  final OrderItemStatus status;

  @override
  List<Object> get props => <Object>[status];
}
