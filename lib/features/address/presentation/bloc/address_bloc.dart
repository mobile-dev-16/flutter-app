import 'package:eco_bites/features/address/domain/address.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_event.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_state.dart';
import 'package:eco_bites/features/address/repository/address_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {

  AddressBloc(this.repository) : super(AddressInitial()) {
    on<SaveAddress>(_onSaveAddress);
    on<LoadAddresses>(_onLoadAddresses);
  }

  final AddressRepository repository;

  // Handle saving the address
  Future<void> _onSaveAddress(SaveAddress event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      // Make sure to pass both the userId and the Address object
      await repository.saveAddress(event.userId, event.address);
      emit(AddressSaved());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  // Handle loading addresses
  Future<void> _onLoadAddresses(LoadAddresses event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      final List<Address> addresses = await repository.fetchUserAddresses(event.userId);
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}
