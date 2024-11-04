import 'package:eco_bites/features/food/data/models/offer_model.dart';
import 'package:eco_bites/features/food/domain/entities/category.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/entities/food_business.dart';
import 'package:eco_bites/features/food/domain/entities/offer.dart';

class FoodBusinessModel extends FoodBusiness {
  const FoodBusinessModel({
    required super.id,
    required super.name,
    // required super.description,
    super.imageUrl,
    required super.category,
    required super.cuisineType,
    // required super.rating,
    required super.latitude,
    required super.longitude,
    required List<OfferModel> super.offers,
  });

  factory FoodBusinessModel.fromMap(
    Map<String, dynamic> map,
    String id,
    List<OfferModel> offers,
  ) {
    return FoodBusinessModel(
      id: id,
      name: map['name'] as String,
      // description: map['description'] as String,
      imageUrl: map['imageUrl'] as String?,
      category: Category.values.firstWhere(
        (Category category) =>
            category.displayName == (map['category'] as String),
        orElse: () => Category.restaurant,
      ),
      cuisineType: CuisineType.values.firstWhere(
        (CuisineType type) => type.name == (map['cuisineType'] as String),
        orElse: () => CuisineType.other,
      ),
      // rating: (map['rating'] as num).toDouble(),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      offers: offers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      // 'description': description,
      'imageUrl': imageUrl,
      'category': category.displayName,
      'cuisineType': cuisineType.name,
      // 'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static FoodBusinessModel fromEntity(FoodBusiness entity) {
    return FoodBusinessModel(
      id: entity.id,
      name: entity.name,
      // description: entity.description,
      imageUrl: entity.imageUrl,
      category: entity.category,
      cuisineType: entity.cuisineType,
      // rating: entity.rating,
      latitude: entity.latitude,
      longitude: entity.longitude,
      offers: entity.offers
          .map((Offer offer) => OfferModel.fromEntity(offer))
          .toList(),
    );
  }
}
