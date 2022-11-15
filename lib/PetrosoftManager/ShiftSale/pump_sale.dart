import 'dart:convert';

import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/PetrosoftManager/petrosoft_manager_app_theme.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'generate_shift.dart';
class MangerPumpSalePage extends StatefulWidget {
  const MangerPumpSalePage({Key? key}) : super(key: key);

  @override
  _MangerPumpSalePageState createState() => _MangerPumpSalePageState();
}

class _MangerPumpSalePageState extends State<MangerPumpSalePage> {
  TextEditingController newEndMeter =  TextEditingController();
  TextEditingController startMeter =  TextEditingController();
  TextEditingController testingMeter =  TextEditingController();
  TextEditingController rate =  TextEditingController();
  TextEditingController amount =  TextEditingController();
  String selectedIncharge='';
  String acno='';
  dynamic pumpData;
  dynamic api;

  List cashierList=[];

  getData() async {
    shiftInChargeData();
    var _url = UT.APIURL! +
        "api/PumpTrnE/GetPumpBD?cur_year=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&Where=pump_no!=''%20and%20isdeleted%20%3C%3E%27Y%27%20and%20srno=%27" + UT.m["slipNoOld"] + "%27&Addrow=true";
        //"&Where=isdeleted%20%3C%3E%27Y%27%20andsrno=%27" + UT.m["slipNoOld"] + "%27&Addrow=true";
    print("PS-url-->$_url");
    pumpData = await UT.apiDt(_url);
    print("pumpData-->${pumpData.length}");
    print("pumpData-->$pumpData");
    return pumpData;
  }
  List<InchargeModel> inchargeList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   api=getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title:  Text('Pump Sale',style: PetroSoftTextStyle.style17White,),titleSpacing: 0.0,
            backgroundColor: ColorsForApp.appThemeColor),
          body: Center(
            child: Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0,bottom: 15.0),
                child: FutureBuilder(
                  future: api,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      if(pumpData[0]["pump_no"]!=""){

                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: ScrollController(),
                            itemCount: pumpData.length,
                            itemBuilder: (BuildContext context, int index) {
                             // print("PumpNo-->${pumpData[index]["pump_no"]}");
                              if(pumpData[index]["pump_no"]==''){
                                print("PumpNo 11-->${pumpData[index]["pump_no"]}");
                              }
                              if(pumpData[index]["pump_no"]!=" "||cashierList.isNotEmpty){

                                var cahsierName='';
                                if(cashierList.isNotEmpty){
                                  cahsierName = UT.GetRow(cashierList, "acno", pumpData[index]['pump_hold'].trim(),'name');
                                }

                                return Card(
                                    elevation: 3,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Amount : \u{20B9}${pumpData[index]["amount"].toStringAsFixed(2)}",
                                                  style: PetroSoftTextStyle.style16AppColor
                                              ),
                                              const SizedBox(height: 7,),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        pumpData[index]["pump_name"],
                                                        style: StyleForApp.text_style_normal_14_black
                                                    ),
                                                    Text(
                                                        "Rate : " +
                                                            pumpData[index]["rate"]
                                                                .toStringAsFixed(2),
                                                        // style: StyleForApp.text_style_normal_14_black
                                                        style: StyleForApp.text_style_bold_14_darkblue
                                                    ),
                                                  ]
                                              ),
                                              Divider(color: ColorsForApp.light_gray_color,),
                                              InkWell(
                                                onTap: (){
                                                  UT.m['selectedPumpIndex'] = index.toString();
                                                  newEndMeter = TextEditingController(
                                                      text: pumpData[index]["end_meter"]
                                                          .toStringAsFixed(2));
                                                  testingMeter = TextEditingController(
                                                      text: pumpData[index]["ret_meter"]
                                                          .toStringAsFixed(2));
                                                  selectedIncharge=cahsierName;
                                                  acno=pumpData[index]['pump_hold'].toString();

                                                  showGeneralDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      barrierLabel: MaterialLocalizations.of(context)
                                                          .modalBarrierDismissLabel,
                                                      barrierColor: Colors.transparent,
                                                      transitionDuration: const Duration(milliseconds: 200),
                                                      pageBuilder: (BuildContext buildContext,
                                                          Animation animation,
                                                          Animation secondaryAnimation) {
                                                        return Scaffold(
                                                          backgroundColor: Colors.grey,
                                                          body: Center(
                                                            child: Container(
                                                              width: MediaQuery.of(context).size.width - 30,
                                                              height: MediaQuery.of(context).size.height -  200,
                                                              padding: EdgeInsets.all(20),
                                                              color: Colors.white,
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    const SizedBox(height: 10,),
                                                                    Text('Update End Meter',style: StyleForApp.text_style_bold_16_owner_dark,),
                                                                    const SizedBox(height: 10,),
                                                                    TextField(
                                                                      controller: newEndMeter,
                                                                      keyboardType: TextInputType.number,
                                                                      decoration: InputDecoration(
                                                                        // filled: true,
                                                                        contentPadding: const EdgeInsets.all(8.0),
                                                                        // fillColor: Colors.grey.shade100,
                                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                                        hintText: "End Meter",
                                                                        labelText: "End Meter",
                                                                        //contentPadding: EdgeInsets.all(15.0),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    TextField(
                                                                      controller: testingMeter,
                                                                      keyboardType: TextInputType.number,
                                                                      decoration: InputDecoration(
                                                                        //filled: true,
                                                                        contentPadding: const EdgeInsets.all(8.0),
                                                                        // fillColor: Colors.grey.shade100,
                                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                                        hintText: "Testing",
                                                                        labelText: "Testing",
                                                                        //contentPadding: EdgeInsets.all(15.0),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 10,),
                                                                    Container(
                                                                      height: 40,
                                                                      //  width:200,
                                                                      decoration: BoxDecoration(//DecorationImage
                                                                        border: Border.all(
                                                                          color: Colors.black12,
                                                                          // width: 8,
                                                                        ), //Border.all
                                                                        borderRadius: BorderRadius.circular(10.0),),
                                                                      child: Autocomplete<InchargeModel>(
                                                                        initialValue: TextEditingValue(text: selectedIncharge),
                                                                        optionsBuilder: (TextEditingValue value) {

                                                                          // When the field is empty
                                                                          if (value.text.isEmpty) {
                                                                            return [];
                                                                          }

                                                                          // The logic to find out which ones should appear
                                                                          return inchargeList
                                                                              .where((customer) => customer.name!.toLowerCase()
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

                                                                                //fillColor:Colors.grey.shade300,
                                                                                //border: OutlineInputBorder(),
                                                                                labelText: "Select Cashier",
                                                                                labelStyle: const TextStyle(fontSize: 13.0,
                                                                                    color: Colors.grey),
                                                                                border: InputBorder.none
                                                                            ),
                                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                                          );
                                                                        },
                                                                        displayStringForOption: (InchargeModel option) => option.name!,
                                                                        onSelected: (value) {
                                                                          setState(() {
                                                                            selectedIncharge = value.name!;
                                                                            acno = value.acno!;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 30,),
                                                                    ButtonBar(
                                                                      buttonMinWidth: 100,
                                                                      alignment: MainAxisAlignment.spaceEvenly,
                                                                      children: <Widget>[
                                                                        ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              primary: ColorsForApp.app_theme_color_light_owner_drawer,
                                                                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                                                                              textStyle: StyleForApp.text_style_bold_14_black),
                                                                          child: const Text("Cancel",style: TextStyle( color:Colors.black ,),),
                                                                          onPressed: () => Navigator.of(context).pop(),
                                                                        ),
                                                                        ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              primary: ColorsForApp.app_theme_color_owner,
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                              textStyle: StyleForApp.text_style_bold_14_white),
                                                                          child: const Text("Save"),
                                                                          onPressed: (){
                                                                            saveEndMeter(context);
                                                                            /* Future.delayed(Duration(seconds: 1)).then((value) async {

                                                                          });*/

                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });

                                                },
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "Start Meter : \n" +
                                                            pumpData[index]["st_meter"]
                                                                .toStringAsFixed(2),
                                                        style: StyleForApp.text_style_bold_14_black
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "End Meter : \n" +
                                                                pumpData[index]["end_meter"].toStringAsFixed(2),

                                                            style: StyleForApp.text_style_bold_14_black
                                                        ),
                                                        Image.asset(PetroSoftAssetFiles.edit,height: 20,width: 20,)
                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 7,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                          "Testing : " +
                                                              pumpData[index]["ret_meter"]
                                                                  .toStringAsFixed(2)
                                                                  .toString(),
                                                          style:  TextStyle(fontSize: 14,color:Colors.cyan.shade900)
                                                      ),

                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          "Sale Ltr : " +
                                                              pumpData[index]["diff_meter"]
                                                                  .toStringAsFixed(2)
                                                                  .toString(),
                                                          style:  TextStyle(fontSize: 14,color:Colors.cyan.shade900)
                                                      ),
                                                    ],
                                                  )
                                                ],),
                                              const SizedBox(height: 7,),
                                              Text(
                                                  "Pump Cashier : $cahsierName",
                                                  style:  const TextStyle(fontSize: 13,fontWeight:FontWeight.w400,color:Colors.black87)
                                              ),

                                            ]
                                        )
                                    )
                                );

                              }else{
                                return Container();
                              }
                            },
                          );


                      }else{
                        return Center(
                            child:Text("No pump sale data found!!",style: UT.PetroOwnerNoDataStyle,));
                      }
                    }else{
                       // return Center(child:Text("No pump sale data found!!",style: UT.PetroOwnerNoDataStyle,));
                      return Center(child: CommonWidget.circularIndicator());
                    }
                    return Center(child: CommonWidget.circularIndicator());
                  },
                )),
          ),
       ),
    );

  }
  shiftInChargeData() async {
    var _url = UT.APIURL! +
        "api/AccountMaster/GetAcMast?curyear="+UT.curyear!+
        "&shop="+ UT.shop_no! +
        "&Where=left(acno,3)='" + UT.AC("Collect_AC") + "' and len(acno) >= 6";
    print("In--$_url");
    var data = await UT.apiStr(_url);
    cashierList =json.decode(data);
    inchargeList = cashierList.map((val) =>  InchargeModel.fromJson(val)).toList();
  }

  saveEndMeter(ctx) async {
    int tapIndex = int.parse(UT.m['selectedPumpIndex'].toString());
    DialogBuilder(ctx).showLoadingIndicator('');
    if (double.parse(newEndMeter.value.text) >= pumpData[tapIndex]['st_meter']) {
      pumpData[tapIndex]['end_meter'] = double.parse(newEndMeter.value.text);
      if(testingMeter.text.isEmpty||testingMeter.text==""){
        pumpData[tapIndex]['ret_meter']=0.0;
      }else{
        pumpData[tapIndex]['ret_meter'] = double.parse(testingMeter.value.text);
      }

      pumpData[tapIndex]["diff_meter"] = pumpData[tapIndex]["end_meter"] - pumpData[tapIndex]["st_meter"] - pumpData[tapIndex]["ret_meter"];
      pumpData[tapIndex]['amount'] = pumpData[tapIndex]["diff_meter"] * pumpData[tapIndex]["rate"];
      pumpData[tapIndex]['pump_hold'] = acno;
      setState(() {});
      Navigator.pop(ctx);
      var data = [];
      data.add(pumpData[tapIndex]);
      var _url = UT.APIURL! +
          "api/PostData/Post?tblname=pmbd" +
          UT.curyear! +
          UT.shop_no!;
      _url += "&Unique=SRNO,NO";
      var result = await UT.save2Db(_url, data);
      if(result=="ok"){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Update Successfully');
      }else{
        DialogBuilder(ctx).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Problem while Updating data!');
      }
    } else {
      DialogBuilder(ctx).hideOpenDialog();
      Fluttertoast.showToast(msg: 'End meter reading should be greater then start meter reading.');
    }
  }
  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return const ManagerShiftSalePage();
    }));
    // return true if the route to be popped
  }
}

