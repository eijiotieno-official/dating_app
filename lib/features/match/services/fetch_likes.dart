import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/features/match/models/like_model.dart';

class FetchLikes {
 static Stream<List<LikeModel>> execute() async* {
    List<LikeModel> likes = [];
    await FirebaseUtils.likesCollection(user: FirebaseUtils.currentUserId!)
        .get()
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          for (var doc in value.docs) {
            likes.add(LikeModel.fromDoc(documentSnapshot: doc));
          }
        }
      },
    );

    yield likes;
  }
}
