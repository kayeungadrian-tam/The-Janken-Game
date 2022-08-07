import 'package:app/pages/GamePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';
import 'package:app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

import 'HomePage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
              showAuthActionSwitch: false,
              headerBuilder: (context, constraints, _) {
                return Padding(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Lottie.network(
                          "https://assets4.lottiefiles.com/packages/lf20_goip5r0d/final test/data.json",
                        )));
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      Text(
                        action == AuthAction.signIn
                            ? 'Welcome to FlutterFire UI! Please sign in to continue.'
                            : 'Welcome to FlutterFire UI! Please create an account to continue',
                      ),
                    ],
                  ),
                );
              },
              footerBuilder: (context, _) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'By signing in, you agree to our terms and conditions.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
              providerConfigs: [
                EmailProviderConfiguration(),
                GoogleProviderConfiguration(
                    clientId:
                        "556325043232-nhnvmfb1monh87gcuokd0s3pdpf74q3p.apps.googleusercontent.com")
              ]);
        }
        return HomeScreen();
      },
    );
  }
}
