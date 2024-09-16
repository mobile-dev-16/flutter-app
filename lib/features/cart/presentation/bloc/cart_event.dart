import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => <Object>[];
}

class CartItemQuantityChanged extends CartEvent {
  const CartItemQuantityChanged(this.itemId, this.quantity);
  final String itemId;
  final int quantity;

  @override
  List<Object?> get props => <Object>[itemId, quantity];
}

class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.itemId);
  final String itemId;

  @override
  List<Object?> get props => <Object>[itemId];
}
