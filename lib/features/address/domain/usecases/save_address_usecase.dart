import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/address/domain/entities/address.dart';
import 'package:eco_bites/features/address/domain/repositories/address_repository.dart';
import 'package:equatable/equatable.dart';

class SaveAddressUseCase {
  const SaveAddressUseCase(this.repository);

  final AddressRepository repository;

  Future<Either<Failure, void>> call(SaveAddressParams params) async {
    return repository.saveAddress(params.userId, params.address);
  }
}

class SaveAddressParams extends Equatable {
  const SaveAddressParams({
    required this.userId,
    required this.address,
  });

  final String userId;
  final Address address;

  @override
  List<Object?> get props => <Object?>[userId, address];
}
