import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/address/domain/models/address.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/entities/food_business.dart';
import 'package:eco_bites/features/food/domain/repositories/food_business_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

class FetchNearbySurplusFoodBusinesses {
  const FetchNearbySurplusFoodBusinesses(this.repository);

  final FoodBusinessRepository repository;

  Future<Either<Failure, List<FoodBusiness>>> call(
    FetchNearbySurplusFoodBusinessesParams params,
  ) async {
    Logger().d('FetchNearbySurplusFoodBusinessesParams: $params');
    return repository.fetchNearbySurplusFoodBusinesses(
      userLocation: params.userLocation,
      favoriteCuisine: params.favoriteCuisine,
      distanceInKm: params.distanceInKm,
    );
  }
}

class FetchNearbySurplusFoodBusinessesParams extends Equatable {
  const FetchNearbySurplusFoodBusinessesParams({
    required this.userLocation,
    required this.favoriteCuisine,
    this.distanceInKm = 5.0,
  });

  final Address userLocation;
  final CuisineType favoriteCuisine;
  final double distanceInKm;

  @override
  List<Object?> get props => <Object?>[
        userLocation,
        favoriteCuisine,
        distanceInKm,
      ];
}
