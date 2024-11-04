import 'package:eco_bites/features/address/domain/entities/address.dart';

abstract class AddressEvent {}

class SaveAddress extends AddressEvent {
  SaveAddress(this.address,  {required this.userId});
  final Address address;
  final String userId;
}

class LoadAddress extends AddressEvent {}

class ClearAddress extends AddressEvent {}

class UpdateCurrentLocation extends AddressEvent {
  UpdateCurrentLocation(this.currentLocation);
  final Address currentLocation;
}
