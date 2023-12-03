import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseServices {
  static Future<String?> getDeviceToken() async =>
      await FirebaseMessaging.instance.getToken();

  static Future<UserModel?> readSpecificUserData({required String id}) async {
    UserModel? userModel;
    DocumentSnapshot documentSnapshot =
        await FirebaseUtils.usersCollection.doc(id).get();

    if (documentSnapshot.exists) {
      userModel = UserModel.fromDoc(documentSnapshot: documentSnapshot);
    }

    return userModel;
  }

  static Future<List<UserModel>> readAllUsers() async {
    List<UserModel> users = [];
    await FirebaseUtils.usersCollection.get().then(
      (value) {
        if (value.docs.isNotEmpty) {
          for (var doc in value.docs) {
            users.add(UserModel.fromDoc(documentSnapshot: doc));
          }
        }
      },
    );
    return users;
  }

  static Future<String?> uploadFile({required File file}) async {
    try {
      if (!file.existsSync()) {
        // Handle the case where the file doesn't exist
        throw Exception("File does not exist");
      }

      String fileName = path.basename(file.path);
      Reference storageRef = FirebaseStorage.instance.ref();
      Reference fileRef = storageRef.child("files/$fileName");

      UploadTask uploadTask = fileRef.putFile(file);

      // Wait for the upload to complete
      await uploadTask;

      // Check if the upload was successful
      if (uploadTask.snapshot.state == TaskState.success) {
        // Return the download URL
        return await fileRef.getDownloadURL();
      } else {
        // Handle the case where the upload was not successful
        throw Exception("Upload failed");
      }
    } catch (e) {
      // Log the error
      print("Error uploading file: $e");
      // Return null or handle the error as needed
      return null;
    }
  }
}
