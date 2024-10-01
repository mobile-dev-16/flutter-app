import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthRepository {
  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final Logger _logger = Logger();  // Logger instance
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();  // GoogleSignIn instance

  // Sign up with email and password
  Future<User?> signUp({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      _logger.e('Error signing up: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signIn({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      _logger.e('Error signing in: $e');
      return null;
    }
  }

  // Sign up or sign in with Google
  Future<User?> signUpWithGoogle() async {
    try {
      // Disconnect any previously authenticated Google account
      await _googleSignIn.signOut();

      // Initiating the Google Sign-In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _logger.e('Google sign-in was canceled');
        return null; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Signing in with the Google credentials
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      _logger.e('Error signing up with Google: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();  // Ensures sign out from Google as well
      _logger.i('User signed out successfully');
    } catch (e) {
      _logger.e('Error signing out: $e');
    }
  }

  // Stream for authentication state changes
  Stream<User?> get user => _firebaseAuth.authStateChanges();
}
