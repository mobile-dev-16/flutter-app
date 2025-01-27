import 'package:eco_bites/features/food/domain/entities/category.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/entities/offer.dart';
import 'package:equatable/equatable.dart';

class FoodBusiness extends Equatable {
  const FoodBusiness({
    required this.id,
    required this.name,
    // required this.description,
    this.imageUrl,
    required this.category,
    required this.cuisineType,
    // required this.rating,
    required this.latitude,
    required this.longitude,
    required this.offers,
    required this.isNew, // Add `isNew` field here
  });

  final String id;
  final String name;
  // final String description;
  final String? imageUrl;
  final Category category;
  final CuisineType cuisineType;
  // final double rating;
  final double latitude;
  final double longitude;
  final List<Offer> offers;
  final bool isNew; // New field to indicate if the business is new

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        // description,
        imageUrl,
        category,
        cuisineType,
        // rating,
        latitude,
        longitude,
        offers,
        isNew, // Include `isNew` in `props` for Equatable comparison
      ];
}
