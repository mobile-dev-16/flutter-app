import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.userId,
    required this.name,
    required this.surname,
    required this.citizenId,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.favoriteCuisine,
    required this.dietType,
  });

  // Método fromMap con manejo de Timestamp para birthDate
  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      userId: data['userId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      surname: data['surname'] as String? ?? '',
      citizenId: data['citizenId'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      birthDate: (data['birthDate'] is Timestamp)
          ? (data['birthDate'] as Timestamp).toDate()
          : DateTime.now(),
      favoriteCuisine: CuisineTypeExtension.fromString(data['favoriteCuisine'] as String? ?? 'other'),
      dietType: data['dietType'] as String? ?? 'Unknown',
    );
  }

  final String userId;
  final String name;
  final String surname;
  final String citizenId;
  final String email;
  final String phone;
  final DateTime birthDate;
  final CuisineType favoriteCuisine;
  final String dietType;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'surname': surname,
      'citizenId': citizenId,
      'email': email,
      'phone': phone,
      'birthDate': birthDate,
      'favoriteCuisine': favoriteCuisine.name,
      'dietType': dietType,
    };
  }

  @override
  List<Object> get props => <Object>[
        userId,
        name,
        surname,
        citizenId,
        email,
        phone,
        birthDate,
        favoriteCuisine,
        dietType,
      ];
}
