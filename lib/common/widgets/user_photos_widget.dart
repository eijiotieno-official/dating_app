import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:story/story.dart';
import 'package:transparent_image/transparent_image.dart';

class UserPhotosWidget extends StatelessWidget {
  final List<dynamic>? photos;
  const UserPhotosWidget({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return photos == null || photos!.isEmpty
        ? const Center(
            child: Text("Pick a photo"),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StoryPageView(
              backgroundColor: Theme.of(context).colorScheme.background,
              itemBuilder: (context, pageIndex, storyIndex) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    fadeInDuration: const Duration(milliseconds: 500),
                    placeholder: MemoryImage(kTransparentImage),
                    image: CachedNetworkImageProvider(
                      photos![pageIndex],
                    ),
                  ),
                );
              },
              storyLength: (pageIndex) {
                return photos!.length;
              },
              pageLength: photos!.length,
            ),
          );
  }
}
