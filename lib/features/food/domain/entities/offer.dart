import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:equatable/equatable.dart';

class Offer extends Equatable {
  const Offer({
    required this.id,
    required this.businessId,
    required this.description,
    this.imageUrl,
    required this.normalPrice,
    required this.offerPrice,
    required this.availableQuantity,
    required this.validUntil,
  });

  final String id;
  final String businessId;
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
        description,
        imageUrl,
        normalPrice,
        offerPrice,
        availableQuantity,
        validUntil,
      ];
}

// Extension to convert Offer to CartItemData
extension OfferExtensions on Offer {
  CartItemData toCartItem() {
    return CartItemData(
      id: id,
      title: description,
      normalPrice: normalPrice,
      offerPrice: offerPrice,
      imageUrl: imageUrl,
      quantity: 1, // Default quantity when adding to cart
    );
  }
}
