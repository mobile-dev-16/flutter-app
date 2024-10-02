class Address {
  Address({
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    this.deliveryDetails,
  });

  // Create Address object from Firebase map
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      fullAddress: map['fullAddress'] ?? '',
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
      deliveryDetails: map['deliveryDetails'],
    );
  }

  final String fullAddress;
  final double latitude;
  final double longitude;
  final String? deliveryDetails;

  // Convert Address to Map for Firebase
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullAddress': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'deliveryDetails': deliveryDetails,
    };
  }
}
