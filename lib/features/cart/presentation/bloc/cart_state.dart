import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  const CartState({required this.items});

  final List<CartItemData> items;

  // Calculate subtotal as the sum of offer prices times quantity for each item
  double get subtotal => items.fold(
        0.0,
        (sum, item) => sum + (item.offerPrice * item.quantity),
      );

  @override
  List<Object?> get props => <Object>[items];

  CartState copyWith({List<CartItemData>? items}) {
    return CartState(
      items: items ?? this.items,
    );
  }
}
