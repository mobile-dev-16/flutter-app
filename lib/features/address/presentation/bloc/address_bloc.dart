import 'package:eco_bites/features/address/presentation/bloc/address_event.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressInitial()) {
    on<SaveAddress>(_onSaveAddress);
    on<LoadAddress>(_onLoadAddress);
    on<ClearAddress>(_onClearAddress);
  }

  Future<void> _onSaveAddress(
    SaveAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      emit(AddressLoaded(event.address));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onLoadAddress(
    LoadAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final AddressState currentState = state;
      if (currentState is AddressLoaded) {
        emit(currentState);
      } else {
        emit(AddressInitial());
      }
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  void _onClearAddress(
    ClearAddress event,
    Emitter<AddressState> emit,
  ) {
    emit(AddressInitial());
  }
}
