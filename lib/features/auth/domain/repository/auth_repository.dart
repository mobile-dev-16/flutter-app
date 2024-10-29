import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class AuthRepository {
  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    Logger? logger,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _logger = logger ?? Logger();

  final Logger _logger;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  // Sign up with email and password
  Future<User?> signUp({required String email, required String password}) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _logger.e('Error signing up: $e');
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signIn({required String email, required String password}) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _logger.e('Error signing in: $e');
      return null;
    }
  }

  // Sign in with Google (recall user)
  Future<User?> signInWithGoogle() async {
    try {
      // Initiating the Google Sign-In process (this recalls the user's account)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      if (googleUser == null) {
        _logger.e('Google sign-in failed, no user remembered');
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Signing in with the Google credentials
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      _logger.e('Error signing in with Google: $e');
      return null;
    }
  }

  // Sign up with Google (allows selecting an account)
  Future<User?> signUpWithGoogle() async {
    try {
      // Forcing the account chooser to appear for signing up
      await _googleSignIn.signOut();

      // Initiating the Google Sign-Up process (account chooser)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _logger.e('Google sign-up was canceled');
        return null; // User canceled the sign-up
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Check if it's a new user
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        _logger.i('New user signed up with Google');
        return userCredential.user;
      } else {
        _logger.e('Google sign-up failed: Account already exists');
        return null; // If the user is already registered
      }
    } catch (e) {
      _logger.e('Error signing up with Google: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      _logger.e('Error signing out from FirebaseAuth: $e');
    }
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      _logger.e('Error signing out from GoogleSignIn: $e');
    }
    _logger.i('User signed out successfully');
  }

  // Stream for authentication state changes
  Stream<User?> get user => _firebaseAuth.authStateChanges();
}
