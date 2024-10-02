import 'package:eco_bites/features/address/domain/models/address.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  AddressLoaded(this.savedAddress, {this.currentLocation});
  final Address savedAddress;
  final Address? currentLocation;
}

class AddressError extends AddressState {
  AddressError(this.message);
  final String message;
}
