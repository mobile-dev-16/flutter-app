import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/orders/domain/entities/order.dart';
import 'package:eco_bites/features/orders/domain/repositories/order_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateOrderStatus {
  const UpdateOrderStatus(this.repository);

  final OrderRepository repository;

  Future<Either<Failure, void>> call(UpdateOrderStatusParams params) async {
    return repository.updateOrderStatus(params.orderId, params.newStatus);
  }
}

class UpdateOrderStatusParams extends Equatable {
  const UpdateOrderStatusParams({
    required this.orderId,
    required this.newStatus,
  });

  final String orderId;
  final OrderStatus newStatus;

  @override
  List<Object?> get props => [orderId, newStatus];
}
