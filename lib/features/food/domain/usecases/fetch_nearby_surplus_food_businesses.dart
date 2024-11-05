import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/address/domain/entities/address.dart';
import 'package:eco_bites/features/food/domain/entities/category.dart';
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
      category: params.category,
      distanceInKm: params.distanceInKm,
    );
  }
}

class FetchNearbySurplusFoodBusinessesParams extends Equatable {
  const FetchNearbySurplusFoodBusinessesParams({
    required this.userLocation,
    this.favoriteCuisine,
    this.category,
    this.distanceInKm = 5.0,
  });

  final Address userLocation;
  final CuisineType? favoriteCuisine;
  final Category? category;
  final double distanceInKm;

  @override
  List<Object?> get props => <Object?>[
        userLocation,
        favoriteCuisine,
        category,
        distanceInKm,
      ];
}
