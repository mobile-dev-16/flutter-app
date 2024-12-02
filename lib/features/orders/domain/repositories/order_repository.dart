import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/orders/domain/entities/order.dart'
    as entities;

abstract class OrderRepository {
  Future<Either<Failure, List<entities.Order>>> getOrders();
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    entities.OrderStatus newStatus,
  );
}
