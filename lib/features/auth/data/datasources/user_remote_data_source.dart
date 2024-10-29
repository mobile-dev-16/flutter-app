import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:eco_bites/core/error/exceptions.dart';
import 'package:eco_bites/features/auth/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signInWithGoogle();

  Future<UserModel> signUpWithGoogle();

  Future<void> signOut();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  const UserRemoteDataSourceImpl({
    required firebase_auth.FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw const AuthException('Sign in failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed');
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw const AuthException('Sign up failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Try silent sign in first
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw const AuthException('Google sign in cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final firebase_auth.OAuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw const AuthException('Google sign in failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Google authentication failed');
    }
  }

  @override
  Future<UserModel> signUpWithGoogle() async {
    try {
      // Force account selection
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw const AuthException('Google sign up cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final firebase_auth.OAuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw const AuthException('Google sign up failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Google authentication failed');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw const AuthException('Sign out failed');
    }
  }
}
