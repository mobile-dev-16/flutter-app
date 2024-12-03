import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  const CartState({
    required this.items,
    this.error,
  });

  final List<CartItemData> items;
  final String? error;

  double get subtotal => items.fold(
        0.0,
        (double sum, CartItemData item) =>
            sum + (item.offerPrice * item.quantity),
      );

  @override
  List<Object?> get props => <Object?>[items, error];

  CartState copyWith({
    List<CartItemData>? items,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      error: error,
    );
  }
}
