import 'package:petrosoft_india/Classes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home_Page extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Home_Page();
  }

}

class _Home_Page extends State{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.appThemeColorPetroOperator,
      appBar: AppBar(title: const Text('Add Credit Sale',), backgroundColor: ColorsForApp.appThemeColorPetroOperator),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(padding: EdgeInsets.only(top: 20),
          ),
        ),
      ),
    );
  }

}