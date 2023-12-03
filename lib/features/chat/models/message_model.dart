import 'package:dating_app/features/chat/enums/message_status_enum.dart';

class MessageModel {
  String id;
  String sender;
  String receiver;
  String? text;
  String? photo;
  String? extension;
  DateTime time;
  MessageStatus status;
  MessageModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.photo,
    required this.extension,
    required this.time,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'text': text,
      'photo': photo,
      'time': time,
      'status': status,
    };
  }

  factory MessageModel.fromMap({required Map<String, dynamic> map}) {
    return MessageModel(
      id: map['id'],
      sender: map['sender'],
      receiver: map['receiver'],
      text: map['text'],
      photo: map['photo'],
      time: map['time'].toDate(),
      status: enumMessageStatus(string: map['status']),
      extension: map['extension'],
    );
  }
}
