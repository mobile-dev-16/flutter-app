class CartItemData {
  CartItemData({
    required this.id,
    this.imageUrl,
    required this.title,
    required this.normalPrice,
    required this.offerPrice,
    this.quantity = 1,
  });
  final String id;
  final String? imageUrl;
  final String title;
  final double normalPrice;
  final double offerPrice;
  int quantity;

  CartItemData copyWith({int? quantity}) {
    return CartItemData(
      id: id,
      imageUrl: imageUrl,
      title: title,
      normalPrice: normalPrice,
      offerPrice: offerPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}
