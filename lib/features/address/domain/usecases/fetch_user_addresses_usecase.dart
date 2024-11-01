import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/address/domain/entities/address.dart';
import 'package:eco_bites/features/address/domain/repositories/address_repository.dart';
import 'package:equatable/equatable.dart';

class FetchUserAddressUseCase {
  const FetchUserAddressUseCase(this.repository);

  final AddressRepository repository;

  // Update to return a single Address, not a list.
  Future<Either<Failure, Address?>> call(FetchUserAddressParams params) {
    return repository.fetchUserAddress(params.userId);
  }
}

class FetchUserAddressParams extends Equatable {
  const FetchUserAddressParams({required this.userId});

  final String userId;

  @override
  List<Object?> get props => <Object?>[userId];
}
