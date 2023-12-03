import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils {
  static String? currentUserId = FirebaseAuth.instance.currentUser == null
      ? null
      : FirebaseAuth.instance.currentUser!.uid;

  static CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  static CollectionReference likesCollection({required String user}) =>
      usersCollection.doc(user).collection("likes");
}
