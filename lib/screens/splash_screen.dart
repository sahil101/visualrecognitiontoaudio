import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:visualrecogntiontoaudio/screens/home.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: Home(),
      title: Text(
        'Visual to Audio converter',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Color(0xFFE99600),
        ),
      ),
      image: Image.asset('assets/Blind-app-logo.png'),
      backgroundColor: Colors.black,
      photoSize: 100.0,
      loaderColor: Colors.white,
    );
  }
}
