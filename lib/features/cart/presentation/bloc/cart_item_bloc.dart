import 'package:eco_bites/features/cart/presentation/bloc/cart_item_event.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_item_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemBloc extends Bloc<CartItemEvent, CartItemState> {
  CartItemBloc(int initialQuantity)
      : super(CartItemState(quantity: initialQuantity)) {
    on<QuantityChanged>(_onQuantityChanged);
  }

  void _onQuantityChanged(QuantityChanged event, Emitter<CartItemState> emit) {
    emit(CartItemState(quantity: event.quantity));
  }
}
