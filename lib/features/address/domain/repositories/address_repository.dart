import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/address/domain/entities/address.dart';

abstract class AddressRepository {
  Future<Either<Failure, void>> saveAddress(String userId, Address address);
  Future<Either<Failure, List<Address>>> fetchUserAddresses(String userId);
}
