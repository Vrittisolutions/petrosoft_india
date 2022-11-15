import 'dart:convert';
import 'dart:io';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:camera/camera.dart';
import 'package:exif/exif.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class PumpReadingCamera extends StatefulWidget {
  final String onClick;

  const PumpReadingCamera({Key? key, required this.onClick}) : super(key: key);
  @override
  _PumpReadingCameraState createState() => _PumpReadingCameraState();
}

class _PumpReadingCameraState extends State<PumpReadingCamera> {
   CameraController _controller=CameraController(UT.cameras[0], ResolutionPreset.medium);
    String? imgPath;
   XFile? imageFile;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(UT.cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _takePicture() async {
    if (!_controller.value.isInitialized) {
      print("Controller is not initialized");
      return null as String;
    }

    // Formatting Date and Time
    String dateTime = DateFormat.yMMMd()
        .addPattern('-')
        .add_Hms()
        .format(DateTime.now())
        .toString();

    String formattedDateTime = dateTime.replaceAll(' ', '');
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';
    imgPath=imagePath;
    if (_controller.value.isTakingPicture) {
      print("Processing is progress ...");
      return null as String;
    }
    try {
      await _controller.takePicture().then((XFile? file){
        if (mounted) {
          setState(() {
            imageFile = file;
          });
        }
      });
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null as String;
    }
    imgPath=imagePath;
    return imageFile!.path;
  }

   Future<bool?> _willPopCallback()async{
    Navigator.of(context).pop();
   }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('ML Vision'),
        ),
        body: _controller.value.isInitialized
            ? Stack(
          children: <Widget>[
            CameraPreview(_controller),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.camera),
                  label: Text("Click"),
                  onPressed: () async {
                    await _takePicture().then((String path) {
                      if (path != null) {
                        if(widget.onClick=="Start"){
                          List<int> imageBytes = File(imageFile!.path).readAsBytesSync();
                          String base64String = base64Encode(imageBytes);
                          UT.m["Start"]=base64String;
                          Navigator.of(context).pop({'onClick':widget.onClick,'path':path});
                        }
                        if(widget.onClick=="End"){
                          List<int> imageBytes = File(imageFile!.path).readAsBytesSync();
                          String base64String = base64Encode(imageBytes);
                          UT.m["End"]=base64String;
                          Navigator.of(context).pop({'onClick':widget.onClick,'path':path});
                        }
                      }
                    });
                  },
                ),
              ),
            )
          ],
        )
            : Container(
          color: Colors.black,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}