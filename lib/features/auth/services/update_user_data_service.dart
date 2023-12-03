import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> updateUserDataService({
  required UserCredential userCredential,
  required String token,
  required GeoPoint geoPoint,
}) async {
  bool updated = false;
  await FirebaseUtils.usersCollection.doc(userCredential.user!.uid).update(
    {
      'geoPoint': geoPoint,
      'tokens': FieldValue.arrayUnion([token]),
    },
  ).then((_) => updated = true);
  return updated;
}
