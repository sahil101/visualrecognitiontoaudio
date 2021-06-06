import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import '/screens/front_screen.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: Front(),
      title: Text(
        'Visual to Audio converter',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Colors.blue,
        ),
      ),
      image: Image.asset(
        'assets/Blind-app-logo.png',
      ),
      backgroundColor: Colors.black,
      photoSize: 100.0,
      loaderColor: Colors.white,
    );
  }
}
