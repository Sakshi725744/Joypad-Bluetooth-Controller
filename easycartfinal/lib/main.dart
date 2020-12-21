import 'dart:async';
import 'dart:convert' show utf8;
import 'package:easycartfinal/MobileAuth/Authservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Easycart",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(accentColor: Color(0xfff20b0b)),
      home: AuthService().handleAuth(),
      //MobileAuth directory
    );
  }
}

