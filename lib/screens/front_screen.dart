import 'package:flutter/material.dart';
import 'package:visualrecogntiontoaudio/helper/tts.dart';
import 'package:visualrecogntiontoaudio/screens/detect_text.dart';
import '../screens/home.dart';

class Front extends StatefulWidget {
  @override
  _FrontState createState() => _FrontState();
}

class _FrontState extends State<Front> {
  TTS _tts;
  @override
  void initState() {
    super.initState();
    _tts = new TTS();
    _tts.tts("""Tap Once to 'TO Detect Objects from
         Image' and 'Tap Twice to Detect Text'""");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Object Detector App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: aboutDialog,
          ),
        ],
      ),
      body: Container(
        color: Colors.blue,
        child: GestureDetector(
          child: Center(
            child: Text(
              "Object Detection or Text Detection",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          },
          onDoubleTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetectText(),
              ),
            );
          },
        ),
      ),
    );
  }

  aboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: "Object and Text Detector App",
      applicationLegalese: "By Team",
      applicationVersion: "1.0",
      children: <Widget>[
        Text("agarwalsahil97@gmail.com"),
        Text(
            "This app provides assistance to visually impaired people to hear what they can't see")
      ],
    );
  }
}
