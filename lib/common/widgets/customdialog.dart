import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';

class CustomDialog extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

dialogContent(BuildContext context) {
  return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              const Text(
               "Are you sure you want to exit from PetroSoftIndia app?",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
              ),


              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                       // focusColor: SavangadiAppTheme.grey,
                        onPressed: () {
                         exit(0);// To close the dialog
                        },
                        child: const Text("Yes", style: TextStyle(color: Colors.black,
                            //fontFamily: SavangadiAppTheme.fontName,
                            fontSize: 18),
                        ),
                      ),
                    ),

                  ),
                  const SizedBox(width: 30,),
                  Container(
                    decoration: BoxDecoration(
                      color:ColorsForApp.appThemeColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                       // focusColor: SavangadiAppTheme.grey,
                        onPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                        child: const Text('No', style: TextStyle(color: Colors.white,
                           // fontFamily: SavangadiAppTheme.fontName,
                            fontSize: 18),),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child:
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Image.asset(PetroSoftAssetFiles.questionMark),
          ),

        ),
      ]
  );
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 50;
}
