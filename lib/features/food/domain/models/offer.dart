import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/features/food/domain/models/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/models/offer_type.dart';

class Offer {
  Offer({
    required this.id,
    required this.type,
    required this.cuisineType,
    required this.description,
    required this.availableQuantity,
    required this.normalPrice,
    required this.offerPrice,
    required this.validUntil,
    required this.businessId,
    this.imageUrl,
  });
  final String id;
  final OfferType type;
  final CuisineType cuisineType;
  final String businessId;
  final String description;
  final int availableQuantity;
  final double normalPrice;
  final double offerPrice;
  final DateTime validUntil;
  final String? imageUrl;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.index,
      'description': description,
      'availableQuantity': availableQuantity,
      'normalPrice': normalPrice,
      'offerPrice': offerPrice,
      'validUntil': validUntil.toIso8601String(),
      'cuisineType': cuisineType.index,
      'businessId': businessId,
      'imageUrl': imageUrl,
    };
  }

  static Offer fromMap(Map<String, dynamic> map, String id, String businessId) {
    return Offer(
      id: id,
      type: OfferType.values.firstWhere(
        (OfferType e) => e.toString().split('.').last == map['type'],
        orElse: () => OfferType.values.first,
      ),
      cuisineType: CuisineType.values.firstWhere(
        (CuisineType e) => e.toString().split('.').last == map['cuisineType'],
        orElse: () => CuisineType.values.first,
      ),
      description: map['description'] as String,
      availableQuantity: map['availableQuantity'] as int,
      normalPrice: (map['normalPrice'] as num).toDouble(),
      offerPrice: (map['offerPrice'] as num).toDouble(),
      validUntil: (map['validUntil'] as Timestamp).toDate(),
      businessId: businessId,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  // Add a method to convert the offer to a cart item
  Map<String, dynamic> toCartItem() {
    return <String, dynamic>{
      'id': id,
      'type': type.index,
      'description': description,
      'price': offerPrice,
      'businessId': businessId,
      'imageUrl': imageUrl,
    };
  }
}
