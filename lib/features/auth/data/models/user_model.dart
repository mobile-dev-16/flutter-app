import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:eco_bites/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String email,
    this.displayName,
    this.photoURL,
  }) : super(
          id: id,
          email: email,
        );

  final String? displayName;
  final String? photoURL;

  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
    );
  }
}
