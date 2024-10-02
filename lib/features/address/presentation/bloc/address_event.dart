import 'package:eco_bites/features/address/domain/models/address.dart';

abstract class AddressEvent {}

class SaveAddress extends AddressEvent {
  SaveAddress(this.address);
  final Address address;
}

class LoadAddress extends AddressEvent {}

class ClearAddress extends AddressEvent {}
