import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/home/home_Page.dart';
import 'package:flutter_application_2/login/login_Page.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool login = false;
    if (FirebaseAuth.instance.currentUser != null) {
      login = true;
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Director',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: login ? HomePage() : LoginPage());
  }
}
