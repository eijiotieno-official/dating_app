import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  String id;
  String user;

  LikeModel({
    required this.id,
    required this.user,
    
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user,
    };
  }

  factory LikeModel.fromDoc({required DocumentSnapshot documentSnapshot}) {
    return LikeModel(
      id: documentSnapshot['id'],
      user: documentSnapshot['user'],
    );
  }
}
