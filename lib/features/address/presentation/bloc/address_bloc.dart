import 'package:eco_bites/features/address/domain/models/address.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_event.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_state.dart';
import 'package:eco_bites/features/address/repository/address_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc(this.repository) : super(AddressInitial()) {
    print('AddressBloc initialized'); // Add this line
    on<SaveAddress>(_onSaveAddress);
    on<LoadAddresses>(_onLoadAddresses);
    on<UpdateCurrentAddress>(_onUpdateCurrentAddress);
  }

  final AddressRepository repository;

  Future<void> _onSaveAddress(
      SaveAddress event, Emitter<AddressState> emit) async {
    print('SaveAddress event received'); // Add this line
    emit(AddressLoading());
    try {
      await repository.saveAddress(event.userId, event.address);
      print('Address saved successfully');
      print(event.address.fullAddress);
      emit(AddressSaved());
    } catch (e) {
      print('Error saving address: $e'); // Add this line
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onLoadAddresses(
      LoadAddresses event, Emitter<AddressState> emit) async {
    print('LoadAddresses event received'); // Add this line
    emit(AddressLoading());
    try {
      final List<Address> addresses =
          await repository.fetchUserAddresses(event.userId);
      print('Addresses loaded: ${addresses.length}'); // Add this line
      emit(AddressLoaded(addresses));
    } catch (e) {
      print('Error loading addresses: $e'); // Add this line
      emit(AddressError(e.toString()));
    }
  }

  void _onUpdateCurrentAddress(
      UpdateCurrentAddress event, Emitter<AddressState> emit) {
    print(
        'UpdateCurrentAddress event received: ${event.address}'); // Add this line
    emit(CurrentAddressUpdated(event.address));
  }
}
