import 'package:dating_app/common/utils/firebase_utils.dart';

class DislikeMatch {
  static Future<void> execute({required String user}) async {
    await FirebaseUtils.likesCollection(user: user)
        .doc(FirebaseUtils.currentUserId)
        .delete();
  }
}
