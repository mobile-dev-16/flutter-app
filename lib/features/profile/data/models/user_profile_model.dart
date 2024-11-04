import 'package:eco_bites/features/address/data/models/address_model.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';

class UserProfile {
  UserProfile({
    required this.name,
    required this.surname,
    required this.citizenId,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.favoriteCuisine,
    required this.diet,
    this.address, // Include address field
  });

  // Add address parameter
  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      citizenId: data['citizenId'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      birthDate: DateTime.parse(data['birthDate'] ?? DateTime.now().toIso8601String()),
      favoriteCuisine: CuisineTypeExtension.fromString(data['favoriteCuisine'] ?? 'other'),
      diet: data['diet'] ?? '',
      address: data['address'] != null
          ? AddressModel.fromMap(data['address'] as Map<String, dynamic>)
          : null, // Convert address from Map
    );
  }

  final String name;
  final String surname;
  final String citizenId;
  final String email;
  final String phone;
  final DateTime birthDate;
  final CuisineType favoriteCuisine;
  final String diet;
  final AddressModel? address; // Optional address field

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'surname': surname,
      'citizenId': citizenId,
      'email': email,
      'phone': phone,
      'birthDate': birthDate.toIso8601String(),
      'favoriteCuisine': favoriteCuisine.name,
      'diet': diet,
      'address': address?.toMap(), // Convert address to Map if it exists
    };
  }
}
