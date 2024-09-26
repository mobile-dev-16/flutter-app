import 'package:equatable/equatable.dart';

class OrderItemState extends Equatable {
  const OrderItemState({required this.status});

  final String status;

  @override
  List<Object> get props => <Object>[status];
}
