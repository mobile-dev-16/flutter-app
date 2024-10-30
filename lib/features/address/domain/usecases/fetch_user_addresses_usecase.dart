import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/address/domain/entities/address.dart';
import 'package:eco_bites/features/address/domain/repositories/address_repository.dart';
import 'package:equatable/equatable.dart';

class FetchUserAddressesUseCase {
  const FetchUserAddressesUseCase(this.repository);

  final AddressRepository repository;

  Future<Either<Failure, List<Address>>> call(FetchUserAddressesParams params) {
    return repository.fetchUserAddresses(params.userId);
  }
}

class FetchUserAddressesParams extends Equatable {
  const FetchUserAddressesParams({required this.userId});

  final String userId;

  @override
  List<Object?> get props => <Object?>[userId];
}
