import 'package:dating_app/common/pages/home_page.dart';
import 'package:dating_app/features/auth/enum/auth_state_enum.dart';
import 'package:dating_app/features/auth/providers/auth_provider.dart';
import 'package:dating_app/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';

class ContinueWithGoogleButtonWidget extends StatelessWidget {
  const ContinueWithGoogleButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthGoogleProvider>(
      builder: (context, value, child) {
        return Center(
          child: value.authState == AuthStateEnum.loading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeCap: StrokeCap.butt,
                    ),
                  ),
                )
              : SignInButton(
                  elevation: 1,
                  buttonType: ButtonType.google,
                  buttonSize: ButtonSize.medium,
                  btnText: "Continue with Google",
                  onPressed: () async {
                    if (value.authState == AuthStateEnum.pause) {
                      await AuthService.logIn(authProvider: value).then(
                        (_) {
                          if (value.authState == AuthStateEnum.success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const HomePage(receivedAction: null);
                                },
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
        );
      },
    );
  }
}
