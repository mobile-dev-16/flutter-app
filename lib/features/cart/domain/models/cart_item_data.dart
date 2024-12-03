import 'package:eco_bites/features/food/domain/entities/diet_type.dart';

class CartItemData {
  CartItemData({
    required this.id,
    this.imageUrl,
    required this.title,
    required this.normalPrice,
    required this.offerPrice,
    required this.suitableFor,
    required this.businessId,
    this.quantity = 1,
  });
  final String id;
  final String? imageUrl;
  final String title;
  final double normalPrice;
  final double offerPrice;
  final List<DietType> suitableFor;
  final String businessId;
  int quantity;

  CartItemData copyWith({
    int? quantity,
    List<DietType>? suitableFor,
    String? businessId,
  }) {
    return CartItemData(
      id: id,
      imageUrl: imageUrl,
      title: title,
      normalPrice: normalPrice,
      offerPrice: offerPrice,
      quantity: quantity ?? this.quantity,
      suitableFor: suitableFor ?? this.suitableFor,
      businessId: businessId ?? this.businessId,
    );
  }
}
