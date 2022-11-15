import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';

class DetailScreen extends StatefulWidget {
  final String imagePath;
  DetailScreen(this.imagePath);

  @override
  _DetailScreenState createState() => new _DetailScreenState(imagePath);
}

class _DetailScreenState extends State<DetailScreen> {
  _DetailScreenState(this.path);

  final String path;

  Size? _imageSize;
  List<TextElement> _elements = [];
  List<String> emailStrings=[];
  String recognizedText = "Loading ...";
  List<String>? _listEmailStrings;
  void _initializeVision() async {
    final File imageFile = File(path);

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();

    final VisionText visionText = await textRecognizer.processImage(visionImage);
    String pattern = r'^[A-Z]{2}[0-9]{2}[A-Z]{2}\s[0-9]{4}?$';
    // String pattern = "^[A-Z]{2}\s[0-9]{1,2}\s[A-Z]{1,2}\s[0-9]{1,4}";
    RegExp regex = new RegExp(pattern,caseSensitive: true);

    String? mailAddress;
    String textA='';
    for (TextBlock block in visionText .blocks) {
      for (TextLine line in block.lines) {
        print('text: ${line.text}');
        //  mailAddress += line.text.replaceAll(' ', ' ') + '\n';
        //  print(mailAddress.replaceAll(' ', ''));
        textA+=line.text;/*
        print('remove space: ${textA}');
        if (regex.hasMatch(textA)) {
          print('true: ${textA}');
          mailAddress=textA;
          emailStrings.add(textA);
        }*/
        for (TextElement element in line.elements) {
          _elements.add(element);
        }
      }
    }
    /*  for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        if (regEx.hasMatch(TextLine line.elements)) {
          emailStrings.add(line.elements);
        }
          mailAddress += line.text + '\n';
          for (TextElement element in line.elements) {
            _elements.add(element);
          }

      }
    }*/

    if (this.mounted) {
      setState(() {
        recognizedText = textA;
      });
    }
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  @override
  void initState() {
    _initializeVision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Details"),
      ),
      body: _imageSize != null
          ? Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0,bottom: 8.0),
            child: Container(
              width: double.maxFinite,
              color: Colors.black,
              child: CustomPaint(
                foregroundPainter:
                TextDetectorPainter(_imageSize!, _elements),
                child: AspectRatio(
                  aspectRatio: _imageSize!.aspectRatio,
                  child: Image.file(
                    File(path),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Identified Text",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      child: SingleChildScrollView(
                        child: Text(
                          recognizedText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
          : Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<TextElement> elements;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextContainer container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (TextElement element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}