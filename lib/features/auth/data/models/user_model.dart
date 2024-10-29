import 'package:eco_bites/features/auth/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    this.displayName,
    this.photoURL,
  });
  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
    );
  }

  final String? displayName;
  final String? photoURL;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }
}
