import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/address/domain/models/address.dart';
import 'package:eco_bites/features/food/domain/entities/food_business.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';

abstract class FoodBusinessRepository {
  Future<Either<Failure, List<FoodBusiness>>> fetchNearbySurplusFoodBusinesses({
    required Address userLocation,
    required CuisineType favoriteCuisine,
    double distanceInKm,
  });
}
