import 'dart:convert';
import 'dart:io';
import 'package:petrosoft_india/Classes/pdf_viewer.dart';
import 'package:petrosoft_india/PetrosoftManager/Reports/report_list.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';

class DownloadFile extends StatefulWidget {
   const DownloadFile({Key? key,
    required this.child, required this.url,
  }) : super(key: key);

  final Widget child;
  final String url;

  @override
  _DownloadFileState createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
 bool downloading = true;
  var progress = "";
  var path = "No Data";
  dynamic savedPath;
  var platformVersion = "Unknown";
  late Directory externalDir;
  bool failureCase=false;
  var _onPressed;
 final imgUrl =
     "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
 var dio = Dio();
  @override
  initState()  {
    super.initState();
    print(widget.url);


    downloadFile(widget.url);
  }
  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return  const ManagerReportList();
    }));
    // return true if the route to be popped
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        body: Center(
      child: downloading
      ? SizedBox(
      height: 120.0,
        width: 200.0,
        child: Card(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                'Downloading File: $progress',
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      )
          :failureCase==true? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("File download failed!!",style: TextStyle(fontSize: 17,color: UT.ownerAppColor,fontWeight: FontWeight.bold),),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Something went wrong \n    please try again!!",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
              ],
            ),
          ),

         /* MaterialButton(
            child: Text('View Report'),
            onPressed: () async {
            downloadFile(widget.url);
            },
            disabledColor: Colors.blueGrey,
            color: Colors.pink,
            textColor: Colors.white,
            height: 40.0,
            minWidth: 100.0,
          ),*/
        ],
      ):Container()
        ),
      ),
    );
  }
   Future getPdfURl(String url)async{
   bool noData=false;
    var data = await UT.apiStr(url);
    print("report api ress-->$data");
    if(data.contains("Message")){
      var jData = json.decode(data);
       if(jData["Message"]=="An error has occurred."){
         setState(() {
           failureCase=true;
           noData=true;
         });
         return noData;
       }
       return noData;
    }
    else{
      return data;
    }
  }
 void checkServiceStatus(
     BuildContext context, PermissionWithService permission) async {
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
     content: Text((await permission.serviceStatus).toString()),
   ));
 }
   /*Future<void> downloadFile(String url) async {
   getPdfURl(url).then((value) async {
     print("RES-->$value");
     if(value==true){
       downloading=false;
       failureCase=true;
     }else{

       final pdfUrl = "${UT.ReportAPIURL}reportspdf/"+value+".pdf";

       final status = await Permission.storage.request();
       if (status.isGranted) {
         String dirloc = "";
         if (Platform.isAndroid) {
           //dirloc = "/sdcard/download/";
           dirloc = (await getApplicationDocumentsDirectory()).path;
           path = dirloc + "/$value" + ".pdf";
           File file = File(path);
           var request = await http.get(Uri.parse(pdfUrl));
           print(request.body);
           var bytes = await request.bodyBytes;//close();
           await file.writeAsBytes(bytes);
           print(file.path);
           Navigator.of(context)
               .pushReplacement(CupertinoPageRoute<bool>(builder: (BuildContext context) {
             return   CustomPdfView(url:path);
           }));

         } else {
           dirloc = (await getApplicationDocumentsDirectory()).path;

         }
       }
     }
   });


 }*/
 Future download2(Dio dio, String url,String fileName ) async {
   try {
     Response response = await dio.get(
       url,
       onReceiveProgress: showDownloadProgress,
       //Received data with List<int>
       options: Options(
           responseType: ResponseType.bytes,
           followRedirects: false,
           validateStatus: (status) {
             return status! < 500;
           }),
     );
     print(response.headers);
     String dir = (await getApplicationDocumentsDirectory()).path;
     var tempDir = await getTemporaryDirectory();
     String fullPath = "$dir/$fileName.pdf";
     print('full path ${fullPath}');
     File file = File(fullPath);
     var raf = file.openSync(mode: FileMode.write);
     // response.data is List<int> type
     raf.writeFromSync(response.data);
     await raf.close();
     downloading = false;
     // DialogBuilder(context).hideOpenDialog();
     progress = "Download Completed.";
     Navigator.of(context)
         .pushReplacement(CupertinoPageRoute<bool>(builder: (BuildContext context) {
       return   CustomPdfView(url:file.path);
     }));
   } catch (e) {
     print(e);
   }
 }
 void showDownloadProgress(received, total) {
   if (total != -1) {
     print((received / total * 100).toStringAsFixed(0) + "%");
   }
 }
Future<void> downloadFile(String url) async {
    getPdfURl(url).then((value) async {
      print("RES-->$value");
      if(value==true){
        downloading=false;
        failureCase=true;
      }else{

        final pdfUrl = "${UT.ReportAPIURL}reportspdf/"+value+".pdf";

        final status = await Permission.storage.request();
        if (status.isGranted) {
         download2(dio, pdfUrl,value);


        } else {
          final status = await Permission.storage.request();
          setState(() {
            print(status);
            progress = "Permission Denied!";
            _onPressed = () {
              downloadFile(url);
            };
          });
        }
      }
});


  }
   /*Future<void> downloadFile(String url) async {
    getPdfURl(url).then((value) async {
      print("RES-->$value");
      if(value==true){
        downloading=false;
        failureCase=true;
      }else{

        final pdfUrl = "${UT.ReportAPIURL}reportspdf/"+value+".pdf";
        Dio dio = Dio();
        final status = await Permission.storage.request();
        if (status.isGranted) {
          String dirloc = "";
          if (Platform.isAndroid) {
            //dirloc = "/sdcard/download/";
            dirloc = (await getApplicationDocumentsDirectory()).path;


            try {
              // FileUtils.mkdir([dirloc]);
              print("pdfurl-->$pdfUrl");


              await dio.download(pdfUrl, dirloc + "$value" + ".pdf",
                  onReceiveProgress: (receivedBytes, totalBytes) {
                    print("here 1");
                    setState(() {
                      //  DialogBuilder(context).showLoadingIndicator('');
                      downloading = true;
                      progress = ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
                      print(progress);
                    });
                    print("here 2");
                  });

            } catch (e) {
              print('catch catch catch');
              print(e);
              final status = await Permission.storage.request();

            }
          } else {
            dirloc = (await getApplicationDocumentsDirectory()).path;

          }
          setState(() {
            downloading = false;
            // DialogBuilder(context).hideOpenDialog();
            progress = "Download Completed.";
            // path = dirloc + convertCurrentDateTimeToString() + ".pdf";
            path = dirloc + "/$value" + ".pdf";
            Navigator.of(context)
                .pushReplacement(CupertinoPageRoute<bool>(builder: (BuildContext context) {
              return   CustomPdfView(url:path);
            }));
          });

        } else {
          final status = await Permission.storage.request();
          setState(() {
            print(status);
            progress = "Permission Denied!";
            _onPressed = () {
              downloadFile(url);
            };
          });
        }
      }
});


  }*/
}