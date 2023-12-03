import 'package:dating_app/common/enum/gender_enum.dart';
import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/common/utils/interests_utils.dart';
import 'package:dating_app/features/match/models/like_model.dart';
import 'package:dating_app/features/match/models/preference_model.dart';
import 'package:flutter/material.dart';

class MatchProvider extends ChangeNotifier {
  PreferenceModel preference = PreferenceModel(
    maxAge: 50,
    minAge: 18,
    gender: Gender.woman,
    interests: interests,
    distance: 1000.0,
  );

  Future<void> updatePreference(
      {required PreferenceModel preferenceModel}) async {
    preference = preferenceModel;
    notifyListeners();
  }

  List<UserModel> matches = [];

  List<LikeModel> likes = [];

  void addMatch({required UserModel userModel}) {
    bool contains = matches.any((element) => element.id == userModel.id);
    if (contains == false) {
      matches.add(userModel);
    }
    notifyListeners();
  }

  void clearMatches() {
    matches.clear();
    notifyListeners();
  }

  void addLike({required LikeModel likeModel}) {
    bool contains = likes.any((element) => element.id == likeModel.id);
    if (contains == false) {
      likes.add(likeModel);
    }
    notifyListeners();
  }
}
