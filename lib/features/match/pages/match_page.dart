import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/common/pages/profile_page.dart';
import 'package:dating_app/common/providers/user_provider.dart';
import 'package:dating_app/features/match/pages/filter_page.dart';
import 'package:dating_app/features/match/pages/like_page.dart';
import 'package:dating_app/features/match/providers/match_provider.dart';
import 'package:dating_app/features/match/services/dislike_match.dart';
import 'package:dating_app/features/match/services/like_match.dart';
import 'package:dating_app/features/match/widgets/match_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  CardSwiperController cardSwiperController = CardSwiperController();

  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
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
            title: const Text("Match"),
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
              IconButton(
                onPressed: () {
                  Get.to(
                    () => const FilterPage(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 800),
                  );
                },
                icon: const Icon(
                  Icons.filter_alt,
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: value.matches.isEmpty
                      ? const Center(
                          child: Text("Come back later"),
                        )
                      : CardSwiper(
                          controller: cardSwiperController,
                          allowedSwipeDirection: AllowedSwipeDirection.only(
                            left: true,
                            right: true,
                            up: false,
                            down: false,
                          ),
                          isLoop: false,
                          cardBuilder: (
                            context,
                            index,
                            horizontalOffsetPercentage,
                            verticalOffsetPercentage,
                          ) {
                            return MatchCardWidget(
                                userModel: value.matches[
                                    cardSwiperController.state!.index]);
                          },
                          cardsCount: value.matches.length,
                          numberOfCardsDisplayed: value.matches.length,
                        ),
                ),
                if (value.matches.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            cardSwiperController.swipeLeft();
                            DislikeMatch.execute(
                                user: value
                                    .matches[cardSwiperController.state!.index]
                                    .id);
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.redAccent,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.close,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        GestureDetector(
                          onTap: () {
                            cardSwiperController.undo();
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.refresh,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        GestureDetector(
                          onTap: () {
                            cardSwiperController.swipeRight();
                            LikeMatch.execute(
                              user: value
                                  .matches[cardSwiperController.state!.index]
                                  .id,
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.greenAccent,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.check,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
