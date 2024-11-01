import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/features/address/data/models/address_model.dart';
import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';

class ProfileRepository {
  ProfileRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore firestore;

  Future<UserProfile?> getUserProfile(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('profiles').doc(userId).get();

    if (snapshot.exists && snapshot.data() != null) {
      return UserProfile.fromMap(snapshot.data()!);
    }
    return null;
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
      throw Exception('Error al guardar datos de perfil en Firebase.');
    }
  }

  Future<void> saveUserAddress(String userId, AddressModel address) async {
    await firestore
        .collection('profiles')
        .doc(userId)
        .collection('addresses')
        .add(address.toMap());
  }

  Future<List<AddressModel>> getUserAddresses(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('profiles')
        .doc(userId)
        .collection('addresses')
        .get();

    return snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => AddressModel.fromMap(doc.data())).toList();
  }

    Future<void> updateProfile(UserProfile profile) async {
    await firestore
        .collection('profiles')
        .doc(profile.userId)
        .update(<Object, Object?>{
      'favoriteCuisine': profile.favoriteCuisine.toString(),
      'dietType': profile.dietType,
    });
  }
}
