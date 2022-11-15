import 'dart:io';

import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOperator/pump_camera.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/PetrosoftOperator/operator_home_page.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:petrosoft_india/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:uuid/uuid.dart';

class PumpReading extends StatefulWidget {
  const PumpReading({Key? key}) : super(key: key);

  @override
  _PumpReadingState createState() => _PumpReadingState();
}

class _PumpReadingState extends State<PumpReading> {
  dynamic pumpData;

  TextEditingController newEndMeter =  TextEditingController();
  TextEditingController testingController =  TextEditingController();

  var closingMeterReading = '0';
  dynamic startImagePath;
  dynamic endImagePath;
  bool isLoading=true;
  String? srNo;
  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  void dispose() {
    newEndMeter.dispose();
    super.dispose();
  }
  getData() async {
    var _url = UT.APIURL! +
        "api/PumpTrnE/GetPumpReading4Cash?saleyear1=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&date=" +
        UT.m['saledate'].toString() +
        "&shift=" +
        UT.m['shift'].toString() +
        "&pump_hold="+UT.ClientAcno.toString();
    pumpData = await UT.apiDt(_url);
    srNo=pumpData[0]["srno"].toString();
    isLoading=false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
         //backgroundColor: Colors.blue[50],
        appBar: AppBar(title:  Text('Pump Reading',style: PetroSoftTextStyle.style17White,),
            leading: IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PetroSoftOperatorHomePage()));
              },
              icon: const Icon(Icons.arrow_back),
            ),
            titleSpacing: 0.0, backgroundColor: ColorsForApp.appThemeColor),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading==false
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      closingMeterReading =
                          pumpData[index]["end_meter"].toStringAsFixed(2);
                      srNo=pumpData[index]["srno"].toString();
                      return srNo==""? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 100,),
                          Center(child:Text("No data found!!",style: UT.PetroOperatorNoDataStyle),),
                        ],

                      )
                      : InkWell(
                        onTap: (){
                          UT.m['selectedPumpIndex'] = index.toString();
                          newEndMeter = TextEditingController(
                              text: pumpData[index]["end_meter"].toStringAsFixed(2));
                          testingController=TextEditingController(
                              text: pumpData[index]["ret_meter"].toStringAsFixed(2));
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('End Meter'),
                                  content: SizedBox(
                                    height: 120,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: newEndMeter,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: "End Meter",
                                            ),
                                          ),
                                          TextField(
                                            controller: testingController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                hintText: "Enter Testing",
                                                labelText: "Testing"),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: <Widget>[
                                    ButtonBar(
                                      buttonMinWidth: 100,
                                      alignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: ColorsForApp.app_theme_color_light_drawer_operator,
                                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                                              textStyle: StyleForApp.text_style_bold_14_black),
                                          child: const Text("Cancel",style: TextStyle( color:Colors.black ,),),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: ColorsForApp.appThemeColor,
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              textStyle: StyleForApp.text_style_bold_14_white),
                                          child: const Text("Save"),
                                          onPressed: (){
                                            saveEndMeter(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            "Amount : " +
                                                "\u{20B9}${pumpData[index]["amount"].toStringAsFixed(2)}",
                                            style: StyleForApp.text_style_bold_16_operator_dark
                                        )
                                      ],
                                    ),
                                  ]),
                                  const SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              pumpData[index]["pump_name"],
                                              style: StyleForApp.text_style_bold_14_black
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              "Rate : " +
                                                  pumpData[index]["rate"]
                                                      .toStringAsFixed(2),
                                              style: StyleForApp.text_style_normal_14_black
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(color: ColorsForApp.light_gray_color,),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                  onTap: () async {
                                    DialogBuilder(context).showLoadingIndicator('');
                                    UT.m['selectedPumpIndex'] = index.toString();
                                    saveStartMeterImage(context).then((value){
                                      DialogBuilder(context).hideOpenDialog();
                                      setState(() {
                                        pumpData[index]['start_meter_image']=value;
                                      });
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.add_a_photo),
                                  ),
                                ),
                                Expanded(
                                    child:  Text(
                                        "Start Meter : \n" +
                                            pumpData[index]["st_meter"]
                                                .toStringAsFixed(2),
                                        style: StyleForApp.text_style_normal_14_black
                                    ),),
                                Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        DialogBuilder(context).showLoadingIndicator('');
                                        UT.m['selectedPumpIndex'] = index.toString();
                                        saveEndMeterImage(context).then((value){
                                          DialogBuilder(context).hideOpenDialog();
                                          setState(() {
                                            pumpData[index]['end_meter_image']=value;
                                            print( pumpData[index]['end_meter_image']);
                                          });
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.add_a_photo),
                                      ),
                                    ),
                                    Text(
                                        "End Meter : \n" +
                                            //PumpData[index]["end_meter"].toStringAsFixed(2),
                                            closingMeterReading,
                                        style: StyleForApp.text_style_normal_14_black
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:  Icon(Icons.mode_edit_outline_rounded,color: ColorsForApp.icon_operator, size: 15,),
                                    )
                                  ],
                                ),
                              ]),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  pumpData[index]['start_meter_image']!=null?Padding(
                                    padding: const EdgeInsets.only(left: 8.0,right: 10),
                                    child: Container(
                                        color: Colors.red,
                                        width: 130,
                                        height: 65,
                                        child:Image.file(
                                          File(pumpData[index]['start_meter_image']),fit: BoxFit.cover,
                                        )
                                    ),
                                  ):Container(),
                                  pumpData[index]['end_meter_image']!=null?Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0,right: 10),
                                      child: Container(
                                          width: 50,
                                          height: 65,
                                          child:Image.file(
                                            File(pumpData[index]['end_meter_image']),fit: BoxFit.cover,
                                          )
                                      ),
                                    ),
                                  ):Container(),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "Testing : " +
                                          pumpData[index]["ret_meter"]
                                              .toStringAsFixed(2)
                                              .toString(),
                                      style: StyleForApp.text_style_normal_14_black
                                  ),
                                  Text(
                                      "Sale Ltr : " +
                                          pumpData[index]["diff_meter"]
                                              .toStringAsFixed(2)
                                              .toString(),
                                      style: StyleForApp.text_style_normal_14_black
                                  ),
                                ],
                              ),
                                ]),
                          ),
                        ),
                      );
                      },
                    itemCount: pumpData.length)
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return  const PetroSoftOperatorHomePage();
    }));
    // return true if the route to be popped
  }
 Future saveStartMeterImage(ctx) async {
    int indx = int.parse(UT.m['selectedPumpIndex'].toString());
    if (pumpData[indx]!=null) {
      Map map=await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PumpReadingCamera(onClick:"Start"),
          ),
        );
        if(map['onClick']=="Start"){
         var sartImagePath=map['path'];
         List imageDataList=[];
         String Uuid1= const Uuid().v1();
         String? prepareImagepath=UT.CustCodeAmt!+"_"+ Uuid1+"_"+"1"+".jpeg";
         var imageData= Map();
         imageData["imageid"]=prepareImagepath;
         imageData["client_code"]=UT.CustCodeAmt!+UT.curyear!+UT.shop_no!;
         imageData["recordtable"]="pmbd"+pumpData[indx]["srno"]+pumpData[indx]["no"]+"_"+"1";
         imageDataList.add(imageData);

         var imageApi_url = UT.APIURL! +
             "api/PostData/Post?tblname=imagedocumenttable";
         imageApi_url += "&Unique=client_code,recordtable&iscommDB=true";
         print("imageApi_url-->$imageApi_url");
         var Response = await UT.save2Db(imageApi_url, imageDataList);

         var result = UT.saveImages2Server(imageData["imageid"],UT.m["Start"]);
          return sartImagePath;
        }
    }
  }
  Future saveEndMeterImage(ctx) async {
    int indx = int.parse(UT.m['selectedPumpIndex'].toString());
    if (pumpData[indx]!=null) {
      Map map=await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PumpReadingCamera(onClick:"End"),
        ),
      );
      if(map['onClick']=="End"){
      var  endImagePath=map['path'];
      List imageDataList=[];
      String Uuid1= const Uuid().v1();
      String? prepareImagepath=UT.CustCodeAmt!+"_"+ Uuid1+"_"+"2"+".jpeg";
      var imageData= Map();
      imageData["imageid"]=prepareImagepath;
      imageData["client_code"]=UT.CustCodeAmt!+UT.curyear!+UT.shop_no!;
      imageData["recordtable"]="pmbd"+pumpData[indx]["srno"]+pumpData[indx]["no"]+"_"+"2";
      imageDataList.add(imageData);

      var imageApi_url = UT.APIURL! +
          "api/PostData/Post?tblname=imagedocumenttable";
      imageApi_url += "&Unique=client_code,recordtable&iscommDB=true";

      var Response = await UT.save2Db(imageApi_url, imageDataList);


      var result = UT.saveImages2Server(imageData["imageid"],UT.m["End"]);

      return endImagePath;

      }
    }
  }

  saveEndMeter(ctx) async {
    int indx = int.parse(UT.m['selectedPumpIndex'].toString());
    if (double.parse(newEndMeter.value.text) >= pumpData[indx]['st_meter']) {
      pumpData[indx]['end_meter'] = double.parse(newEndMeter.value.text);
      pumpData[indx]["diff_meter"] = pumpData[indx]["end_meter"] - pumpData[indx]["st_meter"] - pumpData[indx]["ret_meter"];
      pumpData[indx]['amount'] = pumpData[indx]["diff_meter"] * pumpData[indx]["rate"];

     //calulation for to testing
      pumpData[indx]["ret_meter"] = double.parse(testingController.value.text);
      print("diff -->${ testingController.value.text}");
      pumpData[indx]["diff_meter"] = pumpData[indx]["end_meter"] - pumpData[indx]["st_meter"] - pumpData[indx]["ret_meter"];
      print("diff -->${ pumpData[indx]["diff_meter"]}");
      pumpData[indx]['amount'] = pumpData[indx]["diff_meter"] * pumpData[indx]["rate"];

      setState(() {});

      var data = [];
      data.add(pumpData[indx]);
      var _url = UT.APIURL! +
          "api/PostData/Post?tblname=pmbd" +
          UT.curyear! +
          UT.shop_no!;
      _url += "&Unique=SRNO,NO";
      var result = await UT.save2Db(_url, data);
     if(result=="ok"){
       Navigator.pop(ctx);
       Fluttertoast.showToast(
           msg: 'Update successfully.');
     }else{
       Navigator.pop(ctx);
       Fluttertoast.showToast(
           msg: 'Something went wrong please try sometime.');
     }
    } else {
      Fluttertoast.showToast(
          msg: 'End meter reading should be greater then start meter reading.');
    }
  }
}
