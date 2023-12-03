import 'package:dating_app/features/auth/providers/auth_provider.dart';
import 'package:dating_app/features/auth/widgets/continue_with_google_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthGoogleProvider(),
      child: const Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContinueWithGoogleButtonWidget(),
          ],
        ),
      ),
    );
  }
}
