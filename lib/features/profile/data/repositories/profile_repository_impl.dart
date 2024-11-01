import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';
import 'package:eco_bites/features/profile/domain/repositories/user_profile_repository.dart';

class ProfileRepositoryImpl implements UserProfileRepository {

  ProfileRepositoryImpl({required this.firestore});
  final FirebaseFirestore firestore;

  @override
  Future<UserProfile?> fetchUserProfile(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('profiles').doc(userId).get();

    if (snapshot.exists && snapshot.data() != null) {
      return UserProfile.fromMap(snapshot.data()!);
    }
    return null;
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    await firestore.collection('profiles').doc(profile.userId).update({
      'favoriteCuisine': profile.favoriteCuisine.name,
      'dietType': profile.dietType,
    });
  }
}
