import 'package:dating_app/common/models/user_model.dart';

bool matchByInterests({
  required UserModel user,
  required List<String> interests,
}) {
  bool match = false;
  for (var interest in interests) {
    bool contains = user.interests!.contains(interest);
    if (contains == true) {
      match = contains;
      continue;
    }
  }
  return match;
}
