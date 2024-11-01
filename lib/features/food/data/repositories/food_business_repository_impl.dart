import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/core/network/network_info.dart';
import 'package:eco_bites/features/address/domain/entities/address.dart';
import 'package:eco_bites/features/food/data/datasources/food_business_remote_data_source.dart';
import 'package:eco_bites/features/food/data/models/food_business_model.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/entities/food_business.dart';
import 'package:eco_bites/features/food/domain/repositories/food_business_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class FoodBusinessRepositoryImpl implements FoodBusinessRepository {
  const FoodBusinessRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final FoodBusinessRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<FoodBusiness>>> fetchNearbySurplusFoodBusinesses({
    required Address userLocation,
    required CuisineType favoriteCuisine,
    double distanceInKm = 5.0,
  }) async {
    Logger().d(
      'FetchNearbySurplusFoodBusinessesParams: $userLocation, $favoriteCuisine, $distanceInKm',
    );
    if (await networkInfo.isConnected) {
      Logger().d('Fetching nearby surplus food businesses');
      try {
        final List<FoodBusinessModel> businesses =
            await remoteDataSource.fetchNearbySurplusFoodBusinesses(
          userLocation: userLocation,
          favoriteCuisine: favoriteCuisine,
          distanceInKm: distanceInKm,
        );
        return Right<Failure, List<FoodBusiness>>(businesses);
      } on FirebaseException catch (e) {
        return Left<Failure, List<FoodBusiness>>(FirebaseFailure(e.message));
      }
    } else {
      Logger().e('No internet connection');
      return const Left<Failure, List<FoodBusiness>>(
        NetworkFailure('No internet connection'),
      );
    }
  }
}