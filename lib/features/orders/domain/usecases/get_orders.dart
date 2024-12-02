import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/orders/domain/entities/order.dart'
    as order_entity;
import 'package:eco_bites/features/orders/domain/repositories/order_repository.dart';

class GetOrders {
  const GetOrders(this.repository);

  final OrderRepository repository;

  Future<Either<Failure, List<order_entity.Order>>> call() async {
    return repository.getOrders();
  }
}
