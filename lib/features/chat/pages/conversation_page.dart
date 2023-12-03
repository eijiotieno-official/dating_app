import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/features/chat/providers/chat_provider.dart';
import 'package:dating_app/features/chat/utils/message_utils.dart';
import 'package:dating_app/features/chat/widgets/conversation_app_bar_widget.dart';
import 'package:dating_app/features/chat/widgets/conversation_text_input_widget.dart';
import 'package:dating_app/features/chat/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class ConversationPage extends StatefulWidget {
  final UserModel user;
  final String chatId;
  const ConversationPage({
    super.key,
    required this.chatId,
    required this.user,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  GroupedItemScrollController itemScrollController =
      GroupedItemScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ConversationAppBar(userModel: widget.user),
          buildMessagesWidget(),
          ConversationTextInputWidget(receiver: widget.user.id),
        ],
      ),
    );
  }

  Widget buildMessagesWidget() => Consumer<ChatProvider>(
        builder: (context, value, child) {
          return Expanded(
            child: value.chats.any((chat) => chat.id == widget.user.id)
                ? StickyGroupedListView(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    shrinkWrap: true,
                    itemScrollController: itemScrollController,
                    elements: value.chats
                        .firstWhere((chat) => chat.id == widget.user.id)
                        .messages,
                    itemComparator: (element1, element2) =>
                        element1.time.compareTo(element2.time),
                    order: StickyGroupedListOrder.DESC,
                    groupBy: (element) => DateTime(
                      element.time.year,
                      element.time.month,
                      element.time.day,
                    ),
                    groupComparator: (value1, value2) =>
                        value1.compareTo(value2),
                    groupSeparatorBuilder: (element) => SizedBox(
                      height: 40,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7.5,
                              vertical: 2.5,
                            ),
                            child: Text(
                              MessageUtils.formatDay(dateTime: element.time),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    floatingHeader: true,
                    itemBuilder: (context, element) {
                      return MessageWidget(message: element);
                    },
                  )
                : Container(),
          );
        },
      );
}
