import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visualrecogntiontoaudio/helper/tts.dart';
import '/helper/api.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _image;
  Map<String, dynamic> _recognitions;
  bool _busy = false;
  double _imageWidth, _imageHeight;
  final picker = ImagePicker();
  CallApi _callapi = new CallApi();

  // this function detects the objects on the image
  detectObject(File image) async {
    Map<String, dynamic> results = await _callapi.getresults(image);
    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
          });
        })));
    setState(() {
      _recognitions = results;
    });
    String texttospeak = "";
    TTS tts = new TTS();
    for (var i = 0; i < results.length; i++) {
      String index = i.toString();
      texttospeak = texttospeak +
          "Object ${results[index]['label']} is at ${results[index]['height']} ${results[index]['width']} ";
    }
    await tts.tts(texttospeak);
  }

  @override
  void initState() {
    super.initState();
    _busy = false;
  }

  // display the bounding boxes over the detected objects
  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageHeight * screen.width;
    Color blue = Colors.blue;
    List<Container> containers = [];
    for (var i = 0; i < _recognitions.length; i++) {
      var index = i.toString();
      double left =
          (double.parse(_recognitions[index]["centerX"]) / _imageWidth);
      double top =
          (double.parse(_recognitions[index]["centerY"]) / _imageHeight);
      double width = (double.parse(_recognitions[index]["W"]) / _imageWidth);
      double height = (double.parse(_recognitions[index]["H"]) / _imageHeight);
      print(left);
      containers.add(Container(
        child: Positioned(
            left: left * factorX,
            top: top * factorY,
            width: width * factorX,
            height: height * factorY,
            child: ((double.parse(_recognitions[index]["confidence_score"]) >
                    0.50))
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: blue,
                      width: 3,
                    )),
                    child: Text(
                      "${_recognitions[index]["label"]} ${(double.parse(_recognitions[index]["confidence_score"]) * 100).toStringAsFixed(0)}%",
                      style: TextStyle(
                        background: Paint()..color = blue,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  )
                : Container()),
      ));
    }
    return containers;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> stackChildren = [];

    stackChildren.add(Positioned(
      // using ternary operator
      child: _image == null
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Please Select an Image"),
                ],
              ),
            )
          : // if not null then
          Container(child: Image.file(_image)),
    ));

    stackChildren.addAll(renderBoxes(size));

    if (_busy) {
      stackChildren.add(Center(
        child: CircularProgressIndicator(),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Object Detector"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "Fltbtn2",
            child: Icon(Icons.camera_alt),
            onPressed: getImageFromCamera,
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            heroTag: "Fltbtn1",
            child: Icon(Icons.photo),
            onPressed: getImageFromGallery,
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          children: stackChildren,
        ),
      ),
    );
  }

  // gets image from camera and runs detectObject
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image Selected");
      }
    });
    detectObject(_image);
  }

  // gets image from gallery and runs detectObject
  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image Selected");
      }
    });
    detectObject(_image);
  }
}
