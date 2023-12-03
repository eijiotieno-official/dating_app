import 'package:dating_app/common/pages/home_page.dart';
import 'package:dating_app/features/auth/pages/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckAuthStatusPage extends StatefulWidget {
  const CheckAuthStatusPage({super.key});

  @override
  State<CheckAuthStatusPage> createState() => _CheckAuthStatusPageState();
}

class _CheckAuthStatusPageState extends State<CheckAuthStatusPage> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) async {
        if (user == null) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const AuthPage();
                },
              ),
            );
          }
        } else {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const HomePage(receivedAction: null);
                },
              ),
            );
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: CircularProgressIndicator(strokeCap: StrokeCap.round));
  }
}
