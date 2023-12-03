import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> createUserService({
  required UserCredential userCredential,
  required String token,
  required GeoPoint geoPoint,
}) async {
  bool created = false;
  await FirebaseUtils.usersCollection.doc(userCredential.user!.uid).set(
    {
      'id': userCredential.user!.uid,
      'name': null,
      'photos': null,
      'email': userCredential.user!.email,
      'phone': null,
      'about': null,
      'geoPoint': geoPoint,
      'birth': null,
      'tokens': [token],
      'gender': null,
      'viewed': [],
      'interests': [],
    },
  ).then((_) => created = true);
  return created;
}
