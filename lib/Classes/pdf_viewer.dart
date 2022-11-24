/*
import 'dart:io';

import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class CustomPdfView extends StatefulWidget {
  final String url;

  const CustomPdfView({Key? key, required this.url}) : super(key: key);
  @override
  _CustomPdfViewState createState() => _CustomPdfViewState();
}

class _CustomPdfViewState extends State<CustomPdfView> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoading = true;
  late SfPdfViewer document;

  @override
  void initState() {
    super.initState();
    print(widget.url);
    loadDocument();
  }

  loadDocument() async {

   // document = await PDFDocument.fromURL("http://com.vritti.petrosoft_india/"+widget.url);
    document= await SfPdfViewer.file(
      File(widget.url),
    );
    setState(() => _isLoading = false);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsForApp.app_theme_color_owner,
          iconTheme: const IconThemeData(color: Colors.white),
        title: const CommonAppBarText(title: 'Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              await Share.shareFiles(
                [widget.url],
                text: "Report",
              );
            },
          )
        ],
      ),
      body: Center(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            :SfPdfViewer.file(
          File(widget.url),
        )
      ),
    );
  }
}*/
