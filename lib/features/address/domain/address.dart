class Address {

  Address({
    required this.street,
    required this.city,
    required this.buildingType,
    required this.apartmentName,
    required this.floorUnit,
    required this.latitude,
    required this.longitude,
  });

  // Create Address object from Firebase map
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'],
      city: map['city'],
      buildingType: map['buildingType'],
      apartmentName: map['apartmentName'],
      floorUnit: map['floorUnit'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
  final String street;
  final String city;
  final String buildingType;
  final String apartmentName;
  final String floorUnit;
  final double latitude;
  final double longitude;

  // Convert Address to Map for Firebase
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'street': street,
      'city': city,
      'buildingType': buildingType,
      'apartmentName': apartmentName,
      'floorUnit': floorUnit,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
