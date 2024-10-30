import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/features/food/domain/entities/offer.dart';

class OfferModel extends Offer {
  const OfferModel({
    required super.id,
    required super.businessId,
    // required super.title,
    required super.description,
    required super.imageUrl,
    required super.normalPrice,
    required super.offerPrice,
    required super.availableQuantity,
    required super.validUntil,
  });

  factory OfferModel.fromMap(
    Map<String, dynamic> map,
    String id,
    String businessId,
  ) {
    return OfferModel(
      id: id,
      businessId: businessId,
      // title: map['title'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String?,
      normalPrice: (map['normalPrice'] as num).toDouble(),
      offerPrice: (map['offerPrice'] as num).toDouble(),
      availableQuantity: map['availableQuantity'] as int,
      validUntil: (map['validUntil'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'normalPrice': normalPrice,
      'offerPrice': offerPrice,
      'availableQuantity': availableQuantity,
      'validUntil': Timestamp.fromDate(validUntil),
    };
  }

  static OfferModel fromEntity(Offer entity) {
    return OfferModel(
      id: entity.id,
      businessId: entity.businessId,
      // title: entity.title,
      description: entity.description,
      imageUrl: entity.imageUrl,
      normalPrice: entity.normalPrice,
      offerPrice: entity.offerPrice,
      availableQuantity: entity.availableQuantity,
      validUntil: entity.validUntil,
    );
  }
}
