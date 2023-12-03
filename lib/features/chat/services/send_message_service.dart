import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/features/chat/enums/message_status_enum.dart';
import 'package:dating_app/features/chat/models/message_model.dart';
import 'package:path/path.dart' as p;

import 'copy_file.dart';

class SendMessageService {
  static Future<void> execute({required MessageModel messageModel}) async {
    DocumentReference messageDocRef = FirebaseUtils.usersCollection
        .doc(FirebaseUtils.currentUserId)
        .collection("chats")
        .doc(messageModel.receiver)
        .collection("messages")
        .doc();
    DocumentReference chatDocRef = FirebaseUtils.usersCollection
        .doc(FirebaseUtils.currentUserId)
        .collection("chats")
        .doc(messageModel.receiver);

    chatDocRef.set({'id': chatDocRef.id});

    DocumentReference receiverChatDocRef = FirebaseUtils.usersCollection
        .doc(messageModel.receiver)
        .collection("chats")
        .doc(FirebaseUtils.currentUserId);

    receiverChatDocRef.set({'id': receiverChatDocRef.id});

    if (messageModel.photo == null) {
      messageDocRef.set(
        {
          'id': messageDocRef.id,
          'sender': messageModel.sender,
          'receiver': messageModel.receiver,
          'text': messageModel.text,
          'photo': null,
          'extension': null,
          'status': enumStringMessageStatus(messageStatus: messageModel.status),
          'time': messageModel.time,
        },
      );
    } else {
      await copyFile(source: messageModel.photo!, id: messageDocRef.id).then(
        (copy) {
          if (copy != null) {
            messageDocRef.set(
              {
                'id': messageDocRef.id,
                'sender': messageModel.sender,
                'receiver': messageModel.receiver,
                'text': messageModel.text,
                'photo': copy.path,
                'extension': p.extension(copy.path),
                'status':
                    enumStringMessageStatus(messageStatus: messageModel.status),
                'time': messageModel.time,
              },
            );
          }
        },
      );
    }
  }
}
