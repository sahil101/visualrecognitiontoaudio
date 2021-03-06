import 'package:flutter/material.dart';
import 'package:visualrecogntiontoaudio/screens/splash_screen.dart';

// List<CameraDescription> cameras;

// Future<void>
void main() {
  // initialize the cameras when the app starts
  // WidgetsFlutterBinding.ensureInitialized();
  // cameras = await availableCameras();
  // running the app
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MySplash(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
    );
  }
}
