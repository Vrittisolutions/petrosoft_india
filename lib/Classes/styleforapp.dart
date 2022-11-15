

import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';
import 'converter.dart';
import 'dimension.dart';

class StyleForApp {
 static var iconThemeData= const IconThemeData(color: Colors.white);
  //---------------Bold Text Style----------------//
  static var text_style_bold_no__light_gray = TextStyle(
      color: ColorConverter.hexToColor('#8F8F8F'),
      fontWeight: FontWeight.bold);

  static var text_style_bold_no__black = TextStyle(
      color: ColorConverter.hexToColor('#000000'),
      fontWeight: FontWeight.bold);

  static var text_style_bold_16_blue = TextStyle(
      color: ColorsForApp.app_theme_color,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.app_title);

  static var text_style_bold_16_lightgrey = TextStyle(
      color: ColorConverter.hexToColor('#8F8F8F'),
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.app_title);

  static var text_style_bold_14_black = TextStyle(
      color: ColorConverter.hexToColor('#000000'),
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.big_text_size);

  static var text_style_bold_14_green = TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.big_text_size);

  static var text_style_bold_14_operator_blue = TextStyle(
      color: ColorsForApp.appThemeColorPetroOperator,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.big_text_size);

  static var text_style_bold_14_white = TextStyle(
      color: ColorConverter.hexToColor('#FFFFFF'),
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.big_text_size);

  static var text_style_bold_14_light_gray = TextStyle(
      color: ColorConverter.hexToColor('#8F8F8F'),
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.big_text_size);

  static var text_style_bold_13_black = TextStyle(
      color: ColorConverter.hexToColor('#000000'),
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.small_text_size);

  static var text_style_bold_13_light_gray = TextStyle(
      color: ColorConverter.hexToColor('#8F8F8F'),
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.small_text_size);

  static var text_style_bold_13_white = TextStyle(
      color: ColorConverter.hexToColor('#FFFFFF'),
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.small_text_size);

  static var text_style_bold_16_white = TextStyle(
      color: ColorConverter.hexToColor('#FFFFFF'),
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.app_title);

  static var text_style_bold_16_operator_blue = TextStyle(
      color: ColorsForApp.appThemeColorPetroOperator,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.app_title);

  static var text_style_bold_16_operator_dark = TextStyle(
      color: ColorsForApp.app_theme_color_dark,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.app_title);

  static var text_style_bold_16_owner_dark = TextStyle(
      color: ColorsForApp.appThemePetroOwner,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.app_title);
  static var text_style_bold_14_owner_dark = TextStyle(
      color: ColorsForApp.appThemePetroOwner,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.big_text_size);

  static var text_style_bold_12_black = TextStyle(
      color: ColorConverter.hexToColor('#000000'),
      fontWeight: FontWeight.bold,
      fontSize: DimensionsForApp.very_small_text_size);


  static var text_style_bold_12_light_gray = TextStyle(
      color: ColorConverter.hexToColor('#8F8F8F'),
      fontWeight: FontWeight.bold,
      fontSize: DimensionsForApp.very_small_text_size);

  static var text_style_bold_13_blue = TextStyle(color: ColorsForApp.app_theme_color,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.small_text_size);
  static var text_style_bold_13_indigo = TextStyle(color: Colors.indigo,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.small_text_size);

  static var text_style_bold_14_grn = TextStyle(color: ColorsForApp.icon,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.big_text_size);

  static var text_style_bold_14_operator_blu = TextStyle(color: ColorsForApp.icon_operator,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.big_text_size);

  static var text_style_bold_14_operator_owner = TextStyle(color: ColorsForApp.icon_owner,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.big_text_size);

  static var text_style_bold_14_owner_icon= TextStyle(color: ColorsForApp.icon_owner,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.big_text_size);


  static var text_style_bold_14_darkblue = TextStyle(color: ColorsForApp.icon,
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.big_text_size);

  static var text_style_bold_18_blue = TextStyle(
      color: ColorsForApp.app_theme_color,
      fontWeight: FontWeight.bold,
      fontSize: DimensionsForApp.app_title);


  //---------------Normal Text Style----------------//
  static var text_style_normal_no__light_gray=TextStyle(color:ColorConverter.hexToColor('#8F8F8F'),
      fontWeight: FontWeight.normal);

  static var text_style_normal_no__black = TextStyle(
      color: ColorConverter.hexToColor('#000000'),
      fontWeight: FontWeight.normal);

  static var text_style_normal_12_light_gray = TextStyle(
      color: ColorConverter.hexToColor('#8F8F8F'),
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.very_small_text_size);

  static var text_style_normal_12_black = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.very_small_text_size);

  static var text_style_normal_12_green = TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.very_small_text_size);

  static var text_style_normal_12_red = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.very_small_text_size);

  static var text_style_normal_12_blue = TextStyle(
      color: ColorsForApp.app_theme_color,
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.very_small_text_size);

  static var text_style_normal_11_blue = TextStyle(
      color: ColorsForApp.app_theme_color,
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.text_11);

  static var text_style_normal_12_white = TextStyle(
      color: ColorConverter.hexToColor('#FFFFFF'),
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.very_small_text_size);


  static var text_style_normal_14_black = TextStyle(
      color: ColorConverter.hexToColor('#000000'),
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.big_text_size);

  static var text_style_normal_14_blue = TextStyle(
      color: ColorConverter.hexToColor('#38A8E7'),
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.big_text_size);

  static var text_style_bold_14_blue = TextStyle(
      color: ColorConverter.hexToColor('#38A8E7'),
      fontWeight: FontWeight.bold, fontSize: DimensionsForApp.big_text_size);

  static var text_style_normal_14_green= TextStyle(color: ColorsForApp.app_theme_color,
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.big_text_size);

  static var text_style_normal_14_light_gray = TextStyle(
      color: ColorConverter.hexToColor('#8F8F8F'),
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.big_text_size);

  static var text_style_normal_14_hint = TextStyle(
      color: ColorConverter.hexToColor('#8F8F8F'),
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.big_text_size);

  static var text_style_normal_14_white= TextStyle(color: Colors.white,
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.big_text_size);

  static var text_style_normal_14_operator= TextStyle(color: ColorsForApp.appThemeColorPetroOperator,
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.big_text_size);

  static var text_style_normal_14_owner= TextStyle(color: ColorsForApp.icon_owner,
      fontWeight: FontWeight.normal, fontSize: DimensionsForApp.big_text_size);

  static var text_style_normal_14= TextStyle(
      color: ColorConverter.hexToColor('#00487C'),
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.big_text_size);



  static var text_style_normal_13_black = TextStyle(
      color: ColorConverter.hexToColor('#000000'),
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.small_text_size);

  static var text_style_normal_13_white = TextStyle(
      color: ColorConverter.hexToColor('#FFFFFF'),
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.small_text_size);

  static var text_style_normal_13_green = TextStyle(
      color: ColorsForApp.icon,
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.small_text_size);

  static var text_style_normal_13_light_gray = TextStyle(
      color: ColorConverter.hexToColor('#696969'),
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.small_text_size);

  static var text_style_normal_16_blue = TextStyle(
      color: ColorsForApp.app_theme_color,
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.app_title);

  static var text_style_normal_16_owner = TextStyle(
      color: ColorsForApp.app_theme_color_owner,
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.app_title);

  static var text_style_normal_16_hint = TextStyle(
      color: ColorConverter.hexToColor('#8F8F8F'),
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.text_16);

  static var text_style_normal_16_black = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.text_16);

  static var text_style_bold_16_black = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: DimensionsForApp.text_16);

  static var text_style_normal_16_operator_blue = TextStyle(
      color: ColorsForApp.appThemeColorPetroOperator,
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.app_title);

  static var text_style_normal_16_white = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.app_title);

  static var text_style_normal_16_grey = TextStyle(
      color: ColorConverter.hexToColor("#5C7000"),
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.app_title);

  static var text_style_normal_18_black = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.app_title);

  static var text_style_normal_18_blue = TextStyle(
      color: ColorsForApp.app_theme_color,
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.app_title);

  static var text_style_normal_18_white = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.normal,
      fontSize: DimensionsForApp.app_title);

  static var text_style_bold_18_black = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: DimensionsForApp.app_title);

  static var text_style_bold_20_black = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: DimensionsForApp.app_icon_size);

  //----------------Divider For App-----------------//
  //static var horizontal_divider_light_gray = Divider(height: .5,thickness: .5,indent: 20,endIndent: 20,color: ColorConverter.hexToColor('#8F8F8F'),);
  static Widget horizontal_divider_light_gray = Row(children: <Widget>[
    Expanded(
      child: new Container(
          margin: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Divider(
            color: ColorConverter.hexToColor("#8F8F8F"),
            thickness: 1,
            height: 5,
          )),
    ),
  ]);


  static var horizontal_divider_light_gray_fill = Divider(height: 7,thickness: 1,color: ColorConverter.hexToColor('#8F8F8F'),);
  static var horizontal_divider_white = Divider(height: .2,thickness: .2,color: ColorConverter.hexToColor('#FFFFFF'),);


}
class PetroSoftTextStyle{

 static var style17White = TextStyle(
     color: ColorsForApp.white,
     fontWeight: FontWeight.w400,
     fontSize: 17);

 static var style15Black = TextStyle(
     color: ColorsForApp.black_color,
     fontWeight: FontWeight.w400,
     fontSize: 15);

 static var style13Black = TextStyle(
     color: ColorsForApp.black_color,
     //fontWeight: FontWeight.w400,
     fontSize: 13);

 static var style12Black = TextStyle(
     color: ColorsForApp.black_color,
     //fontWeight: FontWeight.w400,
     fontSize: 12);

 static var style15BlackBold = TextStyle(
     color: ColorsForApp.black_color,
     fontWeight: FontWeight.w700,
     fontSize: 15);

 static var style20Black = TextStyle(
     color: ColorsForApp.black_color,
     fontWeight: FontWeight.w400,
     fontSize: 20);

 static var style20AppColor = TextStyle(
     color: ColorsForApp.appThemeColor,
     fontWeight: FontWeight.w700,
     fontSize: 20);
 static var style16AppColor = TextStyle(
     color: ColorsForApp.appThemeColor,
     fontWeight: FontWeight.w700,
     fontSize: 16);
}