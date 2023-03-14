
import 'dart:convert';

import 'package:petrosoft_india/AdatsoftOwner/AppTheame/textFileds.dart';
import 'package:petrosoft_india/AdatsoftOwner/Model/item_model.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../common/Classes/utility.dart';
import '../../common/widgets/custom_dialog.dart';
import '../CustomWidget/autocomplete_text_filed.dart';
import '../Model/customer_model.dart';
var supp;
var oldinwno;
var inw_no;
var inwh;
var inwb;
var inwd;
var item;
var isOldLot = false;
var suppAcno = '';
class ArrivalEntry extends StatefulWidget {
  const ArrivalEntry({Key? key}) : super(key: key);

  @override
  _ArrivalEntryState createState() => _ArrivalEntryState();
}

class _ArrivalEntryState extends State<ArrivalEntry> {
  TextEditingController inwNo=TextEditingController();
  String currentDate = UT.displayDateConverter(DateTime.now());
  List<TextEditingController> textEditingControllers = [];
  TextEditingController markController = TextEditingController();
  TextEditingController subMarkController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController gpNoController = TextEditingController();
  TextEditingController lorryNoController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bagsController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  final List<ArrivalModel> _entriesList=[];
  GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormFieldState> inwarNoFormFieldKey = GlobalKey<FormFieldState>();
  // This will be displayed below the autocomplete field
  String _selectedCustomer='';


   List<ItemModel> itemList=[];
   List<CustomerModel> customerList=[];


