import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/modules/feed/feed_screen.dart';
import '../../constants/string_constants.dart';

class AddPostProvider {
  /// Adds a new post to FireStore under the "posts" collection.
  ///
  /// Parameters:
  /// - [addPostParams]: Contains the username of the poster and the message content.
  static Future<void> addPost(AddPostParams addPostParams) async {
    try {
      /// Add a new post document to the "posts" collection in FireStore
      await FirebaseFirestore.instance.collection(StringConstants.posts).add({
        StringConstants.username: addPostParams.username,
        StringConstants.message: addPostParams.message,
        StringConstants.timestamp: FieldValue.serverTimestamp(),
      });
    } catch (e) {
      /// Catch any errors (e.g., network failure, FireStore issues) and rethrow them as a string
      throw e.toString();
    }
  }
}
