import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/add_new_rate.dart';
import 'package:petrosoft_india/common_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'old_rate_master.dart';


class RateMasterPage extends StatefulWidget {
  const RateMasterPage({Key? key}) : super(key: key);

  @override
  _RateMasterPageState createState() => _RateMasterPageState();
}

class _RateMasterPageState extends State<RateMasterPage> {
  dynamic rateMasterData;
  bool isLoading = true;
  String? dSrno;
  DateTime? currentDate = DateTime.now();
  String? _newPriceListFromDate;
  String? validFromDate;
  String? formatSelectedNewPriceDate;
  dynamic previousDate;

  @override
  void initState() {
    super.initState();
    _newPriceListFromDate = UT.displayDateConverter(currentDate);
  }

  getData() async {
    var _url = UT.APIURL! +
        "api/PriceListEnt/GetDistinctDate4mobile?_shopno=" +
        UT.shop_no!;
    var data = await UT.apiDt(_url);
    rateMasterData = data;
    var lastRc = rateMasterData[rateMasterData.length - 1];
    validFromDate = UT.dateMonthYearFormat(lastRc["validfrom"]);
    return rateMasterData;
  }




  Future<bool?> _willPopCallback() async {
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return const Dashboard();
    }));
    // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        // backgroundColor: Colors.indigo.shade100,
        appBar: AppBar(title:  Text('Rate Master',style: PetroSoftTextStyle.style17White,), backgroundColor: ColorsForApp.app_theme_color_owner),
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: ColorConverter.hexToColor("#D9D9D9").withOpacity(0.2),
                    height: 45,
                    child: IntrinsicHeight(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "       Valid From",
                                maxLines: 2,
                                style: StyleForApp.text_style_bold_14_owner_icon
                            ),
                            ),
                            VerticalDivider(color: ColorsForApp.light_gray_color),
                            Expanded(
                              child: Text(
                                "       Valid Upto",
                                maxLines: 2,
                                style: StyleForApp.text_style_bold_14_owner_icon
                              ),
                            ),
                            SizedBox(width: 35,)
                          ]),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemBuilder: (context, index) {
                                String validFromDate = UT.dateMonthYearFormat(
                                    rateMasterData[index]["validfrom"]);
                                String validUptoDate = UT.dateMonthYearFormat(
                                    rateMasterData[index]["validupto"]);

                                return Stack(
                                  children: [
                                    Container(
                                      height: 53.0,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                          left: 0.0, top: 10.0),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            SizedBox(height: 5,),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          validFromDate,
                                                          style: const TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                 // VerticalDivider(color: ColorsForApp.light_gray_color),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          validUptoDate,
                                                          maxLines: 2,
                                                          style: const TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  /*ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        onPrimary: Colors.white,
                                                        primary: Colors.purple
                                                            .shade50,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    AddNewRate(
                                                                        validFromDate: rateMasterData[index]["validfrom"],
                                                                        validUptoDate: validUptoDate)));
                                                      },
                                                      icon: Icon(Icons.edit,
                                                        color: UT
                                                            .ownerAppColor,),
                                                      label: Text('Edit',
                                                        style: TextStyle(
                                                            color: UT
                                                                .ownerAppColor),))*/
                                                  IconButton(
                                                    icon: Icon(Icons.remove_red_eye, size: 15, color: ColorsForApp.icon_owner,),
                                                    onPressed: () {

                                                    },


                                                  ),


                                                ]),

                                          ]),
                                    ),
                                    const Divider(thickness: 1.5,)
                                  ],
                                );
                              },
                              itemCount: rateMasterData.length);
                        }
                        return Center(child: CommonWidget.circularIndicator());
                      },
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
        //bottomNavigationBar: submitButton(),
      ),
    );
  }

  Widget submitButton() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: CommonButtonForAllApp(onPressed: (){
        pickDateDialog(context);
      }, title: 'New Price List',backgroundColor: ColorsForApp.app_theme_color_owner),
    );
  }
  Widget newPriceListButton() {
   return Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15.0,bottom: 8.0,top:10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 45,
              decoration: BoxDecoration(
                  gradient:  LinearGradient(colors: [ColorsForApp.app_theme_color_owner, ColorsForApp.app_theme_color_owner],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(5, 5),
                      blurRadius: 10,
                    )
                  ],
                  borderRadius: BorderRadius.circular(20.0)
              ),
              child: TextButton(
                onPressed: (){
                  pickDateDialog(context);
                },
                child: const Text(
                    'New Price List',
                  style: TextStyle(fontSize:16,color: Colors.white),
                ),
              ),
            ),
          ],
        )
    );
  }
  Widget oldPriceListButton() {
   return Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15.0,bottom: 8.0,top:10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 45,
              decoration: BoxDecoration(
                  gradient:  LinearGradient(colors: [ColorsForApp.app_theme_color_owner, ColorsForApp.app_theme_color_owner],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(5, 5),
                      blurRadius: 10,
                    )
                  ],
                  borderRadius: BorderRadius.circular(20.0)
              ),
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const OldRateMasterPage()));
                },
                child: const Text(
                    'Old Price List',
                  style: TextStyle(fontSize:16,color: Colors.white),
                ),
              ),
            ),
          ],
        )
    );
  }

  pickDateDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, StateSetter setState1) {
                return AlertDialog(
                  content: SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.2,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text("Current Price List\nFrom"),
                                Container(
                                  height: 45, width: 100,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          width: 1.0, color: Color(0xECEAEAF6)),
                                      left: BorderSide(
                                          width: 1.0, color: Color(0xECEAEAF6)),
                                      right: BorderSide(
                                          width: 1.0, color: Color(0xECEAEAF6)),
                                      bottom: BorderSide(
                                          width: 1.0, color: Color(0xECEAEAF6)),
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5)),
                                    color: Color(0xF6F3F3F3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[

                                        InkWell(
                                          child: Text(
                                              validFromDate.toString(),
                                              textAlign: TextAlign.center,
                                              style: StyleForApp.text_style_normal_14_owner
                                          ),
                                          onTap: () {
                                            // _selectFromDate(context,setState1);
                                          },
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text("New Price List    \nFrom"),
                                Container(
                                  height: 45, width: 100,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(width: 1.0,
                                            color: Color(0xECEAEAF6)),
                                        left: BorderSide(width: 1.0,
                                            color: Color(0xECEAEAF6)),
                                        right: BorderSide(width: 1.0,
                                            color: Color(0xECEAEAF6)),
                                        bottom: BorderSide(width: 1.0,
                                            color: Color(0xECEAEAF6)),
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        InkWell(
                                          child: Text(
                                              "$_newPriceListFromDate",
                                              textAlign: TextAlign.center,
                                              style: StyleForApp.text_style_normal_14_owner
                                          ),
                                          onTap: () {
                                            openDatePicker(context, setState1);
                                          },
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ])
                  ),
                  actions: <Widget>[
                    ButtonBar(
                      buttonMinWidth: 100,
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(

                          child: const Text("Cancel"),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        ElevatedButton(

                          child: const Text("OK"),

                          onPressed: () {
                            previousDate = currentDate!.subtract(Duration(days: 1));
                            print(previousDate);
                            getItemListData(validFromDate!);

                          },
                        ),
                      ],
                    ),
                  ],
                );
              }

          );
        });
  }

  getItemListData(String validFromDate) async {
    var _url = UT.APIURL! +
        "api/PriceListEnt/GetData4mobileApp?_shop=" +
        UT.shop_no! +
        "&validfrom=" +
        validFromDate;
    var itemList = await UT.apiDt(_url);
    String formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(previousDate.toString()));
    List itemDataList=[];
    for(int i=0;i<itemList.length;i++){
      var itemlistSaveDate= Map();
      itemlistSaveDate["item_desc"]=itemList[i]["item_desc"];
      itemlistSaveDate["item_code"]=itemList[i]["item_code"];
      itemlistSaveDate["validfrom"]=itemList[i]["validfrom"];
      itemlistSaveDate["validupto"]=formattedDate;
      itemlistSaveDate["pl_rate"]=itemList[i]["pl_rate"];
      itemlistSaveDate["item_mrp"]=itemList[i]["item_mrp"];
      itemDataList.add(itemlistSaveDate);
    }
    var saveUrl = UT.APIURL! +
        "api/PostData/Post?tblname=plrate" +
        UT.shop_no!;
    saveUrl += "&Unique=item_code,validfrom";
    var result = await UT.save2Db(saveUrl, itemDataList);
    if(result=="ok"){
      List itemDataList=[];
      String formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(UT.yearEndDate.toString()));
      String validFromFormattedDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(currentDate.toString()));
      for (int i = 0; i < itemList.length; i++) {
        var itemlistSaveDate= Map();
        itemlistSaveDate["item_desc"]=itemList[i]["item_desc"];
        itemlistSaveDate["item_code"]=itemList[i]["item_code"];
        itemlistSaveDate["validfrom"]=validFromFormattedDate;
        itemlistSaveDate["validupto"]=formattedDate;
        itemlistSaveDate["pl_rate"]=itemList[i]["pl_rate"];
        itemlistSaveDate["item_mrp"]=itemList[i]["item_mrp"];
        itemDataList.add(itemlistSaveDate);

      }
      var saveUrl = UT.APIURL! +
          "api/PostData/Post?tblname=plrate" +
          UT.shop_no!;
      saveUrl += "&Unique=item_code,validfrom";
      var result = await UT.save2Db(saveUrl, itemDataList);
      if(result=="ok"){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const RateMasterPage()));
      }
    }
  }
  Future<void> openDatePicker(BuildContext context,
      StateSetter setState2) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: currentDate!,
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      lastDate: DateTime(2100),
    ))!;
    if (picked != null && picked != currentDate) {
      setState2(() {
        currentDate = picked;
        _newPriceListFromDate = UT.displayDateConverter(currentDate);
      });
    }
  }
}
