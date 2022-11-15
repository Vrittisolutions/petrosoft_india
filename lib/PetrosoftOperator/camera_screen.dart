import 'dart:convert';
import 'dart:io';
import 'package:petrosoft_india/PetrosoftOperator/detail_screen.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:camera/camera.dart';
import 'package:exif/exif.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'capture_images.dart';



class CameraScreen extends StatefulWidget {
  final String onClick,imageSequenceId;

  const CameraScreen({Key? key, required this.onClick,required this.imageSequenceId}) : super(key: key);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
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
    /* Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
         CaptureImages(imgPath!,widget.onClick)), (Route<dynamic> route) => false);*/
   /*  return Navigator.of(context)
         .pushReplacement(CupertinoPageRoute<bool>(builder: (BuildContext context) {
       return  CaptureImages(imgPath!,widget.onClick);
     }));*/
     // return true if the route to be popped
   }
   Future<File> fixExifRotation(String imagePath) async {
     final originalFile = File(imagePath);
     List<int> imageBytes = await originalFile.readAsBytes();

     final originalImage = img.decodeImage(imageBytes);

     final height = originalImage!.height;
     final width = originalImage.width;

     // Let's check for the image size
     if (height >= width) {
       print('image necessary');
       // I'm interested in portrait photos so
       // I'll just return here

       return originalFile;
     }
     final exifData = await readExifFromBytes(imageBytes);

     img.Image? fixedImage;

     if (height < width) {
      print('Rotating image necessary');
       // rotate
       if (exifData['Image Orientation']!.printable.contains('Horizontal')) {
          fixedImage = img.copyRotate(originalImage, 360);
       } else if (exifData['Image Orientation']!.printable.contains('180')) {
         fixedImage = img.copyRotate(originalImage, -90);
       } else {
         fixedImage = img.copyRotate(originalImage, 0);
       }
     }

     // Here you can select whether you'd like to save it as png
     // or jpg with some compression
     // I choose jpg with 100% quality
     final fixedFile =
     await originalFile.writeAsBytes(img.encodeJpg(fixedImage!));

     return fixedFile;

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
                        fixExifRotation(path).then((value){
                          if(value!=null){
                            if(widget.onClick=="Vehicle"){
                              List<int> imageBytes = File(imageFile!.path).readAsBytesSync();
                              String base64String = base64Encode(imageBytes);
                              UT.m["img1"]=base64String;
                             Navigator.of(context).pop({'onClick':widget.onClick,'path':path});
                            }
                            if(widget.onClick=="Start"){
                              List<int> imageBytes = File(imageFile!.path).readAsBytesSync();
                              String base64String = base64Encode(imageBytes);
                              UT.m["img2"]=base64String;
                              Navigator.of(context).pop({'onClick':widget.onClick,'path':path});
                            }
                            if(widget.onClick=="End"){
                              List<int> imageBytes = File(imageFile!.path).readAsBytesSync();
                              String base64String = base64Encode(imageBytes);
                              UT.m["img3"]=base64String;
                              Navigator.of(context).pop({'onClick':widget.onClick,'path':path});
                            }
                            if(widget.onClick=="Other1"){
                              List<int> imageBytes = File(imageFile!.path).readAsBytesSync();
                              String base64String = base64Encode(imageBytes);
                              UT.m["img4"]=base64String;
                              Navigator.of(context).pop({'onClick':widget.onClick,'path':path});
                            }
                            if(widget.onClick=="Other2"){
                              List<int> imageBytes = File(imageFile!.path).readAsBytesSync();
                              String base64String = base64Encode(imageBytes);
                              UT.m["img5"]=base64String;
                              Navigator.of(context).pop({'onClick':widget.onClick,'path':path});
                            }
                          }
                        });
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