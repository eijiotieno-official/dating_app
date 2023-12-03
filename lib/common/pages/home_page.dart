import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dating_app/common/enum/gender_enum.dart';
import 'package:dating_app/common/pages/profile_page.dart';
import 'package:dating_app/common/providers/user_provider.dart';
import 'package:dating_app/common/services/firebase_services.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/features/chat/pages/chats_page.dart';
import 'package:dating_app/features/chat/providers/chat_provider.dart';
import 'package:dating_app/features/chat/services/fetch_chats_service.dart';
import 'package:dating_app/features/match/models/preference_model.dart';
import 'package:dating_app/features/match/pages/match_page.dart';
import 'package:dating_app/features/match/providers/match_provider.dart';
import 'package:dating_app/features/match/services/fetch_likes.dart';
import 'package:dating_app/features/match/services/fetch_matches_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final ReceivedAction? receivedAction;
  const HomePage({super.key, required this.receivedAction});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Widget> pages = [
    const MatchPage(),
    const ChatsPage(),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 800),
      () async {
        await FirebaseServices.readSpecificUserData(
                id: FirebaseUtils.currentUserId!)
            .then(
          (user) {
            if (user != null) {
              UserProvider userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              userProvider.updateCurrentUserData(user: user);
              if (user.name == null ||
                  user.about == null ||
                  user.photos == null ||
                  user.birth == null ||
                  user.gender == null ||
                  user.interests == null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfilePage(user: user);
                    },
                  ),
                );
              }
              MatchProvider matchProvider =
                  Provider.of<MatchProvider>(context, listen: false);
              matchProvider
                  .updatePreference(
                preferenceModel: PreferenceModel(
                  maxAge: matchProvider.preference.maxAge,
                  minAge: matchProvider.preference.minAge,
                  gender: matchProvider.preference.gender == Gender.man
                      ? Gender.woman
                      : Gender.man,
                  interests: matchProvider.preference.interests,
                  distance: matchProvider.preference.distance,
                ),
              )
                  .then(
                (_) {
                  FetchMatchesService.execute(matchProvider: matchProvider);
                  FetchLikes.execute();
                },
              );

              ChatProvider chatProvider =
                  Provider.of<ChatProvider>(context, listen: false);
              FetchChatsService.execute(chatProvider: chatProvider);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color navColor = ElevationOverlay.applySurfaceTint(
      Theme.of(context).colorScheme.surface,
      Theme.of(context).colorScheme.surfaceTint,
      3,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: List.generate(
            pages.length,
            (index) => index == selectedIndex
                ? Offstage(
                    offstage: false,
                    child: pages[index],
                  )
                : Offstage(child: pages[index]),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.favorite,
              ),
              icon: Icon(
                Icons.favorite_outline,
              ),
              label: "Matches",
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.chat_bubble,
              ),
              icon: Icon(
                Icons.chat_bubble_outline,
              ),
              label: "Chats",
            ),
          ],
        ),
      ),
    );
  }
}
