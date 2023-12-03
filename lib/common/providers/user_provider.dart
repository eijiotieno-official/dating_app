import 'package:dating_app/common/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? currentUserModel;

  void updateCurrentUserData({required UserModel user}) {
    currentUserModel = user;
    notifyListeners();
  }
}
