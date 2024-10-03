import 'package:eco_bites/features/food/domain/models/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/models/offer.dart';

class FoodBusiness {
  FoodBusiness({
    required this.id,
    required this.name,
    required this.cuisineType,
    required this.latitude,
    required this.longitude,
    required this.offers,
    this.imageUrl,
  });
  final String id;
  final String name;
  final CuisineType cuisineType;
  final double latitude;
  final double longitude;
  final List<Offer> offers;
  final String? imageUrl;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'cuisineType': cuisineType.displayName,
      'latitude': latitude,
      'longitude': longitude,
      'offers': offers.map((Offer offer) => offer.toMap()).toList(),
      'imageUrl': imageUrl,
    };
  }

  factory FoodBusiness.fromMap(Map<String, dynamic> map, String id) {
    return FoodBusiness(
      id: id,
      name: map['name'] as String,
      cuisineType: CuisineType.values.firstWhere(
        (e) => e.displayName == map['cuisineType'],
        orElse: () => CuisineType.local,
      ),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      offers: (map['offers'] as List<dynamic>)
          .map((offerMap) => Offer.fromMap(
              offerMap as Map<String, dynamic>, offerMap['id'] as String, id))
          .toList(),
      imageUrl: map['imageUrl'] as String?,
    );
  }
}
