import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/address/domain/entities/address.dart';
import 'package:eco_bites/features/address/domain/usecases/fetch_user_addresses_usecase.dart';
import 'package:eco_bites/features/address/domain/usecases/save_address_usecase.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_event.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc({
    required this.saveAddressUseCase,
    required this.fetchUserAddressesUseCase,
  }) : super(AddressInitial()) {
    on<SaveAddress>(_onSaveAddress);
    on<LoadAddress>(_onLoadAddress);
    on<UpdateCurrentLocation>(_onUpdateCurrentLocation);
    on<ClearAddress>(_onClearAddress);
  }
  final SaveAddressUseCase saveAddressUseCase;
  final FetchUserAddressesUseCase fetchUserAddressesUseCase;

  Future<String?> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> _onSaveAddress(
    SaveAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final String? userId = await _getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      await saveAddressUseCase(
        SaveAddressParams(
          userId: userId,
          address: event.address,
        ),
      );

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
      final String? userId = await _getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final Either<Failure, List<Address>> result =
          await fetchUserAddressesUseCase(
        FetchUserAddressesParams(userId: userId),
      );
      result.fold(
        (Failure failure) => emit(AddressError(failure.toString())),
        (List<Address> addresses) {
          Logger().i('==> Addresses: $addresses');
          if (addresses.isNotEmpty) {
            Logger().i('==> AddressLoaded because addresses is not empty');
            emit(AddressLoaded(addresses.first));
          } else {
            Logger().i('==> AddressInitial because addresses is empty');
            emit(AddressInitial());
          }
        },
      );
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
