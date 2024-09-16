import 'package:equatable/equatable.dart';

abstract class CartItemEvent extends Equatable {
  const CartItemEvent();

  @override
  List<Object> get props => <Object>[];
}

class QuantityChanged extends CartItemEvent {
  const QuantityChanged(this.quantity);
  final int quantity;

  @override
  List<Object> get props => <Object>[quantity];
}
