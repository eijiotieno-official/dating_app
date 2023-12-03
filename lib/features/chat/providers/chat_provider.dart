import 'package:dating_app/features/chat/models/chat_model.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatModel> chats = [];

  void addChat({required ChatModel chat}) {
    chats.add(chat);
    notifyListeners();
  }

  void removeChat({required String id}) {
    chats.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
