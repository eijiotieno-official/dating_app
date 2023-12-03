import 'package:cloud_firestore/cloud_firestore.dart';

import '../enum/gender_enum.dart';

class UserModel {
  String id;
  String? name;
  List<dynamic>? photos;
  String email;
  String? about;
  GeoPoint geoPoint;
  DateTime? birth;
  List<dynamic>? interests;
  Gender? gender;
  UserModel({
    required this.id,
    required this.name,
    required this.photos,
    required this.email,
    required this.about,
    required this.geoPoint,
    required this.birth,
    required this.interests,
    required this.gender,
  });

  factory UserModel.fromDoc({required DocumentSnapshot documentSnapshot}) {
    return UserModel(
      id: documentSnapshot['id'],
      name: documentSnapshot['name'],
      photos: documentSnapshot['photos'],
      email: documentSnapshot['email'],
      about: documentSnapshot['about'],
      geoPoint: documentSnapshot['geoPoint'],
      birth: documentSnapshot['birth'] == null
          ? null
          : documentSnapshot['birth'].toDate(),
      interests: documentSnapshot['interests'],
      gender: documentSnapshot['gender'] != null
          ? enumGender(string: documentSnapshot['gender'])
          : null,
    );
  }
}
