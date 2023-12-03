import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/features/chat/enums/message_status_enum.dart';

readMessage({required String sender, required String message}) async {
  FirebaseFirestore.instance
      .collection("persons")
      .doc(FirebaseUtils.currentUserId)
      .collection("chats")
      .doc(sender)
      .collection("messages")
      .doc(message)
      .update(
    {
      'status': enumStringMessageStatus(messageStatus: MessageStatus.read),
    },
  );
  FirebaseFirestore.instance
      .collection("persons")
      .doc(sender)
      .collection("chats")
      .doc(FirebaseUtils.currentUserId)
      .collection("messages")
      .doc(message)
      .update(
    {
      'status': enumStringMessageStatus(messageStatus: MessageStatus.read),
    },
  );
}
