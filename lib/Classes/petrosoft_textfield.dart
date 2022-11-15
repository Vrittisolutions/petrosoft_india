import 'package:petrosoft_india/Classes/colors.dart';
import 'package:flutter/material.dart';

import 'converter.dart';

class PetroTextField {

  static textField(TextEditingController controller,var icon,var label_text){
    return Padding(padding: EdgeInsets.only(top: 3,bottom: 3),
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0.0),
              isDense: true,
              labelText: label_text,
              labelStyle: new TextStyle(
                  fontSize: 14.0,
                  color: ColorConverter.hexToColor("#838383")
              ),
              icon: Icon(icon,color:ColorConverter.hexToColor("#5C7000"),size: 20,),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: ColorsForApp.app_theme_color_light_drawer),
              )
            ),
            minLines: 1,
            maxLines: 1,
          ),
          Divider(height: 5,thickness: 1,color: ColorConverter.hexToColor("#8F8F8F"),),
        ],
      ),);
  }
  static textField_Disable(TextEditingController controller,var icon,var label_text,bool flag){
    return Padding(padding: EdgeInsets.only(top: 3,bottom: 3),
      child: Column(
        children: [
          TextField(
            enabled: flag,
            controller: controller,

            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0.0),
              isDense: true,
              labelText: label_text,
              labelStyle: new TextStyle(
                  fontSize: 14.0,
                  color: ColorConverter.hexToColor("#838383")
              ),
              icon: Icon(icon,color:ColorConverter.hexToColor("#1F89B8"),size: 20,),
              border: InputBorder.none,
            ),
            minLines: 1,
            maxLines: 1,
          ),
          Divider(height: 5,thickness: 1,color: ColorConverter.hexToColor("#8F8F8F"),),
        ],
      ),);
  }
  static textField_DisableMultiLines(TextEditingController controller,var icon,var label_text,bool flag){
    return Padding(padding: EdgeInsets.only(top: 3,bottom: 3),
      child: Column(
        children: [
          TextField(
            maxLines: 2,
            enabled: flag,
            controller: controller,

            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0.0),
              isDense: true,
              labelText: label_text,
              labelStyle: new TextStyle(
                  fontSize: 14.0,
                  color: ColorConverter.hexToColor("#838383")
              ),
              icon: Icon(icon,color:ColorConverter.hexToColor("#1F89B8"),size: 20,),
              border: InputBorder.none,
            ),
          ),
          Divider(height: 5,thickness: 1,color: ColorConverter.hexToColor("#8F8F8F"),),
        ],
      ),);
  }
  static textFieldSuffixIcon(TextEditingController controller,var icon,var label_text,var icon_suffix){
    return Padding(padding: EdgeInsets.only(top: 3,bottom: 3),
      child: Row(
        children: [
          Expanded(child: Container(
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    isDense: true,
                    labelText: label_text,
                    icon: Icon(icon,color:ColorConverter.hexToColor("#1F89B8"),size: 20,),
                    border: InputBorder.none,
                  ),
                  minLines: 1,
                  maxLines: 1,
                ),
                Divider(height: 5,thickness: 1,color: ColorConverter.hexToColor("#8F8F8F"),),
              ],
            ),
          ),),
          Padding(padding: EdgeInsets.all(7),
              child:Container(child:Icon(icon_suffix,color:ColorConverter.hexToColor("#1F89B8"),size: 20,),))
        ],
      ),);
  }
}