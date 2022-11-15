import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class PumpSalePage extends StatefulWidget {
  const PumpSalePage({Key? key}) : super(key: key);

  @override
  _PumpSalePageState createState() => _PumpSalePageState();
}

class _PumpSalePageState extends State<PumpSalePage> {
  TextEditingController newEndMeter =  TextEditingController();
  TextEditingController startMeter =  TextEditingController();
  TextEditingController testingMeter =  TextEditingController();
  TextEditingController rate =  TextEditingController();
  TextEditingController amount =  TextEditingController();
  //Icons.food_bank_rounded;
  dynamic pumpData;
  dynamic api;
  getData() async {
   // PumpHd = GetURLDt(APIURL + "/api/PumpTrnE/GetPumpHD?year=" + Setup('curyear') + "&shop=" + Firm("Shop") + "&Where=isdeleted <>'Y' and srno='" + srno + "'&Addrow=true");
   // PumpBd = GetURLDt(APIURL + "/api/PumpTrnE/GetPumpBD?cur_year=" + Setup('curyear') + "&shop=" + Firm("Shop") + "&Where=isdeleted <>'Y' and srno='" + srno + "'&Addrow=true");
    var _url = "${"${UT.APIURL!}api/PumpTrnE/GetPumpBD?cur_year=${UT.curyear!}&shop=${UT.shop_no!}&Where=srno='" + UT.m["slipNoOld"]}'&Addrow=true";
    pumpData = await UT.apiDt(_url);
    print(pumpData);
    return pumpData;
  }


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
        appBar: AppBar(title:  Text('Pump Sale',style: PetroSoftTextStyle.style17White,),titleSpacing: 0.0, backgroundColor: ColorsForApp.appThemeColor),
          body: Center(
            child: Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0,bottom: 15.0),
                child: FutureBuilder(
                  future: api,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      if(pumpData[0]["pump_no"]!=" "){
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: ScrollController(),
                          itemCount: pumpData.length,
                          itemBuilder: (BuildContext context, int index) {
                            if(pumpData[index]["pump_no"]!=""){
                              return Card(
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
                                                      style: StyleForApp.text_style_bold_14_black
                                                  ),
                                                  Text(
                                                      "Rate : " + pumpData[index]["rate"].toStringAsFixed(2),
                                                      style: StyleForApp.text_style_normal_14_black
                                                  ),
                                                ]
                                            ),
                                            Divider(color: ColorsForApp.light_gray_color,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        "Start Meter : \n" +
                                                            pumpData[index]["st_meter"]
                                                                .toStringAsFixed(2),
                                                        style: StyleForApp.text_style_normal_14_black
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        "End Meter : \n" +
                                                            pumpData[index]["end_meter"].toStringAsFixed(2),

                                                        style: StyleForApp.text_style_normal_14_black
                                                    ),

                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 7,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        "Testing : ${pumpData[index]["ret_meter"]
                                                                .toStringAsFixed(2)}",
                                                        style: StyleForApp.text_style_normal_14_black
                                                    ),

                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        "Sale Ltr : ${pumpData[index]["diff_meter"]
                                                                .toStringAsFixed(2)}",
                                                        style: StyleForApp.text_style_normal_14_black
                                                    ),
                                                  ],
                                                )
                                              ],),
                                          ]
                                      )
                                  )
                              );
                            }else{
                              return Container();
                            }
                            },
                        );
                      }
                    }else{
                        return Center(
                            child:Text("No pump sale data found!!",style: UT.PetroOwnerNoDataStyle,));
                      }
                    return Center(child: CommonWidget.circularIndicator());
                  },
                )),
          ),
       ),
    );

  }
  saveEndMeter(ctx) async {
    int tapIndex = int.parse(UT.m['selectedPumpIndex'].toString());
    if (double.parse(newEndMeter.value.text) >= pumpData[tapIndex]['st_meter']) {
      pumpData[tapIndex]['end_meter'] = double.parse(newEndMeter.value.text);
      pumpData[tapIndex]["diff_meter"] = pumpData[tapIndex]["end_meter"] - pumpData[tapIndex]["st_meter"] - pumpData[tapIndex]["ret_meter"];
      pumpData[tapIndex]['amount'] = pumpData[tapIndex]["diff_meter"] * pumpData[tapIndex]["rate"];
      setState(() {});
      Navigator.pop(ctx);
      var data = [];
      data.add(pumpData[tapIndex]);
      var _url = "${UT.APIURL!}api/PostData/Post?tblname=pmbd${UT.curyear!}${UT.shop_no!}";
      _url += "&Unique=SRNO,NO";
      var result = await UT.save2Db(_url, data);
    } else {
      Fluttertoast.showToast(
          msg: 'End meter reading should be greater then start meter reading.');
    }
  }
  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return const ShiftSalePage();
    }));
    // return true if the route to be popped
  }
}

