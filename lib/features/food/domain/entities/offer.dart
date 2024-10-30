import 'package:equatable/equatable.dart';

class Offer extends Equatable {
  const Offer({
    required this.id,
    required this.businessId,
    // required this.title,
    required this.description,
    this.imageUrl,
    required this.normalPrice,
    required this.offerPrice,
    required this.availableQuantity,
    required this.validUntil,
  });

  final String id;
  final String businessId;
  // final String title;
  final String description;
  final String? imageUrl;
  final double normalPrice;
  final double offerPrice;
  final int availableQuantity;
  final DateTime validUntil;

  @override
  List<Object?> get props => <Object?>[
        id,
        businessId,
        // title,
        description,
        imageUrl,
        normalPrice,
        offerPrice,
        availableQuantity,
        validUntil,
      ];
}
