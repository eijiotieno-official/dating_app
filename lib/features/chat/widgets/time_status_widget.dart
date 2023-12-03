import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/common/utils/format_message_utils.dart';
import 'package:dating_app/features/chat/enums/message_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/features/chat/models/message_model.dart';

class TimeStatusWidget extends StatelessWidget {
  final MessageModel message;
  const TimeStatusWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              formatMessageTime(
                dateTime: message.time,
                context: context,
              ),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (message.sender == FirebaseUtils.currentUserId)
            Padding(
              padding: const EdgeInsets.only(left: 3, top: 2),
              child: Icon(
                message.status == MessageStatus.read ||
                        message.status == MessageStatus.delivered
                    ? Icons.done_all_rounded
                    : message.status == MessageStatus.sent
                        ? Icons.done_rounded
                        : Icons.watch_later_outlined,
                color: message.status == MessageStatus.read
                    ? Colors.lightBlueAccent
                    : null,
                size: 15,
              ),
            ),
        ],
      ),
    );
  }
}
