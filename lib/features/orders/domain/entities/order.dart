import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  confirmed,
  ready,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class Order extends Equatable {
  const Order({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  final String id;
  final String businessId;
  final String businessName;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  @override
  List<Object?> get props => <Object?>[
        id,
        businessId,
        businessName,
        items,
        totalAmount,
        status,
        createdAt,
        completedAt,
      ];
}

class OrderItem extends Equatable {
  const OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String id;
  final String name;
  final int quantity;
  final double price;

  @override
  List<Object?> get props => <Object?>[id, name, quantity, price];
}
