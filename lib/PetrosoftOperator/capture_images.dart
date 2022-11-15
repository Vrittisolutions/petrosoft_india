import 'dart:io';
import 'package:petrosoft_india/PetrosoftOwner/Reports/report_list.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'camera_screen.dart';
class CaptureImages extends StatefulWidget {
  final String imagePath;
  final String onClick;
  CaptureImages(this.imagePath,this.onClick);
  @override
  _CaptureImagesState createState() => _CaptureImagesState(imagePath,onClick);
}

class _CaptureImagesState extends State<CaptureImages> {
  final String path;
  final String onTap;
  _CaptureImagesState(this.path,this.onTap);
  var vehicleNoImagePath;
  var startMeterImagePath;
  var endMeterImagePath;
  var otherImage1Path;
  var otherImage2ImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 SizedBox(height: 100,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Column(children: [
                       InkWell(
                         onTap: () async {
                           Map map=await Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => CameraScreen(onClick:"Vehicle",imageSequenceId:"1"),
                             ),
                           );
                           if(map['onClick']=="Vehicle"){
                             String Uuid1= Uuid().v1();
                             String? prepareImagepath=UT.CustCodeAmt!+"_"+ Uuid1+"_"+"1"+".jpeg";

                             Map<String,dynamic> image={
                                "imageID":prepareImagepath,
                                "image_sequenceId":"1"
                              };
                             UT.imageList.add(image);
                             vehicleNoImagePath=map['path'];
                             setState(() {
                             });
                           }
                         },
                         child: Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20),
                             border: Border.all(color: Colors.grey.shade300),
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.grey.shade100,
                                 blurRadius: 1.0,
                                 spreadRadius: 1.0, //extend the shadow
                                 offset: Offset(
                                   3.0, // Move to right 10  horizontally
                                   3.0, // Move to bottom 5 Vertically
                                 ),
                               ),
                             ],
                             color: Colors.white,
                           ),
                           child: Container(
                               width: 150,
                               height: 100,
                               child: vehicleNoImagePath!=null?Image.file(
                                 File(vehicleNoImagePath),fit: BoxFit.cover,
                               ):Icon(Icons.camera_alt)
                           ),
                         ),
                       ),
                      Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(
                           'Vehicle No',
                           style: TextStyle(color: UT.PetroOperatorAppColor),
                         ),
                       ),
                     ],
                     ),
                     Column(children: [
                       InkWell(
                         onTap: () async {
                           Map map=await Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => CameraScreen(onClick:"Start",imageSequenceId:"2"),
                             ),
                           );
                           if(map['onClick']=="Start"){
                             startMeterImagePath=map['path'];
                             String Uuid1= Uuid().v1();
                             String? prepareImagepath=UT.CustCodeAmt!+"_"+ Uuid1+"_"+"2"+".jpeg";
                             Map<String,dynamic> image={
                               "imageID":prepareImagepath,
                               "image_sequenceId":"2"
                             };
                             UT.imageList.add(image);
                             setState(() {
                             });
                           }
                         },
                         child: Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20),
                             border: Border.all(color: Colors.grey.shade300),
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.grey.shade100,
                                 blurRadius: 1.0,
                                 spreadRadius: 1.0, //extend the shadow
                                 offset: Offset(
                                   3.0, // Move to right 10  horizontally
                                   3.0, // Move to bottom 5 Vertically
                                 ),
                               ),
                             ],
                             color: Colors.white,
                           ),
                           child: Container(
                               width: 150,
                               height: 100,
                               child:startMeterImagePath!=null?Image.file(
                                 File(startMeterImagePath),fit: BoxFit.cover,
                               ): Icon(Icons.camera_alt)
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(
                           'Start Meter',
                           style: TextStyle(color: UT.PetroOperatorAppColor),
                         ),
                       ),
                     ],
                     ),
                   ],
                 ),
                 SizedBox(height: 10,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Column(children: [
                       InkWell(
                         onTap: () async {
                           Map map=await Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => CameraScreen(onClick:"End",imageSequenceId:"3"),
                             ),
                           );
                           if(map['onClick']=="End"){
                             endMeterImagePath=map['path'];
                             String Uuid1= Uuid().v1();
                             String? prepareImagepath=UT.CustCodeAmt!+"_"+ Uuid1+"_"+"3"+".jpeg";
                             Map<String,dynamic> image={
                               "imageID":prepareImagepath,
                               "image_sequenceId":"3"
                             };
                             UT.imageList.add(image);
                             setState(() {
                             });
                           }

                         },
                         child: Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20),
                             border: Border.all(color: Colors.grey.shade300),
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.grey.shade100,
                                 blurRadius: 1.0,
                                 spreadRadius: 1.0, //extend the shadow
                                 offset: Offset(
                                   3.0, // Move to right 10  horizontally
                                   3.0, // Move to bottom 5 Vertically
                                 ),
                               ),
                             ],
                             color: Colors.white,
                           ),
                           child: Container(
                               width: 150,
                               height: 100,
                               child: endMeterImagePath!=null?Image.file(
                                 File(endMeterImagePath),fit: BoxFit.cover,
                               ):Icon(Icons.camera_alt)
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(
                           'End Meter',
                           style: TextStyle(color: UT.PetroOperatorAppColor),
                         ),
                       ),
                     ],
                     ),
                     Column(children: [
                       InkWell(
                         onTap: () async {
                           Map map=await Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => CameraScreen(onClick:"Other1",imageSequenceId:"4"),
                             ),
                           );
                           if(map['onClick']=="Other1"){
                             otherImage1Path=map['path'];
                             String Uuid1= Uuid().v1();
                             String? prepareImagepath=UT.CustCodeAmt!+"_"+ Uuid1+"_"+"4"+".jpeg";
                             Map<String,dynamic> image={
                               "imageID":prepareImagepath,
                               "image_sequenceId":"4"
                             };
                             UT.imageList.add(image);
                             setState(() {
                             });
                           }
                         },
                         child: Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20),
                             border: Border.all(color: Colors.grey.shade300),
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.grey.shade100,
                                 blurRadius: 1.0,
                                 spreadRadius: 1.0, //extend the shadow
                                 offset: Offset(
                                   3.0, // Move to right 10  horizontally
                                   3.0, // Move to bottom 5 Vertically
                                 ),
                               ),
                             ],
                             color: Colors.white,
                           ),
                           child: Container(
                               width: 150,
                               height: 100,
                               child: otherImage1Path!=null?Image.file(
                                 File(otherImage1Path),fit: BoxFit.cover,
                               ):Icon(Icons.camera_alt)
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(
                           'Other Image1',
                           style: TextStyle(color: UT.PetroOperatorAppColor),
                         ),
                       ),
                     ],
                     ),

                   ],
                 ),
                 SizedBox(height: 10,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Column(children: [
                       InkWell(
                         onTap: () async {
                           Map map=await Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => CameraScreen(onClick:"Other2",imageSequenceId:"5"),
                             ),
                           );
                           if(map['onClick']=="Other2"){
                             otherImage2ImagePath=map['path'];
                             String Uuid1= Uuid().v1();
                             String? prepareImagepath=UT.CustCodeAmt!+"_"+ Uuid1+"_"+"5"+".jpeg";
                             Map<String,dynamic> image={
                               "imageID":prepareImagepath,
                               "image_sequenceId":"5"
                             };
                             UT.imageList.add(image);
                             setState(() {
                             });
                           }
                         },
                         child: Container(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20),
                             border: Border.all(color: Colors.grey.shade300),
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.grey.shade100,
                                 blurRadius: 1.0,
                                 spreadRadius: 1.0, //extend the shadow
                                 offset: Offset(
                                   3.0, // Move to right 10  horizontally
                                   3.0, // Move to bottom 5 Vertically
                                 ),
                               ),
                             ],
                             color: Colors.white,
                           ),
                           child: Container(
                               width: 150,
                               height: 100,
                               child:otherImage2ImagePath!=null?Image.file(
                                 File(otherImage2ImagePath),fit: BoxFit.cover,
                               ): Icon(Icons.camera_alt)
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(
                           'Other Image2',
                           style: TextStyle(color: UT.PetroOperatorAppColor),
                         ),
                       ),
                     ],
                     ),
                   ],
                 ),
               ],
              ) ),
        ),
      ),
    );
  }

}