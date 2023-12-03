import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/features/chat/models/chat_model.dart';
import 'package:dating_app/features/chat/models/message_model.dart';
import 'package:dating_app/features/chat/providers/chat_provider.dart';

class FetchChatsService {
  static execute({required ChatProvider chatProvider}) {
    FirebaseUtils.usersCollection
        .doc(FirebaseUtils.currentUserId)
        .collection("chats")
        .snapshots()
        .listen(
      (QuerySnapshot querySnapshot) {
        for (var change in querySnapshot.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              chatProvider.addChat(
                chat: ChatModel(
                  id: change.doc.id,
                  messages: [],
                ),
              );
              fetchMessages(
                  documentReference: change.doc.reference,
                  chatProvider: chatProvider);
              break;
            case DocumentChangeType.removed:
              chatProvider.removeChat(id: change.doc.id);
              break;
            default:
          }
        }
      },
    );
  }

  static fetchMessages({
    required DocumentReference documentReference,
    required ChatProvider chatProvider,
  }) {
    documentReference.collection("messages").snapshots().listen(
      (QuerySnapshot querySnapshot) {
        String documentId = documentReference.id;

        final chat =
            chatProvider.chats.firstWhere((doc) => doc.id == documentId);

        List<MessageModel> messages = chat.messages;

        for (var change in querySnapshot.docChanges) {
          final subDocData = change.doc.data() as Map<String, dynamic>;
          switch (change.type) {
            case DocumentChangeType.added:
              messages.add(MessageModel.fromMap(map: subDocData));
              break;
            case DocumentChangeType.modified:
              int index =
                  messages.indexWhere((element) => element.id == change.doc.id);
              if (index != -1) {
                messages[index] = MessageModel.fromMap(map: subDocData);
              }
              break;
            case DocumentChangeType.removed:
              messages.removeWhere((element) => element.id == change.doc.id);
              break;
            default:
          }
        }
        chat.messages = messages;
        chatProvider.notifyListeners();
      },
    );
  }
}
