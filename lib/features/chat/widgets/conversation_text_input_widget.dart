import 'dart:io';

import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/features/chat/enums/message_status_enum.dart';
import 'package:dating_app/features/chat/models/message_model.dart';
import 'package:dating_app/features/chat/services/send_message_service.dart';
import 'package:flutter/material.dart';

class ConversationTextInputWidget extends StatefulWidget {
  final String receiver;
  const ConversationTextInputWidget({super.key, required this.receiver});

  @override
  State<ConversationTextInputWidget> createState() =>
      _ConversationTextInputWidgetState();
}

class _ConversationTextInputWidgetState
    extends State<ConversationTextInputWidget> {
  TextEditingController textEditingController = TextEditingController();
  String? photo;
  @override
  Widget build(BuildContext context) {
    Color color = ElevationOverlay.applySurfaceTint(
      Theme.of(context).colorScheme.surface,
      Theme.of(context).colorScheme.surfaceTint,
      3,
    );
    return Container(
      color: color,
      child: Column(
        children: [
          if (photo != null) Image.file(File(photo!)),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            leading: photo == null
                ? null
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                    ),
                  ),
            title: TextField(
              controller: textEditingController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Message",
                hintStyle: TextStyle(
                  color: Colors.black38,
                ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            trailing: textEditingController.text.trim().isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      SendMessageService.execute(
                        messageModel: MessageModel(
                          id: "id",
                          sender: FirebaseUtils.currentUserId!,
                          receiver: widget.receiver,
                          time: DateTime.now(),
                          status: MessageStatus.waiting,
                          text: textEditingController.text.trim(),
                          photo: photo,
                          extension: '',
                        ),
                      ).then(
                        (_) {
                          setState(() {
                            textEditingController.clear();
                            photo = null;
                          });
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.send,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
