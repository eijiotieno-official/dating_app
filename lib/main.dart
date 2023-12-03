import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dating_app/common/pages/check_auth_status_page.dart';
import 'package:dating_app/common/pages/home_page.dart';
import 'package:dating_app/common/providers/user_provider.dart';
import 'package:dating_app/common/services/location_services.dart';
import 'package:dating_app/common/services/notification_listener_service.dart';
import 'package:dating_app/common/themes/dark_theme.dart';
import 'package:dating_app/common/themes/light_theme.dart';
import 'package:dating_app/features/chat/providers/chat_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import 'features/match/providers/match_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocationServices.grantPermission();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => MatchProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MainApp(),
    ),
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static const String homeRoute = '/home';

  @override
  void initState() {
    NotificationListenerService.startListeningNotificationEvents();
    super.initState();
  }

  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName) {
    List<Route<dynamic>> pageStack = [];

    pageStack
        .add(MaterialPageRoute(builder: (_) => const CheckAuthStatusPage()));

    if (NotificationListenerService.initialAction != null) {
      pageStack.add(
        MaterialPageRoute(
          builder: (_) => HomePage(
              receivedAction: NotificationListenerService.initialAction),
        ),
      );
    }
    return pageStack;
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        ReceivedAction receivedAction = settings.arguments as ReceivedAction;
        return MaterialPageRoute(
          builder: (_) => HomePage(receivedAction: receivedAction),
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      navigatorKey: MainApp.navigatorKey,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onGenerateRoute: onGenerateRoute,
    );
  }
}
