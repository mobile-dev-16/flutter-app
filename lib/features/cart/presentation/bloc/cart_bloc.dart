import 'package:eco_bites/core/blocs/resettable_mixin.dart';
import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_event.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState>
    with ResettableMixin<CartEvent, CartState> {
  CartBloc(final List<CartItemData> initialItems)
      : super(CartState(items: initialItems)) {
    on<CartItemQuantityChanged>(_onCartItemQuantityChanged);
    on<CartItemRemoved>(_onCartItemRemoved);
  }

  void _onCartItemQuantityChanged(
    CartItemQuantityChanged event,
    Emitter<CartState> emit,
  ) {
    final List<CartItemData> updatedItems =
        state.items.map((CartItemData item) {
      if (item.id == event.itemId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();
    emit(CartState(items: updatedItems));
  }

  void _onCartItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final List<CartItemData> updatedItems = state.items
        .where((CartItemData item) => item.id != event.itemId)
        .toList();
    emit(CartState(items: updatedItems));
  }

  @override
  void reset() {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(const CartState(items: <CartItemData>[]));
  }
}
