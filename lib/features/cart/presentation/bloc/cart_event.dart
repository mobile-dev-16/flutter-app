import 'package:equatable/equatable.dart';
import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';

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

class AddToCart extends CartEvent {
  const AddToCart(this.item);
  final CartItemData item;

  @override
  List<Object?> get props => <Object>[item];
}

class ClearCart extends CartEvent {}

class CompletePurchase extends CartEvent {}
