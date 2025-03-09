import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/modules/sign_up/sign_up_screen.dart';
import '../../constants/string_constants.dart';

class SignUpProvider {
  /// Signs up a new user using Firebase Authentication and stores user details in FireStore.
  /// Also saves the username in SharedPreferences for local access.
  ///
  /// Parameters:
  /// - [signUpParams]: Contains user details such as email, password, and username.
  static Future<void> signUpUser({required SignUpParams signUpParams}) async {
    try {
      // Initialize Firebase Authentication instance
      final FirebaseAuth auth = FirebaseAuth.instance;

      /// Create a new user with email and password authentication
      final UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(
        email: signUpParams.email,
        password: signUpParams.password,
      );

      /// Retrieve the user's unique identifier (UID) or set it to an empty string if null
      final String uid = userCredential.user?.uid ?? '';

      /// Initialize SharedPreferences for local data storage
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      /// Store user details in FireStore under the "users" collection
      await FirebaseFirestore.instance.collection(StringConstants.users).doc(uid).set({
        StringConstants.username: signUpParams.username,
        StringConstants.email: signUpParams.email,
        StringConstants.uid: uid,
        StringConstants.createdAt: FieldValue.serverTimestamp(),
      });

      /// Save the username locally using SharedPreferences
      prefs.setString(StringConstants.username, signUpParams.username);
    } catch (e) {
      /// Catch any errors and rethrow them as a string message
      throw e.toString();
    }
  }
}
