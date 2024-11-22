import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/core/network/network_info.dart';
import 'package:eco_bites/features/address/domain/entities/address.dart';
import 'package:eco_bites/features/food/data/datasources/food_business_local_data_source.dart';
import 'package:eco_bites/features/food/data/datasources/food_business_remote_data_source.dart';
import 'package:eco_bites/features/food/data/models/food_business_model.dart';
import 'package:eco_bites/features/food/domain/entities/category.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/entities/diet_type.dart';
import 'package:eco_bites/features/food/domain/entities/food_business.dart';
import 'package:eco_bites/features/food/domain/entities/offer.dart';
import 'package:eco_bites/features/food/domain/repositories/food_business_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class FoodBusinessRepositoryImpl implements FoodBusinessRepository {
  FoodBusinessRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    // Listen to connectivity changes
    networkInfo.onConnectivityChanged.listen((bool isConnected) {
      if (isConnected) {
        Logger().d('Connection restored - Refreshing data');
        Fluttertoast.showToast(
          msg: 'Connection restored. Refreshing data...',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _lastFetchParams.let((FetchParams params) {
          fetchNearbySurplusFoodBusinesses(
            userLocation: params.userLocation,
            favoriteCuisine: params.favoriteCuisine,
            dietType: params.dietType,
            category: params.category,
            distanceInKm: params.distanceInKm,
          );
        });
      }
    });
  }

  final FoodBusinessRemoteDataSource remoteDataSource;
  final FoodBusinessLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  FetchParams? _lastFetchParams;

  @override
  Future<Either<Failure, List<FoodBusiness>>> fetchNearbySurplusFoodBusinesses({
    required Address userLocation,
    CuisineType? favoriteCuisine,
    DietType? dietType,
    Category? category,
    double distanceInKm = 5.0,
  }) async {
    _lastFetchParams = FetchParams(
      userLocation: userLocation,
      favoriteCuisine: favoriteCuisine,
      dietType: dietType,
      category: category,
      distanceInKm: distanceInKm,
    );

    if (await networkInfo.isConnected) {
      try {
        Fluttertoast.showToast(
          msg: 'Fetching latest offers...',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );

        final List<FoodBusinessModel> businesses =
            await remoteDataSource.fetchNearbySurplusFoodBusinesses(
          userLocation: userLocation,
          favoriteCuisine: favoriteCuisine,
          dietType: dietType,
          category: category,
          distanceInKm: distanceInKm,
        );

        await localDataSource.cacheFoodBusinesses(businesses);

        if (dietType != null) {
          return Right<Failure, List<FoodBusiness>>(
            businesses.where((FoodBusinessModel business) {
              return business.offers.any(
                (Offer offer) => offer.suitableFor.contains(dietType),
              );
            }).toList(),
          );
        }

        return Right<Failure, List<FoodBusiness>>(businesses);
      } on FirebaseException catch (e) {
        try {
          Logger().w(
            'Failed to fetch from remote, attempting to use cached data',
            error: e,
          );

          Fluttertoast.showToast(
            msg: 'Using cached data. Some information may be outdated.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
          );

          final List<FoodBusinessModel> cachedBusinesses =
              await localDataSource.getCachedFoodBusinesses();

          if (dietType != null) {
            return Right<Failure, List<FoodBusiness>>(
              cachedBusinesses.where((FoodBusinessModel business) {
                return business.offers.any(
                  (Offer offer) => offer.suitableFor.contains(dietType),
                );
              }).toList(),
            );
          }

          return Right<Failure, List<FoodBusiness>>(cachedBusinesses);
        } on CacheException {
          return Left<Failure, List<FoodBusiness>>(FirebaseFailure(e.message));
        }
      }
    } else {
      try {
        Fluttertoast.showToast(
          msg: 'No internet connection. Using cached data.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

        final List<FoodBusinessModel> cachedBusinesses =
            await localDataSource.getCachedFoodBusinesses();

        Logger().d('Using cached businesses: $cachedBusinesses');

        if (dietType != null) {
          return Right<Failure, List<FoodBusiness>>(
            cachedBusinesses.where((FoodBusinessModel business) {
              return business.offers.any(
                (Offer offer) => offer.suitableFor.contains(dietType),
              );
            }).toList(),
          );
        }

        return Right<Failure, List<FoodBusiness>>(cachedBusinesses);
      } on CacheException {
        return const Left<Failure, List<FoodBusiness>>(
          CacheFailure('No cached data available'),
        );
      }
    }
  }
}

// Helper class to store fetch parameters
class FetchParams {
  const FetchParams({
    required this.userLocation,
    this.favoriteCuisine,
    this.dietType,
    this.category,
    this.distanceInKm = 5.0,
  });

  final Address userLocation;
  final CuisineType? favoriteCuisine;
  final DietType? dietType;
  final Category? category;
  final double distanceInKm;
}

// Extension to handle nullable values
extension Let<T> on T? {
  R let<R>(R Function(T value) operation) {
    final T? value = this;
    if (value == null) {
      throw Exception('Value is null');
    }
    return operation(value);
  }
}
