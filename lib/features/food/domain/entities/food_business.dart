import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/entities/offer.dart';
import 'package:equatable/equatable.dart';

class FoodBusiness extends Equatable {
  const FoodBusiness({
    required this.id,
    required this.name,
    // required this.description,
    this.imageUrl,
    required this.cuisineType,
    // required this.rating,
    required this.latitude,
    required this.longitude,
    required this.offers,
  });

  final String id;
  final String name;
  // final String description;
  final String? imageUrl;
  final CuisineType cuisineType;
  // final double rating;
  final double latitude;
  final double longitude;
  final List<Offer> offers;

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        // description,
        imageUrl,
        cuisineType,
        // rating,
        latitude,
        longitude,
        offers,
      ];
}
