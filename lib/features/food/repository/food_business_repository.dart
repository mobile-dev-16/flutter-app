import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/core/utils/distance.dart';
import 'package:eco_bites/features/address/domain/models/address.dart';
import 'package:eco_bites/features/food/domain/models/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/models/food_business.dart';
import 'package:eco_bites/features/food/domain/models/offer.dart';

class FoodBusinessRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FoodBusiness>> fetchNearbySurplusFoodBusinesses({
    required Address userLocation,
    required CuisineType favoriteCuisine,
    double distanceInKm = 5.0, // Default search radius
  }) async {
    try {
      // Fetch restaurants with the favorite cuisine
      print('==> favoriteCuisine: $favoriteCuisine');
      // favorite cuisine name
      print('==> favoriteCuisine: ${favoriteCuisine.name}');
      print('==> userLocation: $userLocation');
      print('==> distanceInKm: $distanceInKm');
      print('==> fetching nearby surplus food businesses');
      final QuerySnapshot<Map<String, dynamic>> foodBusinessSnapshot =
          await _firestore
              .collection('foddBusiness')
              .where('cuisineType', isEqualTo: favoriteCuisine.name)
              .get();

      print('==> foodBusinessSnapshot: ${foodBusinessSnapshot.docs}');

      final List<FoodBusiness> nearbyFoodBusinesses = <FoodBusiness>[];

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in foodBusinessSnapshot.docs) {
        final QuerySnapshot<Map<String, dynamic>> offersSnapshot =
            await _firestore
                .collection('foddBusiness')
                .doc(doc.id)
                .collection('offers')
                .where('availableQuantity', isGreaterThan: 0)
                .where('validUntil', isGreaterThanOrEqualTo: Timestamp.now())
                .get();

        print('==> query snapshot: $offersSnapshot');
        print('==> offersSnapshot.docs: ${offersSnapshot.docs}');

        final List<Offer> surplusOffers = offersSnapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> offerDoc) {
          return Offer.fromMap(offerDoc.data(), offerDoc.id, doc.id);
        }).toList();

        if (surplusOffers.isNotEmpty) {
          final double distance = calculateDistance(
            userLocation.latitude,
            userLocation.longitude,
            (doc.data()['latitude'] as num?)?.toDouble() ?? 0.0,
            (doc.data()['longitude'] as num?)?.toDouble() ?? 0.0,
          );

          if (distance <= distanceInKm) {
            final FoodBusiness foodBusiness = FoodBusiness(
              id: doc.id,
              name: doc.data()['name'] ?? '',
              cuisineType: CuisineTypeExtension.fromString(
                doc.data()['cuisineType'] ?? 'local',
              ),
              latitude: (doc.data()['latitude'] as num?)?.toDouble() ?? 0.0,
              longitude: (doc.data()['longitude'] as num?)?.toDouble() ?? 0.0,
              offers: surplusOffers,
            );

            nearbyFoodBusinesses.add(foodBusiness);
          }
        }
      }

      return nearbyFoodBusinesses;
    } catch (e) {
      print('Error fetching nearby surplus food businesses: $e');
      return <FoodBusiness>[];
    }
  }
}
