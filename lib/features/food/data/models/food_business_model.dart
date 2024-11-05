import 'package:eco_bites/features/food/data/models/offer_model.dart';
import 'package:eco_bites/features/food/domain/entities/category.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/entities/food_business.dart';
import 'package:eco_bites/features/food/domain/entities/offer.dart';

class FoodBusinessModel extends FoodBusiness {
  const FoodBusinessModel({
    required super.id,
    required super.name,
    super.imageUrl,
    required super.category,
    required super.cuisineType,
    required super.latitude,
    required super.longitude,
    required List<OfferModel> super.offers,
    required super.isNew, // Pass isNew to the superclass
  });

  factory FoodBusinessModel.fromMap(
    Map<String, dynamic> map,
    String id,
    List<OfferModel> offers,
  ) {
    return FoodBusinessModel(
      id: id,
      name: map['name'] as String,
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
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      offers: offers,
      isNew: map['isNew'] as bool? ??
          false, // Pass the `isNew` field to the superclass
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imageUrl': imageUrl,
      'category': category.displayName,
      'cuisineType': cuisineType.name,
      'latitude': latitude,
      'longitude': longitude,
      'isNew': isNew, // Include "isNew" attribute in the map
    };
  }

  static FoodBusinessModel fromEntity(FoodBusiness entity) {
    return FoodBusinessModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      category: entity.category,
      cuisineType: entity.cuisineType,
      latitude: entity.latitude,
      longitude: entity.longitude,
      offers: entity.offers
          .map((Offer offer) => OfferModel.fromEntity(offer))
          .toList(),
      isNew: (entity as FoodBusinessModel).isNew, // Cast to access isNew
    );
  }
}
