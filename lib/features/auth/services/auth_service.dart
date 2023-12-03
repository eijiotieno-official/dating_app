import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/common/services/firebase_services.dart';
import 'package:dating_app/common/services/location_services.dart';
import 'package:dating_app/features/auth/enum/auth_state_enum.dart';
import 'package:dating_app/features/auth/providers/auth_provider.dart';
import 'package:dating_app/features/auth/services/create_user_service.dart';
import 'package:dating_app/features/auth/services/google_sign_in_service.dart';
import 'package:dating_app/features/auth/services/update_user_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future<void> logIn({required AuthGoogleProvider authProvider}) async {
    authProvider.updateAuthState(authStateEnum: AuthStateEnum.loading);

    UserCredential userCredential = await googleSignInService();

    UserModel? user = await FirebaseServices.readSpecificUserData(
        id: userCredential.user!.uid);

    String? token = await FirebaseServices.getDeviceToken();

    GeoPoint? geoPoint = await LocationServices.getGeoPoint();
    if (user == null) {
      if (token != null) {
        await createUserService(
                userCredential: userCredential,
                token: token,
                geoPoint: geoPoint)
            .then((_) => authProvider.updateAuthState(
                authStateEnum: AuthStateEnum.success));
      }
    } else {
      if (token != null) {
        await updateUserDataService(
                userCredential: userCredential,
                token: token,
                geoPoint: geoPoint)
            .then((_) => authProvider.updateAuthState(
                authStateEnum: AuthStateEnum.success));
      }
    }
  }
}
