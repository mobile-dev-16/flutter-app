import 'package:eco_bites/core/blocs/resettable_mixin.dart';
import 'package:eco_bites/core/utils/analytics_logger.dart';
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
    on<PurchaseCartEvent>(_onPurchaseCart);
  }

  final OrderBloc orderBloc;

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    AnalyticsLogger.logEvent(
      eventName: 'clear_cart',
      additionalData: <String, dynamic>{
        'item_count': state.items.length,
        'total_amount': state.subtotal,
      },
    );
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

    final List<CartItemData> updatedItems = <CartItemData>[...state.items];
    if (existingItem != null) {
      final int index = updatedItems.indexOf(existingItem);
      updatedItems[index] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      updatedItems.add(event.item);
    }

    AnalyticsLogger.logEvent(
      eventName: 'add_to_cart',
      additionalData: <String, dynamic>{
        'item_id': event.item.id,
        'item_name': event.item.title,
        'business_id': event.item.businessId,
        'price': event.item.offerPrice,
        'is_new_item': existingItem == null,
      },
    );

    emit(CartState(items: updatedItems));
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

    AnalyticsLogger.logEvent(
      eventName: 'update_cart_quantity',
      additionalData: <String, dynamic>{
        'item_id': event.itemId,
        'new_quantity': event.quantity,
        'previous_quantity': state.items
            .firstWhere((CartItemData item) => item.id == event.itemId)
            .quantity,
      },
    );

    emit(CartState(items: updatedItems));
  }

  void _onCartItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final CartItemData removedItem =
        state.items.firstWhere((CartItemData item) => item.id == event.itemId);

    AnalyticsLogger.logEvent(
      eventName: 'remove_from_cart',
      additionalData: <String, dynamic>{
        'item_id': event.itemId,
        'item_name': removedItem.title,
        'business_id': removedItem.businessId,
        'quantity': removedItem.quantity,
        'price': removedItem.offerPrice,
      },
    );

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

      AnalyticsLogger.logEvent(
        eventName: 'create_order',
        additionalData: <String, dynamic>{
          'business_id': order.businessId,
          'item_count': order.items.length,
          'total_amount': order.totalAmount,
        },
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
