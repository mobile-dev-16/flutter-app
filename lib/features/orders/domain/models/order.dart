class Order {
  Order({
    required this.id,
    required this.title,
    required this.date,
    this.imageUrl,
  });
  final String id;
  final String title;
  final DateTime date;
  final String? imageUrl;

  Order copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? imageUrl,
  }) {
    return Order(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
