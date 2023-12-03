import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/common/services/firebase_services.dart';
import 'package:dating_app/features/match/models/like_model.dart';
import 'package:dating_app/features/match/services/dislike_match.dart';
import 'package:dating_app/features/match/services/fetch_likes.dart';
import 'package:dating_app/features/match/services/like_back.dart';
import 'package:flutter/material.dart';

class LikePage extends StatelessWidget {
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("People interested in you")),
      body: StreamBuilder<List<LikeModel>>(
        stream: FetchLikes.execute(),
        builder: (context, likesSnapshot) {
          if (likesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (likesSnapshot.connectionState == ConnectionState.done) {
            if (likesSnapshot.data != null) {
              return ListView.builder(
                itemCount: likesSnapshot.data!.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<UserModel?>(
                    future: FirebaseServices.readSpecificUserData(
                        id: likesSnapshot.data![index].id),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        UserModel user = snapshot.data!;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(user.photos!.first),
                          ),
                          title: Text(user.name!),
                          trailing: Row(
                            children: [
                              IconButton.filledTonal(
                                onPressed: () {
                                  DislikeMatch.execute(user: user.id);
                                },
                                icon: const Icon(
                                  Icons.close,
                                ),
                              ),
                              IconButton.filledTonal(
                                onPressed: () {
                                  LikeBack.execute(user: user.id);
                                  DislikeMatch.execute(user: user.id);
                                },
                                icon: const Icon(
                                  Icons.check,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
