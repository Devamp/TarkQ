import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tark_q/views/landing-page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tark_q/views/navbar-views/profile-page.dart';
import 'components/nav-bar.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Firebase initialized.');

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) await userServices.loadUserOnLogin();
  runApp(MyApp(isLoggedIn: user != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TarkQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: isLoggedIn ? NavBar() : Landing(),
    );
  }
}
