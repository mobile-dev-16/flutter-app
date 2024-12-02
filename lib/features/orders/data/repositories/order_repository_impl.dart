import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/core/network/network_info.dart';
import 'package:eco_bites/features/orders/data/datasources/order_local_data_source.dart';
import 'package:eco_bites/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:eco_bites/features/orders/data/models/order_model.dart';
import 'package:eco_bites/features/orders/domain/entities/order.dart'
    as order_entity;
import 'package:eco_bites/features/orders/domain/repositories/order_repository.dart';
import 'package:logger/logger.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<order_entity.Order>>> getOrders() async {
    if (await networkInfo.isConnected) {
      try {
        final List<OrderModel> orders = await remoteDataSource.getOrders();
        await localDataSource.cacheOrders(orders);
        return Right<Failure, List<order_entity.Order>>(orders);
      } on AuthException catch (e) {
        Logger()
            .w('Failed to fetch from remote, attempting to use cached data');
        try {
          final List<OrderModel> cachedOrders =
              await localDataSource.getCachedOrders();
          return Right<Failure, List<order_entity.Order>>(cachedOrders);
        } on CacheException catch (_) {
          return Left<Failure, List<order_entity.Order>>(
            AuthFailure(e.message),
          );
        }
      }
    } else {
      try {
        final List<OrderModel> cachedOrders =
            await localDataSource.getCachedOrders();
        return Right<Failure, List<order_entity.Order>>(cachedOrders);
      } on CacheException {
        return const Left<Failure, List<order_entity.Order>>(
          NetworkFailure('No internet connection'),
        );
      }
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    order_entity.OrderStatus newStatus,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateOrderStatus(orderId, newStatus);
        await localDataSource.updateOrderStatus(orderId, newStatus);
        return const Right<Failure, void>(null);
      } on AuthException catch (e) {
        return Left<Failure, void>(AuthFailure(e.message));
      }
    } else {
      return const Left<Failure, void>(
        NetworkFailure('No internet connection'),
      );
    }
  }
}
