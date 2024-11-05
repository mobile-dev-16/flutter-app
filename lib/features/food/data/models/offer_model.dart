import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/features/food/domain/entities/diet_type.dart';
import 'package:eco_bites/features/food/domain/entities/offer.dart';

class OfferModel extends Offer {
  const OfferModel({
    required super.id,
    required super.businessId,
    required super.description,
    required super.imageUrl,
    required super.normalPrice,
    required super.offerPrice,
    required super.availableQuantity,
    required super.validUntil,
    required super.suitableFor,
  });

  factory OfferModel.fromMap(
    Map<String, dynamic> map,
    String id,
    String businessId,
  ) {
    return OfferModel(
      id: id,
      businessId: businessId,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String?,
      normalPrice: (map['normalPrice'] as num).toDouble(),
      offerPrice: (map['offerPrice'] as num).toDouble(),
      availableQuantity: map['availableQuantity'] as int,
      validUntil: (map['validUntil'] as Timestamp).toDate(),
      suitableFor: (map['suitableFor'] as List<dynamic>?)
              ?.map(
                (dynamic diet) => DietTypeExtension.fromString(diet as String),
              )
              .toList() ??
          <DietType>[DietType.none],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'imageUrl': imageUrl,
      'normalPrice': normalPrice,
      'offerPrice': offerPrice,
      'availableQuantity': availableQuantity,
      'validUntil': Timestamp.fromDate(validUntil),
      'suitableFor': suitableFor.map((DietType diet) => diet.name).toList(),
    };
  }

  static OfferModel fromEntity(Offer entity) {
    return OfferModel(
      id: entity.id,
      businessId: entity.businessId,
      description: entity.description,
      imageUrl: entity.imageUrl,
      normalPrice: entity.normalPrice,
      offerPrice: entity.offerPrice,
      availableQuantity: entity.availableQuantity,
      validUntil: entity.validUntil,
      suitableFor: entity.suitableFor,
    );
  }
}
