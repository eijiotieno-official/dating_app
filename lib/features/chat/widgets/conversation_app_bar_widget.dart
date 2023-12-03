import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/common/models/user_model.dart';
import 'package:flutter/material.dart';

class ConversationAppBar extends StatelessWidget {
  final UserModel userModel;
  const ConversationAppBar({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          leading: const CloseButton(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: CachedNetworkImageProvider(userModel.photos!.first),
                ),
              ),
              Text(
                userModel.name!,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
