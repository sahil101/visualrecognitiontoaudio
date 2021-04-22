import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:visualrecogntiontoaudio/screens/live_screen.dart';
import 'package:visualrecogntiontoaudio/screens/splash_screen.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  // initialize the cameras when the app starts
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  // running the app
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: GestureDetector(
                    child: Center(
                      child: Text(
                        "Detect in Image",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MySplash(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.purple,
                  child: GestureDetector(
                    child: Center(
                        child: Text(
                      "Real Time Detection",
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveFeed(cameras),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  aboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: "Object Detector App",
      applicationLegalese: "By Team",
      applicationVersion: "1.0",
      children: <Widget>[
        Text("agarwalsahil97@gmail.com"),
      ],
    );
  }
}
