import 'package:eco_bites/features/address/domain/models/address.dart';

abstract class AddressEvent {}

class SaveAddress extends AddressEvent {
  SaveAddress({required this.userId, required this.address});
  final String userId; // Add userId to this event
  final Address address;
}

class LoadAddresses extends AddressEvent {
  LoadAddresses(this.userId);
  final String userId;
}

class UpdateCurrentAddress extends AddressEvent {
  final Address address;

  UpdateCurrentAddress(this.address);

  @override
  List<Object> get props => [address];
}
