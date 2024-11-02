// ignore_for_file: always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/profile/domain/entities/user_profile.dart';
import 'package:eco_bites/features/profile/domain/repositories/user_profile_repository.dart';

class ProfileRepositoryImpl implements UserProfileRepository {

  ProfileRepositoryImpl({required this.firestore});
  final FirebaseFirestore firestore;

  @override
  Future<Either<ServerFailure, UserProfile?>> fetchUserProfile(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('profiles').doc(userId).get();

    if (snapshot.exists && snapshot.data() != null) {
      return Right(UserProfile.fromMap(snapshot.data()!));
    }
    return const Left(ServerFailure('Failed to fetch user profile'));
  }

  @override
  Future<Either<ServerFailure, Unit>> updateUserProfile(UserProfile profile) async {
    try {
      await firestore.collection('profiles').doc(profile.userId).update(<Object, Object?>{
        'favoriteCuisine': profile.favoriteCuisine.name,
        'dietType': profile.dietType,
      });
      return const Right(unit);
    } catch (e) {
      return const Left(ServerFailure('Failed to update user profile'));
    }
  }
}
