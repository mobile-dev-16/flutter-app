import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/core/utils/distance.dart';
import 'package:eco_bites/features/address/domain/models/address.dart';
import 'package:eco_bites/features/food/data/models/food_business_model.dart';
import 'package:eco_bites/features/food/data/models/offer_model.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:logger/logger.dart';

abstract class FoodBusinessRemoteDataSource {
  Future<List<FoodBusinessModel>> fetchNearbySurplusFoodBusinesses({
    required Address userLocation,
    required CuisineType favoriteCuisine,
    double distanceInKm,
  });
}

class FoodBusinessRemoteDataSourceImpl implements FoodBusinessRemoteDataSource {
  const FoodBusinessRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<List<FoodBusinessModel>> fetchNearbySurplusFoodBusinesses({
    required Address userLocation,
    required CuisineType favoriteCuisine,
    double distanceInKm = 5.0,
  }) async {
    try {
      Logger().d('Fetching nearby surplus food businesses');
      final collectionRef = _firestore.collection('foddBusiness');

      final QuerySnapshot<Map<String, dynamic>> foodBusinessSnapshot =
          await collectionRef
              .where('cuisineType', isEqualTo: favoriteCuisine.name)
              .get();

      final List<FoodBusinessModel> nearbyFoodBusinesses = [];

      Logger().d(
          'Food business snapshot: ${foodBusinessSnapshot.docs.map((doc) => doc.data())}');
      for (final doc in foodBusinessSnapshot.docs) {
        final offersSnapshot = await _firestore
            .collection('foddBusiness')
            .doc(doc.id)
            .collection('offers')
            .where('availableQuantity', isGreaterThan: 0)
            .where('validUntil', isGreaterThanOrEqualTo: Timestamp.now())
            .get();

        Logger().d(
            'Offers snapshot: ${offersSnapshot.docs.map((doc) => doc.data())}');
        final surplusOffers = offersSnapshot.docs
            .map((offerDoc) =>
                OfferModel.fromMap(offerDoc.data(), offerDoc.id, doc.id))
            .toList();

        Logger().d('Surplus offers: $surplusOffers');
        if (surplusOffers.isNotEmpty) {
          final distance = calculateDistance(
            userLocation.latitude,
            userLocation.longitude,
            (doc.data()['latitude'] as num?)?.toDouble() ?? 0.0,
            (doc.data()['longitude'] as num?)?.toDouble() ?? 0.0,
          );

          if (distance <= distanceInKm) {
            Logger().d('Distance: $distance');
            Logger().d('Food business: ${doc.data()}');
            Logger().d('Surplus offers: $surplusOffers');
            Logger().d('id: ${doc.id}');
            final foodBusiness = FoodBusinessModel.fromMap(
              doc.data(),
              doc.id,
              surplusOffers,
            );
            nearbyFoodBusinesses.add(foodBusiness);
          }
        }
      }

      Logger().d('Nearby food businesses: $nearbyFoodBusinesses');
      return nearbyFoodBusinesses;
    } catch (e) {
      Logger().e('Error fetching food businesses: $e',
          stackTrace: StackTrace.current);
      throw AuthException('Error fetching food businesses: $e');
    }
  }
}
