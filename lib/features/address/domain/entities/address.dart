import 'package:equatable/equatable.dart';

class Address extends Equatable {
  const Address({
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    this.deliveryDetails,
  });

  final String fullAddress;
  final double latitude;
  final double longitude;
  final String? deliveryDetails;

  @override
  List<Object?> get props => <Object?>[
        fullAddress,
        latitude,
        longitude,
        deliveryDetails,
      ];
}
