import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/common/services/firebase_services.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/features/chat/enums/message_status_enum.dart';
import 'package:dating_app/features/chat/models/chat_model.dart';
import 'package:dating_app/features/chat/pages/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatWidget extends StatelessWidget {
  final ChatModel chat;
  const ChatWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: FirebaseServices.readSpecificUserData(id: chat.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AnimatedOpacity(
            opacity: snapshot.data == null ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: ListTile(
              onTap: () {
                Get.to(
                  () => ConversationPage(user: snapshot.data!, chatId: chat.id),
                );
              },
              leading: Badge.count(
                count: chat.messages
                    .where((element) =>
                        element.sender != FirebaseUtils.currentUserId &&
                        element.status != MessageStatus.read)
                    .length,
                child: CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider(snapshot.data!.photos!.first),
                ),
              ),
              title: Text(snapshot.data!.name!),
              subtitle: chat.messages.last.text != null
                  ? Text(chat.messages.last.text.toString())
                  : const Text("Photo"),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
