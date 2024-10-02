import 'package:eco_bites/features/address/presentation/bloc/address_event.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressInitial()) {
    on<SaveAddress>(_onSaveAddress);
    on<LoadAddress>(_onLoadAddress);
    on<UpdateCurrentLocation>(_onUpdateCurrentLocation);
    on<ClearAddress>(_onClearAddress);
  }

  Future<void> _onSaveAddress(
    SaveAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final AddressState currentState = state;
      if (currentState is AddressLoaded) {
        emit(
          AddressLoaded(
            event.address,
            currentLocation: currentState.currentLocation,
          ),
        );
      } else {
        emit(AddressLoaded(event.address));
      }
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

  Future<void> _onUpdateCurrentLocation(
    UpdateCurrentLocation event,
    Emitter<AddressState> emit,
  ) async {
    final AddressState currentState = state;
    if (currentState is AddressLoaded) {
      emit(
        AddressLoaded(
          currentState.savedAddress,
          currentLocation: event.currentLocation,
        ),
      );
    }
  }

  void _onClearAddress(ClearAddress event, Emitter<AddressState> emit) {
    emit(AddressInitial());
  }
}
