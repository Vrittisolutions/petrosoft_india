import 'package:flutter/material.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';


class PetroSoftTextField {

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
  static textFieldPrefixIcon(TextEditingController controller,var label_text,var icon_suffix){
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 7,bottom: 7,right: 7),
            child:Container(
              child: Image.asset(
                icon_suffix,
                height: 20,width: 20,),)),
        Expanded(
          child: Container(
           // color: Colors.red,
           child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: label_text,
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 1,
              ),
              Divider(height: 1,thickness: 1,color: ColorConverter.hexToColor("#8F8F8F"),),
            ],
          ),
        ),),
      ],
    );
  } static mobileTextFieldPrefixIcon(TextEditingController controller,var label_text,var icon_suffix){
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 7,bottom: 7,right: 7),
            child:Container(
              child: Image.asset(
                icon_suffix,
                height: 20,width: 20,),)),
        Expanded(
          child: Container(
           // color: Colors.red,
           child: Column(
            children: [
              TextField(
                controller: controller,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: label_text,
                  border: InputBorder.none,
                  counterText: ''
                ),
                minLines: 1,
                maxLines: 1,
              ),
              Divider(height: 1,thickness: 1,color: ColorConverter.hexToColor("#8F8F8F"),),
            ],
          ),
        ),),
      ],
    );
  }
  static textFieldSufixIcon(TextEditingController controller,var label_text,var icon_suffix, var icon){
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.all(7),
            child:Container(
              child: Image.asset(
                icon_suffix,
                height: 20,width: 20,),)),
        Expanded(
          child: Container(
           child: Column(
            children: [
              TextField(
                obscureText: true,
                controller: controller,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: label_text,
                  suffixIcon: IconButton(
                    onPressed: (){},
                    icon: Icon(
                     icon,
                     size: 20,
                    ),
                  ),
                  border: InputBorder.none,
                ),
                minLines: 1,
                maxLines: 1,
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: ColorConverter.hexToColor("#8F8F8F"),
              ),
            ],
          ),
        ),),
      ],
    );
  }
}