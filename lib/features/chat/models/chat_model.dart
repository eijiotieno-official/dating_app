import 'message_model.dart';

class ChatModel {
  String id;
  List<MessageModel> messages;

  ChatModel({
    required this.id,
    required this.messages,
  });
}
