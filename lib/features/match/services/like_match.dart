import 'package:dating_app/common/utils/firebase_utils.dart';

class LikeMatch {
  static Future<void> execute({required String user}) async {
    await FirebaseUtils.likesCollection(user: user)
        .doc(FirebaseUtils.currentUserId)
        .set(
      {
        'id': FirebaseUtils.currentUserId,
        'user': user,
        'time': DateTime.now(),
        
      },
    );
  }
}
