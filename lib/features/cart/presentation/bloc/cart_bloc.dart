import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_event.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(List<CartItemData> initialItems)
      : super(CartState(items: initialItems)) {
    on<AddToCart>(_onAddToCart);
    on<CartItemQuantityChanged>(_onCartItemQuantityChanged);
    on<CartItemRemoved>(_onCartItemRemoved);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    CartItemData? existingItem;
    try {
      existingItem = state.items.firstWhere((item) => item.id == event.item.id);
    } catch (e) {
      existingItem = null;
    }

    if (existingItem != null) {
      final updatedItems = state.items.map((item) {
        if (item.id == event.item.id) {
          return item.copyWith(quantity: item.quantity + event.item.quantity);
        }
        return item;
      }).toList();
      emit(CartState(items: updatedItems));
    } else {
      final updatedItems = List<CartItemData>.from(state.items)
        ..add(event.item);
      emit(CartState(items: updatedItems));
    }
  }

  // Existing handlers (no changes needed for these)
  void _onCartItemQuantityChanged(
      CartItemQuantityChanged event, Emitter<CartState> emit) {
    final updatedItems = state.items.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(quantity: event.quantity);
      }
      return item;
    }).toList();
    emit(CartState(items: updatedItems));
  }

  void _onCartItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final updatedItems =
        state.items.where((item) => item.id != event.itemId).toList();
    emit(CartState(items: updatedItems));
  }
}
