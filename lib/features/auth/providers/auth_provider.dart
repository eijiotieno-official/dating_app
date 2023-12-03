import 'package:dating_app/features/auth/enum/auth_state_enum.dart';
import 'package:flutter/material.dart';

class AuthGoogleProvider extends ChangeNotifier {
  AuthStateEnum authState = AuthStateEnum.pause;

  void updateAuthState({required AuthStateEnum authStateEnum}) {
    authState = authStateEnum;
    notifyListeners();
  }
}
