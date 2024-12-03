import 'package:eco_bites/core/blocs/resettable_mixin.dart';
import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_event.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_state.dart';
import 'package:eco_bites/features/orders/data/models/order_model.dart';
import 'package:eco_bites/features/orders/domain/entities/order.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_bloc.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState>
    with ResettableMixin<CartEvent, CartState> {
  CartBloc({
    required this.orderBloc,
    required List<CartItemData> initialItems,
  }) : super(CartState(items: initialItems)) {
    on<AddToCart>(_onAddToCart);
    on<CartItemQuantityChanged>(_onCartItemQuantityChanged);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<ClearCart>(_onClearCart);
    on<CompletePurchase>(_onCompletePurchase);
    on<PurchaseCartEvent>(_onPurchaseCart);
  }

  final OrderBloc orderBloc;

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(
      const CartState(items: <CartItemData>[]),
    ); // Set items to an empty list
  }

  void _onCompletePurchase(CompletePurchase event, Emitter<CartState> emit) {
    // Here you could add logic to process the purchase
    // For now, it clears the cart to simulate a completed purchase
    emit(const CartState(items: <CartItemData>[]));
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    CartItemData? existingItem;
    try {
      existingItem = state.items
          .firstWhere((CartItemData item) => item.id == event.item.id);
    } catch (e) {
      existingItem = null;
    }

    if (existingItem != null) {
      final List<CartItemData> updatedItems =
          state.items.map((CartItemData item) {
        if (item.id == event.item.id) {
          return item.copyWith(quantity: item.quantity + event.item.quantity);
        }
        return item;
      }).toList();
      emit(CartState(items: updatedItems));
    } else {
      final List<CartItemData> updatedItems =
          List<CartItemData>.from(state.items)..add(event.item);
      emit(CartState(items: updatedItems));
    }
  }

  // Existing handlers (no changes needed for these)
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

  Future<void> _onPurchaseCart(
    PurchaseCartEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state.items.isEmpty) {
      emit(state.copyWith(items: state.items, error: 'Cart is empty'));
      return;
    }

    try {
      final List<OrderItemModel> orderItems =
          state.items.map((CartItemData cartItem) {
        return OrderItemModel(
          id: cartItem.id,
          name: cartItem.title,
          quantity: cartItem.quantity,
          price: cartItem.offerPrice,
        );
      }).toList();

      final double totalAmount = state.items.fold<double>(
        0,
        (double sum, CartItemData item) =>
            sum + (item.offerPrice * item.quantity),
      );

      final OrderModel order = OrderModel(
        id: '', // Will be set by Firestore
        businessId: state.items.first.businessId,
        items: orderItems,
        totalAmount: totalAmount,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      orderBloc.add(CreateOrderEvent(order: order));

      // Clear cart after successful purchase
      emit(const CartState(items: <CartItemData>[]));
    } catch (e) {
      emit(
        state.copyWith(items: state.items, error: 'Failed to create order: $e'),
      );
    }
  }

  @override
  void reset() {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(const CartState(items: <CartItemData>[]));
  }
}
