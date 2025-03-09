import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class LoginProvider {
  /// Logs in a user using Firebase Authentication with email and password.
  ///
  /// Parameters:
  /// - [loginParams]: Contains the user's email and password.
  static Future<void> loginUser({required LoginParams loginParams}) async {
    /// Initialize Firebase Authentication instance
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      /// Sign in the user with email and password
      await auth.signInWithEmailAndPassword(
        email: loginParams.email,
        password: loginParams.password,
      );

      /// If login is successful, FirebaseAuth.instance.currentUser will be updated
    } catch (e) {
      /// Catch any errors (e.g., incorrect password, user not found) and rethrow them
      throw e.toString();
    }
  }
}
