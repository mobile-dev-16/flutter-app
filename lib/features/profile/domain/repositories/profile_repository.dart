import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/features/address/data/models/address_model.dart';
import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';

class ProfileRepository {
  ProfileRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore firestore;

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('profiles').doc(userId).get();

      if (snapshot.exists && snapshot.data() != null) {
        final Map<String, dynamic>? data = snapshot.data();
        if (!data!.containsKey('favoriteCuisine') || !data.containsKey('dietType')) {
          throw const FormatException('Missing required fields in profile data');
        }
        return UserProfile.fromMap(snapshot.data()!);
      }
      return null;
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch profile: $e');
    } catch (e) {
      throw Exception('Error processing profile data: $e');
    }
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    // Solo actualizamos los campos `favoriteCuisine` y `dietType`
    try {
      await firestore.collection('profiles').doc(profile.userId).set(
        <String, dynamic>{
          'favoriteCuisine': profile.favoriteCuisine.name,
          'dietType': profile.dietType,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      if (e is FirebaseException) {
        throw Exception('Failed to save profile: ${e.message}');
      }
      throw Exception('Unexpected error while saving profile: $e');
    }
  }

  Future<void> saveUserAddress(String userId, AddressModel address) async {
    try {
      await firestore
          .collection('profiles')
          .doc(userId)
          .collection('addresses')
          .add(address.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Failed to save address: $e');
    }
  }

  Future<List<AddressModel>> getUserAddresses(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('profiles')
        .doc(userId)
        .collection('addresses')
        .get();

    try {
      return await Future.wait(
        snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
          final Map<String, dynamic> data = doc.data();
          return AddressModel.fromMap(data);
        }),
      );
    } on FirebaseException catch (e) {
      throw Exception('Failed to retrieve addresses: $e');
    }
  }
  Future<void> updateProfile(UserProfile profile) async {
    try{
      await firestore
          .collection('profiles')
          .doc(profile.userId)
          .update(<Object, Object?>{
      'favoriteCuisine': profile.favoriteCuisine.name,
      'dietType': profile.dietType,
    });
  } on FirebaseException catch (e) {
    throw Exception('Failed to update profile: $e');
  }
  }
}
