import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:flutter/material.dart';

class AdatTextField{

  static mobileTextField(var icon, var labelText,TextEditingController controller,TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            textInputAction: TextInputAction.done,
            autofocus: false,
            maxLength: 10,
            keyboardType: type,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey,),
              counterText: "",
              iconColor: ColorsForApp.light_gray_color,
              isDense: true,
              fillColor: Colors.black,
              //border: OutlineInputBorder(),
              labelText: labelText,
              labelStyle: const TextStyle(
                  fontSize: 16.0, color: Colors.grey),

              //border: InputBorder.none,

            ),
            minLines: 1,
            maxLines: 1,
          ),

        ],
      ),
    );
  }

  static mobileTextFieldDisable(var icon, var labelText,TextEditingController controller,TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.grey.shade200,
              // border: Border.all()
            ),
            child: TextFormField(
              controller: controller,
              textInputAction: TextInputAction.done,
              autofocus: false,
              maxLength: 10,
              keyboardType: type,
              readOnly: true,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: Colors.grey,),
                counterText: "",
                iconColor: ColorsForApp.light_gray_color,
                isDense: true,
                fillColor: Colors.black,
                //border: OutlineInputBorder(),
                labelText: labelText,
                labelStyle: const TextStyle(
                    fontSize: 16.0, color: Colors.grey),

                border: InputBorder.none,

              ),
              minLines: 1,
              maxLines: 1,
            ),
          ),

        ],
      ),
    );
  }

  static numberTextField(var icon, var labelText,TextEditingController controller,TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.grey.shade300,
              // border: Border.all()
            ),
            child: TextFormField(
              controller: controller,
              textInputAction: TextInputAction.done,
              autofocus: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: ColorsForApp.light_gray_color,),
                counterText: "",
                iconColor: ColorsForApp.light_gray_color,
                isDense: true,
                fillColor: Colors.black,
                //border: OutlineInputBorder(),
                labelText: labelText,
                labelStyle: TextStyle(
                    fontSize: 14.0, color: ColorConverter.hexToColor("#838383")),

                border: InputBorder.none,

              ),
              minLines: 1,
              maxLines: 1,
            ),
          ),

        ],
      ),
    );
  }

  //text filed for inputType text
  static normalTextField(var icon, var labelText,TextEditingController controller,TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 3, right: 30, left: 30),
      child: Column(
        children: [
          Container(
            // width: MediaQuery.of(context).size.width,
            //padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.grey.shade200,
               border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextFormField(
              controller: controller,
              textInputAction: TextInputAction.done,
              autofocus: false,
              // maxLength: 10,
              keyboardType: type,
              decoration: InputDecoration(
                  prefixIcon: Icon(icon, color: ColorsForApp.light_gray_color,),
                  counterText: "",
                  iconColor: ColorsForApp.light_gray_color,
                  isDense: true,

                  fillColor:Colors.grey.shade300,
                  //border: OutlineInputBorder(),
                  labelText: labelText,
                  labelStyle: TextStyle(fontSize: 14.0, color: ColorConverter.hexToColor("#838383")),
                  border: InputBorder.none




              ),
              minLines: 1,
              maxLines: 1,
            ),
          ),

        ],
      ),
    );
  }

  static textFieldWithBorder(var icon, var labelText,TextEditingController controller,
      TextInputType type,bool readOnly,double width) {
   return  Container(
     height: 40,width: width,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(10.0),
       //color: Colors.grey.shade100,
       border: Border.all(color: Colors.grey.shade400),
     ),
     child: TextFormField(
       controller: controller,
       textInputAction: TextInputAction.done,
       autofocus: false,
       readOnly: readOnly,
       // maxLength: 10,
       keyboardType: TextInputType.text,

       decoration: InputDecoration(
         // prefixIcon: Icon(icon, color: ColorsForApp.light_gray_color,),
           counterText: "",
           iconColor: ColorsForApp.light_gray_color,
           isDense: true,
           contentPadding: EdgeInsets.all(8),

           //fillColor:Colors.grey.shade300,
           //border: OutlineInputBorder(),
           labelText: labelText,
           labelStyle: TextStyle(fontSize: 13.0, color: ColorConverter.hexToColor("#838383")),
           border: InputBorder.none
       ),
       minLines: 1,
       maxLines: 1,
     ),
   );
  }

}