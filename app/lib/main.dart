import 'package:app/pages/GamePage.dart';
import 'package:app/pages/IndexPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        // primaryColor: Colors.amberAccent,
        // hintColor: Colors.amberAccent,
        // indicatorColor: Colors.amberAccent,
        // shadowColor: Colors.amberAccent,
        // highlightColor: Colors.amberAccent,
        splashColor: Colors.amberAccent,
      ),
      home: AuthGate(),
    );
  }
}
