// ignore_for_file: camel_case_types
// ignore_for_file: file_names

import 'dart:async';
import 'package:chatinunii/authScreens/login.dart';
import 'package:chatinunii/core/apis.dart';
import 'package:chatinunii/screens/chats/chats_screen.dart';
import 'package:chatinunii/screens/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

String? token;
String? lang;

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    Locale myLocale = Localizations.localeOf(context);

    lang = myLocale.toLanguageTag();
    print('my locale ${myLocale.toLanguageTag()}');
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString("email") != null &&
          prefs.getString("token") != null) {
        setState(() {
          token = prefs.getString("token");
          loginFlag = true;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatsScreen()));
      } else {
        Apis().getToken().then((value) {
          token = value['Response']['Token'];
          print(token);
        });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(82, 14, 125, 1),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(5)),
          child: const Text(
            'ChatInUni',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
