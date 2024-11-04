import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/blocs/resettable_mixin.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/address/domain/entities/address.dart';
import 'package:eco_bites/features/address/domain/usecases/fetch_user_addresses_usecase.dart';

import 'package:eco_bites/features/address/domain/usecases/save_address_usecase.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_event.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState>
    with ResettableMixin<AddressEvent, AddressState> {
  AddressBloc({
    required this.saveAddressUseCase,
    required this.fetchUserAddressUseCase,
  }) : super(AddressInitial()) {
    on<SaveAddress>(_onSaveAddress);
    on<LoadAddress>(_onLoadAddress);
    on<UpdateCurrentLocation>(_onUpdateCurrentLocation);
    on<ClearAddress>(_onClearAddress);
  }

  final SaveAddressUseCase saveAddressUseCase;
  final FetchUserAddressUseCase fetchUserAddressUseCase;

  Future<String?> _getUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
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

      emit(AddressLoaded(event.address));
    } catch (e) {
      if (e is ServerFailure) {
        emit(AddressError('Failed to save address: Server Error'));
      } else if (e is NetworkFailure) {
        emit(AddressError('Failed to save address: Network Error'));
      } else {
        emit(AddressError('Failed to save address: $e'));
      }
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

      final Either<Failure, Address?> result =
          await fetchUserAddressUseCase(FetchUserAddressParams(userId: userId));
      result.fold(
        (Failure failure) {
          if (Failure is ServerFailure) {
            emit(AddressError('Failed to load address: Server Error'));
          } else if (Failure is NetworkFailure) {
            emit(AddressError('Failed to load address: Network Error'));
          } else {
            emit(AddressError('Failed to load address: $failure'));
          }
        },
        (Address? address) {
          if (address != null) {
            emit(AddressLoaded(address));
          } else {
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

  @override
  void reset() {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(AddressInitial());
  }
}
