import 'package:eco_bites/features/address/domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.fullAddress,
    required super.latitude,
    required super.longitude,
    super.deliveryDetails,
  });
  factory AddressModel.fromEntity(Address address) {
    return AddressModel(
      fullAddress: address.fullAddress,
      latitude: address.latitude,
      longitude: address.longitude,
      deliveryDetails: address.deliveryDetails,
    );
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      fullAddress: map['fullAddress'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      deliveryDetails: map['deliveryDetails'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullAddress': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'deliveryDetails': deliveryDetails,
    };
  }
}
