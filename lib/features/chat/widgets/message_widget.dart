import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/features/chat/enums/message_status_enum.dart';
import 'package:dating_app/features/chat/models/message_model.dart';
import 'package:dating_app/features/chat/services/read_message.dart';
import 'package:dating_app/features/chat/widgets/time_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'upload_widget.dart';

class MessageWidget extends StatefulWidget {
  final MessageModel message;
  const MessageWidget({super.key, required this.message});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  void initState() {
    if (widget.message.sender != FirebaseUtils.currentUserId &&
        widget.message.status != MessageStatus.read) {
      readMessage(sender: widget.message.sender, message: widget.message.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color color = widget.message.sender == FirebaseUtils.currentUserId
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).hoverColor;
    return Align(
      alignment: widget.message.sender == FirebaseUtils.currentUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Column(
        children: [
          if (widget.message.photo != null) buildPhotoWidget(color: color),
          if (widget.message.text != null) buildTextWidget(color: color),
        ],
      ),
    );
  }

  Widget buildPhotoWidget({required Color color}) => Card(
        color: color,
        child: Stack(
          children: [
            FadeInImage(
              fadeInDuration: const Duration(milliseconds: 500),
              placeholder: MemoryImage(kTransparentImage),
              image: CachedNetworkImageProvider(widget.message.photo!),
            ),
            if (widget.message.text == null)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: TimeStatusWidget(message: widget.message),
                  ),
                ),
              ),
            if (widget.message.status == MessageStatus.waiting &&
                widget.message.sender == FirebaseUtils.currentUserId)
              UploadWidget(message: widget.message),
          ],
        ),
      );

  Widget buildTextWidget({required Color color}) => Card(
        color: color,
        child: Wrap(
          alignment: WrapAlignment.end,
          children: [
            Text(widget.message.text!),
            TimeStatusWidget(message: widget.message),
          ],
        ),
      );
}
