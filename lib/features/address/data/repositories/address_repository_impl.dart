import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/core/network/network_info.dart';
import 'package:eco_bites/features/address/data/datasources/address_remote_data_source.dart';
import 'package:eco_bites/features/address/data/models/address_model.dart';
import 'package:eco_bites/features/address/domain/entities/address.dart';
import 'package:eco_bites/features/address/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  const AddressRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final AddressRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, void>> saveAddress(
    String userId,
    Address address,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.saveAddress(
          userId,
          AddressModel.fromEntity(address),
        );
        return const Right<Failure, void>(null);
      } on FirebaseException catch (e) {
        return Left<Failure, void>(FirebaseFailure(e.message));
      }
    } else {
      return const Left<Failure, void>(
        NetworkFailure('No internet connection'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Address>>> fetchUserAddresses(
    String userId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final List<Address> addresses =
            await remoteDataSource.fetchUserAddresses(userId);
        return Right<Failure, List<Address>>(addresses);
      } on FirebaseException catch (e) {
        return Left<Failure, List<Address>>(FirebaseFailure(e.message));
      }
    } else {
      return const Left<Failure, List<Address>>(
        NetworkFailure('No internet connection'),
      );
    }
  }
}
