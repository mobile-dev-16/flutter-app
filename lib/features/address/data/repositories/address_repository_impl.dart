import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/core/network/network_info.dart';
import 'package:eco_bites/features/address/data/datasources/address_local_data_source.dart';
import 'package:eco_bites/features/address/data/datasources/address_remote_data_source.dart';
import 'package:eco_bites/features/address/data/models/address_model.dart';
import 'package:eco_bites/features/address/domain/entities/address.dart';
import 'package:eco_bites/features/address/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  const AddressRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final AddressRemoteDataSource remoteDataSource;
  final AddressLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, void>> saveAddress(
    String userId,
    Address address,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final AddressModel addressModel = AddressModel.fromEntity(address);
        await remoteDataSource.saveAddress(userId, addressModel);
        await localDataSource.cacheAddress(userId, addressModel);
        return const Right<Failure, void>(null);
      } on FirebaseException catch (e) {
        return Left<Failure, void>(FirebaseFailure(e.message));
      }
    } else {
      try {
        final AddressModel addressModel = AddressModel.fromEntity(address);
        await localDataSource.cacheAddress(userId, addressModel);
        return const Right<Failure, void>(null);
      } on CacheException {
        return const Left<Failure, void>(
          CacheFailure('Failed to cache address'),
        );
      }
    }
  }

  @override
  Future<Either<Failure, Address?>> fetchUserAddress(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final AddressModel? addressModel =
            await remoteDataSource.fetchUserAddress(userId);
        if (addressModel != null) {
          await localDataSource.cacheAddress(userId, addressModel);
        }
        return Right<Failure, Address?>(addressModel);
      } on FirebaseException catch (e) {
        // Try to get cached data if remote fails
        try {
          final AddressModel? cachedAddress =
              await localDataSource.getCachedAddress(userId);
          return Right<Failure, Address?>(cachedAddress);
        } on CacheException {
          return Left<Failure, Address?>(FirebaseFailure(e.message));
        }
      }
    } else {
      try {
        final AddressModel? cachedAddress =
            await localDataSource.getCachedAddress(userId);
        return Right<Failure, Address?>(cachedAddress);
      } on CacheException {
        return const Left<Failure, Address?>(
          CacheFailure('No cached address available'),
        );
      }
    }
  }
}
