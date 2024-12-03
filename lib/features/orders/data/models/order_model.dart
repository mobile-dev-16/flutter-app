import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/features/orders/domain/entities/order.dart'
    as order_entity;

class OrderModel extends order_entity.Order {
  const OrderModel({
    required super.id,
    required super.businessId,
    String? businessName,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
    super.completedAt,
  }) : super(
          businessName: businessName ?? '',
        );

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      businessId: map['businessId'] as String,
      businessName: map['businessName'] as String,
      items: (map['items'] as List<dynamic>)
          .map(
            (dynamic item) =>
                OrderItemModel.fromMap(item as Map<String, dynamic>),
          )
          .toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      status: order_entity.OrderStatus.values.firstWhere(
        (order_entity.OrderStatus s) => s.name == (map['status'] as String),
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      completedAt: map['completedAt'] != null
          ? (map['completedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'businessId': businessId,
      'businessName': businessName,
      'items': items
          .map(
            (order_entity.OrderItem item) => (item as OrderItemModel).toMap(),
          )
          .toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      if (completedAt != null) 'completedAt': Timestamp.fromDate(completedAt!),
    };
  }
}

class OrderItemModel extends order_entity.OrderItem {
  const OrderItemModel({
    required super.id,
    required super.name,
    required super.quantity,
    required super.price,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      price: (map['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
