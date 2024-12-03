import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/orders/data/models/order_model.dart';
import 'package:eco_bites/features/orders/domain/repositories/order_repository.dart';
import 'package:equatable/equatable.dart';

class CreateOrder {
  const CreateOrder(this.repository);

  final OrderRepository repository;

  Future<Either<Failure, void>> call(CreateOrderParams params) async {
    return repository.createOrder(params.order);
  }
}

class CreateOrderParams extends Equatable {
  const CreateOrderParams({required this.order});

  final OrderModel order;

  @override
  List<Object?> get props => <Object?>[order];
}
