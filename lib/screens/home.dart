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
  var _busy = 0;
  double _imageWidth, _imageHeight;
  final picker = ImagePicker();
  CallApi _callapi;
  String _instructions;
  TTS _tts;
  String texttospeak = "No Object in front";
  // this function detects the objects on the image
  void listentoobjects() {
    _tts.tts(texttospeak);
  }

  void detectinimage() async {
    setState(() {
      _busy = 0;
    });
    _tts.tts(_instructions);
  }

  detectObject(File image) async {
    Map<String, dynamic> results = await _callapi.getresults(image, "object");
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
      _busy = 2;
    });
    texttospeak = "";
    for (var i = 0; i < results.length; i++) {
      String index = i.toString();
      texttospeak = texttospeak +
          "Object '${results[index]['label']}' is at '${results[index]['height']} ${results[index]['width']}' ";
    }
    _tts.tts(
        "'Tap to Listen' and 'Double Tap to Again Click Image', If you tap Once then after Listening 'Choose again' ");
  }

  @override
  void initState() {
    super.initState();
    _busy = 0;
    _tts = new TTS();
    _callapi = new CallApi();
    _instructions = " 'Tap Once to Click an image' and 'Tap Twice to go back'";
    _tts.tts(_instructions);
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
                    0.85))
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

    if (_busy == 1) {
      stackChildren.addAll(renderBoxes(size));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Object Detector"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "Detect in Image",
            child: Icon(Icons.camera_alt),
            onPressed: () {
              setState(() {
                _busy = 0;
              });
            },
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            heroTag: "See Bounding Boxes",
            child: Icon(Icons.photo),
            onPressed: () {
              setState(() {
                _busy = 1;
              });
            },
          ),
        ],
      ),
      body: (_busy == 0)
          ? Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.red,
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
                onTap: getImageFromCamera,
                onDoubleTap: () {
                  Navigator.pop(context);
                },
              ),
            )
          : (_busy == 1)
              ? Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: stackChildren,
                  ),
                )
              : Container(
                  color: Colors.green,
                  child: GestureDetector(
                    child: Center(
                      child: Text(
                        "Listen or detect in  Image",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: listentoobjects,
                    onDoubleTap: detectinimage,
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
    _tts.tts("Image is Selected");
    setState(() {
      _busy = 1;
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
