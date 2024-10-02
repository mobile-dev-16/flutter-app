import 'package:eco_bites/features/address/domain/address.dart';

abstract class AddressEvent {}

class SaveAddress extends AddressEvent {

  SaveAddress({required this.userId, required this.address});
  final String userId;  // Add userId to this event
  final Address address;
}

class LoadAddresses extends AddressEvent {

  LoadAddresses(this.userId);
  final String userId;
}
