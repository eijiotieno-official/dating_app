import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/common/pages/profile_page.dart';
import 'package:dating_app/common/providers/user_provider.dart';
import 'package:dating_app/features/chat/providers/chat_provider.dart';
import 'package:dating_app/features/chat/widgets/chat_widget.dart';
import 'package:dating_app/features/match/pages/like_page.dart';
import 'package:dating_app/features/match/providers/match_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            leading: Consumer<UserProvider>(
              builder: (context, value, child) {
                return value.currentUserModel == null
                    ? const SizedBox.shrink()
                    : Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(ProfilePage(user: value.currentUserModel!));
                          },
                          child: CircleAvatar(
                            backgroundImage:
                                value.currentUserModel!.photos == null
                                    ? null
                                    : CachedNetworkImageProvider(
                                        value.currentUserModel!.photos!.first),
                          ),
                        ),
                      );
              },
            ),
            title: const Text("Chats"),
            actions: [
              Consumer<MatchProvider>(
                builder: (context, matchProvider, child) {
                  return matchProvider.likes.isEmpty
                      ? const SizedBox.shrink()
                      : Badge.count(
                          count: matchProvider.likes.length,
                          child: IconButton(
                            onPressed: () {
                              Get.to(
                                () => const LikePage(),
                                duration: const Duration(milliseconds: 700),
                                transition: Transition.rightToLeft,
                              );
                            },
                            icon: const Icon(Icons.notifications),
                          ),
                        );
                },
              ),
            ],
          ),
          body: value.chats.isEmpty
              ? const Center(
                  child: Text("no Messages"),
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: value.chats.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(chat: value.chats[index]);
                  },
                ),
        );
      },
    );
  }
}
