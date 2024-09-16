import 'package:eco_bites/features/cart/presentation/bloc/quantity_event.dart';
import 'package:eco_bites/features/cart/presentation/bloc/quantity_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuantityBloc extends Bloc<QuantityEvent, QuantityState> {
  QuantityBloc({required int initialValue})
      : super(QuantityState(value: initialValue)) {
    on<QuantityIncreased>(_onQuantityIncreased);
    on<QuantityDecreased>(_onQuantityDecreased);
  }

  void _onQuantityIncreased(
    QuantityIncreased event,
    Emitter<QuantityState> emit,
  ) {
    emit(QuantityState(value: state.value + 1));
  }

  void _onQuantityDecreased(
    QuantityDecreased event,
    Emitter<QuantityState> emit,
  ) {
    if (state.value > 1) {
      emit(QuantityState(value: state.value - 1));
    } else if (state.value == 1) {
      emit(const QuantityState(value: 0));
    }
  }
}
