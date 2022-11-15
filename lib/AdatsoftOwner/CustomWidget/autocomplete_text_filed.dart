
import 'package:petrosoft_india/AdatsoftOwner/ArrivalEntry/add_arrival_entry.dart';
import 'package:petrosoft_india/AdatsoftOwner/Model/item_model.dart';
import 'package:petrosoft_india/AdatsoftOwner/Model/item_model.dart';
import 'package:petrosoft_india/AdatsoftOwner/Model/item_model.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../Model/item_model.dart';

class AutoCompleteTextField{


  static autocompleteTextField(String labelText, List<ItemModel>_suggestions,double width){
   return Container(
     height: 45,
     width: double.infinity,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(10.0),
      // color: Colors.grey.shade100,
       border: Border.all(color: Colors.grey.shade300),
     ),
     child:Autocomplete<ItemModel>(
       // initialValue:TextEditingValue(text: 'Select Farmer') ,
       optionsBuilder: (TextEditingValue value) {
         // When the field is empty
         if (value.text.isEmpty) {
           return [];
         }
         return _suggestions
             .where((item) => item.itemDesc!.toLowerCase()
             .startsWith(value.text.toLowerCase())
         )
             .toList();

         // The logic to find out which ones should appear
        /* return _suggestions.where((suggestion) =>
             suggestion.toLowerCase().contains(value.text.toLowerCase()));*/
       },
       displayStringForOption: (ItemModel option) => option.itemDesc!,
       fieldViewBuilder: (
           BuildContext context,
           TextEditingController fieldTextEditingController,
           FocusNode fieldFocusNode,
           VoidCallback onFieldSubmitted
           ) {
         return TextField(
           controller: fieldTextEditingController,
           focusNode: fieldFocusNode,
           decoration: InputDecoration(
             // prefixIcon: Icon(icon, color: ColorsForApp.light_gray_color,),
               counterText: "",
               iconColor: ColorsForApp.light_gray_color,
               isDense: true,
               contentPadding: EdgeInsets.all(10),

               fillColor:Colors.grey.shade400,
               //border: OutlineInputBorder(),
               labelText: labelText,
               labelStyle: TextStyle(fontSize: 14.0, color: ColorConverter.hexToColor("#838383")),
               border: InputBorder.none
           ),
           style: const TextStyle(fontWeight: FontWeight.normal),
         );
       },
       onSelected:(value){


       },
     ),

   );
  }

}