   double tot=0.0;
   double pati_adv=0.0;
   double patti_fr=0.0;
   String itemCode='';
   double totQty=0.0;
   bool showLoader=false;
   dynamic api;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api=apiCall();
  }
  apiCall() async {
    getItemList();
    getCustomerList();
      await getMaxInwNo().then((value) {
      return value;
    });
    return true;

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleSpacing: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             const Text("Arrival Entry",style: TextStyle(fontSize: 15,color: Colors.black),),
             Text(currentDate,style: StyleForApp.text_style_normal_14_black),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle,color: ColorsForApp.appThemeColorAdatOwner,),
            onPressed: (){
              if (_formKey.currentState!.validate()) {
                DialogBuilder(context).showLoadingIndicator('');
                SaveInw();

              }
            },
          )
        ],

      ),
      body: FutureBuilder(
        future: api,
       builder: (context,snapshot){
         if(snapshot.hasData){
           return SizedBox(
             height: MediaQuery.of(context).size.height,
             width: MediaQuery.of(context).size.width,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: SingleChildScrollView(
                 child: Form(
                   key: _formKey,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       inwardNoAndGPNo(),
                       const SizedBox(height: 5,),
                       farmerSelection(),
                       const SizedBox(height: 5,),
                       Container(
                         color: Colors.blue,
                         child: Padding(
                           padding: const EdgeInsets.all(5.0),
                           child: Row(
                             children:  [
                               Expanded(
                                 child: SizedBox(
                                   width: 80,
                                   child:  Text("Mark",style: StyleForApp.text_style_normal_13_white,),
                                 ),
                               ),
                               Expanded(
                                 child: SizedBox(
                                   width: 50,
                                   child: Text("Sub-Mark",style: StyleForApp.text_style_normal_13_white),
                                 ),
                               ),
                               Expanded(
                                 child: SizedBox(
                                   width: 80,
                                   child: Text("Item",style: StyleForApp.text_style_normal_13_white),
                                 ),
                               ),
                               Expanded(
                                 child: SizedBox(
                                   width: 50,
                                   child: Text("Weight",style: StyleForApp.text_style_normal_13_white),
                                 ),
                               ),
                               Expanded(
                                 child: SizedBox(
                                   width: 35,
                                   child: Text("Bags",style: StyleForApp.text_style_normal_13_white),
                                 ),
                               ),
                               Expanded(
                                 child: Container(
                                   //width: 20,
                                   child: Text("Action",style: StyleForApp.text_style_normal_13_white),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                       listView(),
                       const SizedBox(height: 10,),

                     ],
                   ),
                 ),
               ),
             ),
           );
         }else{
           return Center(child: CircularProgressIndicator(),);
         }

       },
      ),
      bottomNavigationBar:  bottomUI(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, //specify the location of the FAB
      floatingActionButton: FloatingActionButton(
         mini: true,
        backgroundColor: Colors.indigo,
        onPressed: () {
          addEntryDialog(context);
        },
        tooltip: "Centre FAB",
        child: const Center(child:  Icon(Icons.add)),
        elevation: 4.0,
      ),
    //  bottomNavigationBar:
    );

  }

  Widget inwardNoAndGPNo(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //AdatTextField.textFieldWithBorder(null, "Inw No", inwNo, TextInputType.text, true, 100),
        Focus(
          onFocusChange: (hasFocus){
            print('2:  $hasFocus');
            if(hasFocus==false){
              if(inwNo.text.isNotEmpty) {
                //  checkCouponNo(maxNo.toString().padLeft(6,"0"));
                showLoader=true;
                DialogBuilder(context).showLoadingIndicator('');
                Inwno(inwNo.text.toString().padLeft(6,"0"));

              }
            }
          },
          child: Container(
            height: 40,width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              //color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: TextFormField(
              controller: inwNo,
              textInputAction: TextInputAction.done,
              autofocus: false,
              // maxLength: 10,
              keyboardType: TextInputType.number,
              validator: (input) {
                if(input==" "||input!.isEmpty){
                  return "Field  is required";
                }
                return null;
              },
              onFieldSubmitted: (term) {
                DialogBuilder(context).showLoadingIndicator('');
                showLoader=true;
                Inwno(inwNo.text);
              },
              onChanged: (term) {
               // inwarNoFormFieldKey.currentState!.validate();
               // Inwno(inwNo.text);
              },
              decoration: InputDecoration(
                // prefixIcon: Icon(icon, color: ColorsForApp.light_gray_color,),
                  counterText: "",
                  iconColor: ColorsForApp.light_gray_color,
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),

                  //fillColor:Colors.grey.shade300,
                  //border: OutlineInputBorder(),
                  labelText: "Inw No",
                  labelStyle: TextStyle(fontSize: 13.0, color: ColorConverter.hexToColor("#838383")),
                  border: InputBorder.none
              ),
              minLines: 1,
              maxLines: 1,
            ),
          ),
        ),
        SizedBox(width: 5,),
        Expanded(
          child:AdatTextField.textFieldWithBorder(null, "G.P No", gpNoController, TextInputType.text, false, 0),
        ),
        SizedBox(width: 5,),
        Expanded(
          child: AdatTextField.textFieldWithBorder(null, "Lorry No", lorryNoController, TextInputType.text, false, double.infinity),
        ),

      ],
    );
  }
  Widget farmerSelection(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
             // color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade400),
            ),
            child:Autocomplete<CustomerModel>(
              initialValue:TextEditingValue(text: _selectedCustomer) ,
              optionsBuilder: (TextEditingValue value) {
                // When the field is empty
                if (value.text.isEmpty) {
                  return [];
                }

                // The logic to find out which ones should appear
                return customerList
                    .where((item) => item.name!.toLowerCase()
                    .startsWith(value.text.toLowerCase())
                )
                    .toList();
              },
                fieldViewBuilder: (
                    BuildContext context,
                    TextEditingController controller,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted
                    ) {
                  return TextField(
                    controller: controller,
                    focusNode: fieldFocusNode,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(icon, color: ColorsForApp.light_gray_color,),
                        counterText: "",
                        iconColor: ColorsForApp.light_gray_color,
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),

                        fillColor:Colors.grey.shade300,
                        //border: OutlineInputBorder(),
                        labelText: _selectedCustomer!=null||_selectedCustomer!=""?_selectedCustomer:"Select Customer",
                        labelStyle: TextStyle(fontSize: 13.0, color: ColorConverter.hexToColor("#838383")),
                        border: InputBorder.none
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              displayStringForOption: (CustomerModel option) => option.name!,
              onSelected: (value) {
                setState(() {
                  _selectedCustomer = value.name!;
                   suppAcno=value.acno!;
                });
              },
            ),

         ),
        ),
      //  Expanded(child:  AutoCompleteTextField.autocompleteTextField("Select Farmer", _suggestions, double.infinity ,ArrivalModel ),),

        const SizedBox(width: 5,),
        IconButton(
          icon: Icon(Icons.add_circle,color: ColorsForApp.appThemeColorAdatOwner,),
          onPressed: (){},
        )

      ],
    );
  }

  Widget listView(){
  //  calcTotQty();

      return inwd.length!=0? ListView.builder(
          itemCount: inwd.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context,index){

            if(inwd!=null){
              if(inwd[index]['inw_no']!=""){
                if(inwd[index]['inw_srno']!=""){
                  return InkWell(
                    onTap: (){
                      editLotEntryDialog(context,inwd[index],index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        // height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.indigo.shade50,
                          border: Border.all(color: Colors.indigo.shade300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SizedBox(
                                    width: 80,
                                    child: Text(inwd[index]['brand'].toString(),maxLines: 2,style: StyleForApp.text_style_normal_12_black)
                                ),
                              ),

                              Expanded(
                                child: SizedBox(
                                    width: 50,
                                    child: Text(inwd[index]['pcsperbox'].toString(),maxLines: 2,style: StyleForApp.text_style_normal_12_black,)
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                    width: 80,
                                    child: Text(inwd[index]['inw_item'].toString(),maxLines: 2,style: StyleForApp.text_style_normal_12_black,)
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                    width: 50,
                                    child: Text(double.parse(inwd[index]['recd_wt'].toString()).round().toString(),maxLines: 2,style: StyleForApp.text_style_normal_12_black,)
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                    width: 35,
                                    child: Text(double.parse(inwd[index]['recd_pack'].toString()).round().toString(),maxLines: 2,style: StyleForApp.text_style_normal_12_black)
                                ),
                              ),

                              Expanded(
                                child: IconButton(
                                  onPressed: (){
                                    print("_deleteDialog");
                                    _deleteDialog(context,index);

                                  },
                                  icon: const Icon(Icons.delete,color: Colors.red,size: 17,),
                                ),
                              ) ,

                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }else{
                  return Container();
                }

              }else{
                return Container();
              }

            }else{
              return const Center(child: CircularProgressIndicator());
            }

          }):Container();


  }

  editLotEntryDialog(BuildContext context, var editRow,int index){
    markController.text=editRow['brand'];
    subMarkController.text=editRow['pcsperbox'];
    itemController.text=editRow['inw_item'];
    weightController.text=editRow['recd_wt'].toString();
    bagsController.text=editRow['recd_pack'].toString();
    itemCode=editRow['item_code'];
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: SimpleDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(16.0))),
              title:  Text('Update Lot Details', style: StyleForApp.text_style_bold_14_black,),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: markController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Mark",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: subMarkController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Sub mark",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        // color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade500),
                      ),
                      child:Autocomplete<ItemModel>(
                        // initialValue:TextEditingValue(text: 'Select Farmer') ,
                        optionsBuilder: (TextEditingValue value) {
                          // When the field is empty
                          if (value.text.isEmpty) {
                            return [];
                          }
                          return itemList
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
                            controller: itemController,
                            focusNode: fieldFocusNode,
                            decoration: InputDecoration(
                              // prefixIcon: Icon(icon, color: ColorsForApp.light_gray_color,),
                                counterText: "",
                                iconColor: ColorsForApp.light_gray_color,
                                isDense: true,
                                contentPadding: EdgeInsets.all(10),

                                fillColor:Colors.grey.shade400,
                                //border: OutlineInputBorder(),
                                labelText: 'Select Item',
                                labelStyle: const TextStyle(fontSize: 14.0, /*color: ColorConverter.hexToColor("#838383")*/),
                                border: InputBorder.none
                            ),
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          );
                        },
                        onSelected:(value){
                         // setState(() {
                            itemController.text=value.itemDesc.toString();
                            itemCode=value.itemCode.toString();
                            print("selected item-->${itemController}");
                            print("selected item-->${itemCode}");
                         // });



                        },
                      ),

                    )

                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: bagsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Bags",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Weight",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsForApp.app_theme_color_light_drawer,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            textStyle: StyleForApp.text_style_normal_14_black),
                        child: const Text('Cancel',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        onPressed: () {
                          markController.clear();
                          subMarkController.clear();
                          itemController.clear();
                          weightController.clear();
                          bagsController.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 10,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            textStyle: const TextStyle(
                                color:Colors.white ,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        child:   Text('Update',
                            style: StyleForApp.text_style_normal_14_white),
                        onPressed: () {

                          if(bagsController.text.isEmpty){
                            Fluttertoast.showToast(msg: 'Please enter bags');
                          }else if(weightController.text.isEmpty){
                            Fluttertoast.showToast(msg: 'Please enter weight');
                          }else{
                            setState(() {
                              inwd[0]["inw_item"] = editRow['inw_item'];
                              inwd[0]["inw_no"] = editRow['inw_no'];

                              inwd[0]["inw_srno"] = editRow["inw_srno"].trim();
                              inwd[0]["lotrecddt"] = UT.dateConverter(DateTime.now());
                              inwd[0]["item_code"] = itemCode;
                              inwd[0]["recd_pack"] = bagsController.text;
                              inwd[0]["brand"] = markController.text;
                              inwd[0]["pcsperbox"] = subMarkController.text;
                              inwd[0]["sold_pack"] = 0;
                              inwd[0]["bal_pack"] = 0;
                              inwd[0]["saleable"] = 0;
                              inwd[0]["refund_pac"] = 0;
                              inwd[0]["damage_pac"] = 0;
                              inwd[0]["grade_pack"] = 0;
                              inwd[0]["isdeleted"] = 'N';
                              inwd[0]["recd_wt"] = weightController.text;

                               Navigator.pop(context);
                            });
                          }


                            },
                      ),
                    ],
                  ),
                )
              ]
            ),
          );
        });
  }

  addEntryDialog(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: SimpleDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(16.0))),
                title:  Text('Enter Details', style: StyleForApp.text_style_bold_14_black,),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: markController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            labelText: "Mark",
                            labelStyle: StyleForApp.text_style_normal_14_black
                          //contentPadding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: subMarkController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            labelText: "Sub mark",
                            labelStyle: StyleForApp.text_style_normal_14_black
                          //contentPadding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: SizedBox(
                        height: 45,
                        child: Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            // color: Colors.grey.shade100,
                            border: Border.all(color: Colors.grey.shade500),
                          ),
                          child:Autocomplete<ItemModel>(
                            // initialValue:TextEditingValue(text: 'Select Farmer') ,
                            optionsBuilder: (TextEditingValue value) {
                              // When the field is empty
                              if (value.text.isEmpty) {
                                return [];
                              }
                              return itemList
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
                                    labelText: 'Select Item',
                                    labelStyle: const TextStyle(fontSize: 14.0, /*color: ColorConverter.hexToColor("#838383")*/),
                                    border: InputBorder.none
                                ),
                                style: const TextStyle(fontWeight: FontWeight.normal),
                              );
                            },
                            onSelected:(value){
                              // setState(() {
                              itemController.text=value.itemDesc.toString();
                              itemCode=value.itemCode.toString();
                              // });



                            },
                          ),

                        )

                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: bagsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            labelText: "Bags",
                            labelStyle: StyleForApp.text_style_normal_14_black
                          //contentPadding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                            labelText: "Weight",
                            labelStyle: StyleForApp.text_style_normal_14_black
                          //contentPadding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsForApp.app_theme_color_light_drawer,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              textStyle: StyleForApp.text_style_normal_14_black),
                          child: const Text('Cancel',
                              style: TextStyle(
                                color: Colors.black,
                              )),
                          onPressed: () {
                            markController.clear();
                            subMarkController.clear();
                            itemController.clear();
                            weightController.clear();
                            bagsController.clear();
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 10,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              textStyle: const TextStyle(
                                  color:Colors.white ,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          child:   Text('Add',
                              style: StyleForApp.text_style_normal_14_white),
                          onPressed: () {

                            if(bagsController.text.isEmpty){
                              Fluttertoast.showToast(msg: 'Please enter bags');
                            }else if(weightController.text.isEmpty){
                              Fluttertoast.showToast(msg: 'Please enter weight');
                            }else{
                              setState(() {
                                var newrow={};
                                //  itemCode=inwd[inwd.length - 1]["item_code"].toString();
                                // var newrow = inwd[inwd.length - 1];
                                if (inwd.length == 1 && inwd[0]["inw_item"].trim() == "") {
                                  newrow["inw_item"] = "001";
                                }
                                else {
                                  var inwitem = double.parse(inwd[inwd.length - 1]["inw_item"]) + 1;
                                  newrow["inw_item"] = inwitem.toString().padLeft(3, "0");
                                }
                                print("itemCode-->${itemCode}");
                                newrow["inw_no"] = inwNo.text;
                                newrow["inw_srno"] = inwb[0]["inw_srno"].trim();
                                newrow["lotrecddt"] = UT.dateConverter(DateTime.now());
                                newrow["item_code"] = itemCode;
                                newrow["recd_pack"] = bagsController.text;
                                newrow["brand"] = markController.text;
                                newrow["pcsperbox"] = subMarkController.text;
                                newrow["sold_pack"] = 0;
                                newrow["bal_pack"] = 0;
                                newrow["saleable"] = 0;
                                newrow["refund_pac"] = 0;
                                newrow["damage_pac"] = 0;
                                newrow["grade_pack"] = 0;
                                newrow["isdeleted"] = 'N';
                                newrow["recd_wt"] = weightController.text;
                                print("newrow-->${newrow}");
                                inwd.add(newrow);

                                weightController.clear();
                                bagsController.clear();
                                calcTotQty();
                              });
                            }
                            },
                        ),
                      ],
                    ),
                  )
                ]
            ),
          );
        });
  }

  Widget bottomUI(){
    return SizedBox(
      height: 105,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                        child: const Text("Advance ")),
                    Container(
                      height: 35,width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(pati_adv.toStringAsFixed(2)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    SizedBox(
                        width: 60,
                        child: Text("Freight")),
                    Container(
                      height: 35,width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(patti_fr.toStringAsFixed(2)),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(width: 5,),
            Column(
              children: [
                Row(
                  children: [
                    Text("Bags"),
                    SizedBox(width: 3,),
                    Container(
                      height: 35,width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(totQty.toStringAsFixed(2)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text("Total"),
                    SizedBox(width: 3,),
                    Container(
                      height: 35,width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(tot.toStringAsFixed(2)),
                      ),
                    ),
                  ],
                )
              ],
            )

          ],
        ),
      ),
    );
  }

  Future _deleteDialog(context, int index) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context)
    {
      return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.deepOrange,
            ),
          ),
          insetPadding: EdgeInsets.all(8),
          elevation: 10,
          titlePadding: const EdgeInsets.all(0.0),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                  child: GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      alignment: FractionalOffset.topRight,
                      child: GestureDetector(
                        child: Icon(Icons.clear, color: Colors.red,),

                        onTap: () {
                          Navigator.pop(context);
                        },),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, 10, 20, 0),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color:Colors.red,size: 48,),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Are you sure you want to delete?",
                        style: TextStyle(
                            color: Colors.black,
                          fontSize: 15,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                   /*   Text(
                        "Your Subscription Plan Expiered",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.center,
                      ),*/
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          contentPadding: EdgeInsets.all(8),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary:ColorsForApp.light_gray_color,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    textStyle: const TextStyle(
                        color:Colors.white ,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                child:   Text('No',
                    style: StyleForApp.text_style_normal_14_white),
                onPressed: () {
                  Navigator.pop(context);
                  },
              ),ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary:ColorsForApp.appThemeColorPetroCustomer,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    textStyle: const TextStyle(
                        color:Colors.white ,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                child:   Text('Yes',
                    style: StyleForApp.text_style_normal_14_white),
                onPressed: () {
                  setState(() {
                    inwd[0]["inw_item"] = inwd[index]['inw_item'];
                    inwd[0]["inw_no"] = inwd[index]['inw_no'];

                    inwd[0]["inw_srno"] = inwd[index]["inw_srno"].trim();
                    inwd[0]["lotrecddt"] = UT.dateConverter(DateTime.now());
                    inwd[0]["item_code"] = inwd[index]["item_code"];
                    inwd[0]["recd_pack"] = inwd[index]["recd_pack"];
                    inwd[0]["brand"] = inwd[index]["brand"];
                    inwd[0]["pcsperbox"] = inwd[index]["pcsperbox"];
                    inwd[0]["sold_pack"] = 0;
                    inwd[0]["bal_pack"] = 0;
                    inwd[0]["saleable"] = 0;
                    inwd[0]["refund_pac"] = 0;
                    inwd[0]["damage_pac"] = 0;
                    inwd[0]["grade_pack"] = 0;
                    inwd[0]["isdeleted"] = 'Y';
                    inwd[0]["recd_wt"] = inwd[index]["recd_wt"];
                    inwd.remove(inwd[index]);
                    Navigator.pop(context);
                  });

                  },
              ),

            ],
          )

      );
    });
  }


  //TODO :method for get Max Inw no
  Future  getMaxInwNo()async{
    var _url = UT.APIURL! +
        "api/InwEntShort/GetMaxSrno?curyear=" +
        UT.curyear! +
        "&shop="+UT.shop_no.toString();
    var data = await UT.apiStr(_url);
    inwNo.text=data.toString().padLeft(6,'0');
    oldinwno = inwNo.text;
    Future.delayed(Duration(seconds: 1)).then((value) {
      return  Inwno(inwNo.text).then((value){
        return value;
      });
    });

  }
  getCustomerList()async{
   // var urlstr = APIURL + "/api/AccountMaster/GetSuppByName?syear=" + Setup('curyear') + "&shop=" + Firm("Shop") + "&like=" + request.term + "&addrow=false&cols=name%2B' '%2Bcity as name ,acno,city";
    var _url = UT.APIURL! +
        "api/AccountMaster/GetSuppByName?syear=" +
        UT.curyear! +
        "&shop="+UT.shop_no.toString()+
        "&like=" + customerController.text +
        "&addrow=false&cols=name%2B' '%2Bcity as name ,acno,city";
    var data = await UT.apiStr(_url);
    List  decode=json.decode(data);
    customerList = decode.map((val) =>  CustomerModel.fromJson(val)).toList();
  }

  //TODO :method for get ItemList
  getItemList()async{
    var _url = UT.APIURL! +
        "api/ItemMaster/GetProdct?shopno=" +
        UT.shop_no.toString() +
        "&where=isdeleted <>'Y'&addrow=false";
    var data = await UT.apiStr(_url);
    List  decode=json.decode(data);
    itemList = decode.map((val) =>  ItemModel.fromJson(val)).toList();
  }

   Future Inwno(inwNo) async {


    var _urlInwh = UT.APIURL! +
        "api/InwEntShort/GetInwH?cur_year=" +
        UT.curyear.toString() +
        "&shop="+UT.shop_no.toString()+"&Where=isdeleted <>'Y' and inw_no='" + inwNo + "'";
     var inwhData = await UT.apiStr(_urlInwh);
    print("inwh-->$inwh");

    inwh=json.decode(inwhData);

    var _urlInwb = UT.APIURL! +
        "api/InwEntShort/GetInwB?year=" +
        UT.curyear.toString() +
        "&shopno="+UT.shop_no.toString()+"&Where=isdeleted <>'Y' and inw_no='" + inwNo + "'";
    var inwbData = await UT.apiStr(_urlInwb);
    inwb=json.decode(inwbData);

    print("inwb-->$inwb");
    var _urlInwd = UT.APIURL! +
        "api/InwEntShort/GetInwD?_year=" +
        UT.curyear.toString() +
        "&shop="+UT.shop_no.toString()+"&Where=isdeleted <>'Y' and inw_no='" + inwNo + "'";
    var inwdData = await UT.apiStr(_urlInwd);

    inwd=json.decode(inwdData);
   // print("inwd-->$inwd");

    calcTotQty();
    if (inwh[0]['inw_no'].trim() == "") {
     // oldent = false;

      inwh[0]['inw_no'] = inwNo;
      inwb[0]["inw_no"] = inwNo;
      inwb[0]["inw_srno"] = "001";
    }
    else {
      //oldent = true;

      /*if (ChkDtLoc(inwh.inw_date)) {
        inw_no = oldinw_no;
        MSGSuccess("Date is Locked.");
        return false;
      }*/
    }
    refresh();
  }

  refresh(){
    inwNo.text=inwh[0]['inw_no'];
    lorryNoController.text=inwh[0]['veh_no'];
    gpNoController.text=inwh[0]['memo_no'];

    customerController.text=inwb[0]['agent_name'];
    _selectedCustomer=inwb[0]['agent_name'];
    print("_selectedCustomer-->$_selectedCustomer");


    pati_adv=inwh[0]['pati_adv'];
    patti_fr=inwh[0]['patti_fr'];

    var total = UT.Flt(inwh[0]['pati_adv']) + UT.Flt(inwh[0]['patti_fr']);
    tot=total;
    suppAcno = inwh[0]['agent_code'].trim();

    if(showLoader==true){
      DialogBuilder(context).hideOpenDialog();
    }
    return true;

  }

   calcTotQty() {
    if(inwd!=null){
      double totqty = 0;
     // print("for loop inwd List-->${inwd}");
      for(int i=0;i<inwd.length;i++){
        if (inwd[i]['item_code'].trim() != "" && inwd[i]['isdeleted'] != 'Y') {
          totqty += UT.Flt(inwd[i]['recd_pack']);
          print("totQty-->$totqty");
        }
      }
      setState(() {
        totQty=double.parse(totqty.toString());
        print("totQty-->$totQty");
      });
    }

     
  }


   SaveInw() async {

    if (suppAcno == '') {
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Supplier not selected.");
      return;
    }
    if (totQty == 0) {
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Not allowed to save Blank entry.");
      return;
    }else{
      inwh[0]['inw_date'] = UT.dateConverter(DateTime.now());
      inwh[0]['agent_code'] = suppAcno;
      inwh[0]['veh_no'] =lorryNoController.text;
      inwh[0]['memo_no'] = gpNoController.text;
      inwh[0]['inw_qty'] =totQty;
      inwh[0]['tran_code'] = suppAcno;
      inwh[0]['pati_adv'] = pati_adv;
      inwh[0]['patti_fr']= patti_fr;
      inwh[0]['fr_type'] = "Bags";
      inwh[0]['inw_mode'] = "New";
      inwh[0]['isdeleted'] = "N";

      inwb[0]["inw_date"] =  UT.dateConverter(DateTime.now());
      inwb[0]["agent_code"] = suppAcno;
      inwb[0]["agent_name"] = _selectedCustomer;
      inwb[0]["supp_name"] = inwb[0]["agent_name"];
      inwb[0]["supp_code"] = suppAcno;
      inwb[0]["recd_qty"] =totQty;
      inwb[0]["new_qty"] = totQty;
      inwb[0]["ibal_qty"] = UT.Flt(inwb[0]["new_qty"]) - UT.Flt(inwb[0]["pati_qty"]) -UT.Flt(inwb[0]["refund_qty"]);
      inwb[0]["isdeleted"] = 'N';

      var url = UT.APIURL! +
          "api/ChkNewSrno?Table=inwh" +
          UT.curyear.toString() +UT.shop_no.toString()+
          "&Col=inw_no&length=6";
      print("url-->$url");
      var newInwNo = await UT.apiStr(url);
      print("newInwNo-->$newInwNo");
      inwh[0]['inw_no'] = newInwNo;
      inwb = UT.RepAllCol(inwb, 'inw_no', newInwNo);
      inwd = UT.RepAllCol(inwd, 'inw_no', newInwNo);

       await SaveDT().then((value){
        if (value==true) {
          DialogBuilder(context).hideOpenDialog();
          Fluttertoast.showToast(msg: "Data saved successfully!");
        }
        else {
          DialogBuilder(context).hideOpenDialog();
          Fluttertoast.showToast(msg: "Problem while data saving!");
        }
      });



    }

  }

   Future<bool> SaveDT() async {
    var data = [];
    data.add(inwh);

    var url = UT.APIURL! +
        "api/LedgPost?year=" +
        UT.curyear.toString()+
        "&EntryType=INWARDENTRY&Shop="+UT.shop_no!+"&Condition=inw_no=" + inwh[0]['inw_no'] + "&isdelete=true";
    print("url-->$url");
    var getData = await UT.apiStr(url);

    var _url = UT.APIURL! +
        "api/LedgPost?year=" +
        UT.curyear.toString()+
        "&EntryType=INWARDENTRY&Shop="+UT.shop_no!+"&Condition=inw_no=" + inwh[0]['inw_no'] + "";
    print("url-->$url");
    var getData2 = await UT.apiStr(_url);


    var _url1 = UT.APIURL! +
        "api/PostData/Post?tblname=inwh" +
        UT.curyear! +
        UT.shop_no!;
    _url1 += "&Unique=inw_no";
    var res = await UT.save2Db(_url1, inwh);

    var _url2 = UT.APIURL! +
        "api/PostData/Post?tblname=inwb" +
        UT.curyear! +
        UT.shop_no!;
    _url2 += "&Unique=inw_no,inw_srno";
    var res1 = await UT.save2Db(_url2, inwb);

    var _url3 = UT.APIURL! +
        "api/PostData/Post?tblname=inwd" +
        UT.curyear! +
        UT.shop_no!;
    _url3 += "&Unique=inw_no,inw_srno,inw_item";
    var res2 = await UT.save2Db(_url3, inwd);

    print("Response-->${res}");
    print("Response1-->${res1}");
    print("Response2-->${res2}");


    if (res == "ok" && res1 == "ok" && res2 == "ok") {
      _selectedCustomer='';
      getMaxInwNo();
      return true;
    }
    else {
      return false;
    }
  }

}



class ArrivalModel{
  final String mark;
  final String subMark;
  final String item;
  final String weight;
  final String bags;

  ArrivalModel(this.mark, this.subMark, this.item, this.weight, this.bags);

}