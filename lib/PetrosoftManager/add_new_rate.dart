import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/manager_home_page.dart';
import 'package:petrosoft_india/PetrosoftManager/rate_master.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../common_home_page.dart';
class MangerAddNewRate extends StatefulWidget {
  final String validFromDate,validUptoDate;
  const MangerAddNewRate({Key? key, required this.validFromDate,required this.validUptoDate}) : super(key: key);
  @override
  _MangerAddNewRateState createState() => _MangerAddNewRateState();
}

class _MangerAddNewRateState extends State<MangerAddNewRate> {
  List<TextEditingController> textEditingControllers = [];
  List<TextEditingController> mrpControllers = [];
  dynamic previousDate;
  dynamic itemList;
  dynamic allItemList;
  double plRate=0.00;
  double? mRP;
  dynamic api;
  TextEditingController searchController = TextEditingController();
  bool disableTextField=true;
  DateTime? currentDate = DateTime.now();
  String? _newPriceListFromDate;
  @override
  void initState() {
    super.initState();
    _newPriceListFromDate = UT.yearMonthDateConverter(currentDate);
    api=getData();
  }

    getData() async {
    var _url = UT.APIURL! +
        "api/PriceListEnt/GetData4mobileApp?_shop=" +
        UT.shop_no! +
        "&validfrom=" +
        widget.validFromDate;
    var data = await UT.apiDt(_url);
    itemList=data;
    allItemList=data;
   // print("itemList-->$itemList");
    for(int i=0;i<itemList.length;i++){
//.toStringAsFixed(2)
      plRate=itemList[i]["pl_rate"];
      print(plRate);
      //plRate=rate;
      mRP=itemList[i]["item_mrp"];
      var textEditingController = TextEditingController(text: plRate.toStringAsFixed(2));
      textEditingControllers.add(textEditingController);
      var mrpEditingController = TextEditingController(text: mRP.toString());
      mrpControllers.add(mrpEditingController);
    }
    var yearEndDate=UT.dateMonthYearFormat(UT.yearEndDate!);
    if(yearEndDate==widget.validUptoDate){
      disableTextField=false;
    }
    return itemList;
  }
  Future<bool?> _willPopCallback() async {
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return const Dashboard();
    }));
    // return true if the route to be popped
  }
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
       // backgroundColor: Colors.indigo.shade100,
        appBar: AppBar(
         leading: IconButton(
           icon: Icon(Icons.arrow_back),
           onPressed: (){
             Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) =>
                     const Dashboard()));
           },
         ),
          title: const Text('Rate Master',),
          backgroundColor: ColorsForApp.app_theme_color_owner,
          actions: [
            IconButton(onPressed: () async {
              DialogBuilder(context).showLoadingIndicator('');
              print("111");
              List itemDataList=[];
              for(int i=0;i<itemList.length;i++){
                var itemlistSaveDate= Map();
                itemlistSaveDate["item_desc"]=itemList[i]["item_desc"];
                itemlistSaveDate["item_code"]=itemList[i]["item_code"];
                itemlistSaveDate["validfrom"]=itemList[i]["validfrom"];
                itemlistSaveDate["validupto"]=itemList[i]["validupto"];
                itemlistSaveDate["pl_rate"]=textEditingControllers[i].text;
                itemlistSaveDate["item_mrp"]=mrpControllers[i].text;
                itemDataList.add(itemlistSaveDate);

              }
              print("itemDataList-->$itemDataList");
              print("222");
              var save_url = UT.APIURL! +
                  "api/PostData/Post?tblname=plrate" +
                  UT.shop_no!;
              save_url += "&Unique=item_code,validfrom";
              var result = await UT.save2Db(save_url, itemDataList);
              print(result);
              if(result=="ok"){
                DialogBuilder(context).hideOpenDialog();
                Fluttertoast.showToast(msg: "Save successfully");
                 Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const Dashboard()));
              }else{
                DialogBuilder(context).hideOpenDialog();
                Fluttertoast.showToast(msg: "Problem while data saving");
              }


            }, icon: Icon(Icons.check_circle),color: Colors.white,)
          ],),



          body: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child:Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        autofocus: false,
                        onChanged: (value) {
                          search(value);
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: "Search",
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        children: [
                          Text("From Date : "+widget.validFromDate,style: StyleForApp.text_style_bold_14_black,),
                          SizedBox(width: 10,),
                          Text("To Date : "+widget.validUptoDate,style: StyleForApp.text_style_bold_14_black)
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0,right: 0.0,top: 0),
                    child: Container(
                      color: ColorsForApp.app_theme_color_light_owner_drawer,
                      height: 40,
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "  Description",
                              maxLines: 2,
                              style: StyleForApp.text_style_bold_14_owner_icon
                            ),
                          ),
                         // SizedBox(width: 30,),
                          Expanded(
                            child: Text(
                              "           PL Rate",
                              maxLines: 2,
                                style: StyleForApp.text_style_bold_14_owner_icon
                            ),
                          ),
                         /* Expanded(
                            child: Text(
                              "        MRP",
                              maxLines: 2,
                                style: StyleForApp.text_style_bold_14_owner_icon
                            ),
                          ),*/
                        ]),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: api,
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                            itemBuilder: (context, index) {
                               plRate=itemList[index]["pl_rate"];
                                 mRP=itemList[index]["item_mrp"];

                              return Stack(
                                children: [
                                  Container(
                                    height: 53.0,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(left: 0.0,top: 10,right: 20),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5,),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    itemList[index]["item_desc"],
                                                   style: StyleForApp.text_style_normal_14_black,
                                                  ),
                                                ),
                                                Expanded(
                                                  //height: 40,
                                                  //width: 100,
                                                  child: Container(
                                                    height: 40,
                                                    child: TextFormField(
                                                      textAlign: TextAlign.center,
                                                      readOnly: disableTextField,
                                                      //maxLines: 2,
                                                      controller: textEditingControllers[index],
                                                      keyboardType: TextInputType.number,
                                                      autofocus: false,
                                                      onChanged: (text) {
                                                        if(text.isNotEmpty){
                                                          plRate=double.parse(text);
                                                        }

                                                      },
                                                      decoration: InputDecoration(
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                        //hintText: "$plRate",
                                                        //contentPadding: EdgeInsets.all(15.0),
                                                      ),
                                                    ),
                                                  ),

                                                ),
                                                const SizedBox(width: 10,),
                                               /* SizedBox(
                                                  height: 40,
                                                  width: 70,
                                                  child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    readOnly: disableTextField,
                                                    controller: mrpControllers[index],
                                                    keyboardType: TextInputType.number,
                                                    autofocus: false,
                                                    onChanged: (text) {
                                                     mRP=double.parse(text);
                                                    },
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                      //  hintText: "$MRP"
                                                      //contentPadding: EdgeInsets.all(15.0),
                                                    ),
                                                  ),

                                                ),*/

                                              ]),

                                        ]),
                                  ),
                                   Divider(color: ColorsForApp.light_gray_color,)
                                ],
                              );
                            },
                            itemCount: itemList.length);
                      }
                      return Center(child:CommonWidget.circularIndicator());
                    },
                    ),
                  ),

                ],
              )

          ),
        bottomNavigationBar: submitButton(),
      ),
    );
  }
  void search(String query) {
    if (query.isEmpty) {
      print("allItemList-->$allItemList");
      itemList=allItemList;
      setState(() {});
      return;
    }

    query = query.toLowerCase();
    print(query);
    List result = [];
    itemList.forEach((p) {
      var name = p["item_desc"].toString().toLowerCase();
      if (name.contains(query)) {
        result.add(p);
      }
    });

    itemList = result;
    setState(() {});
  }
  Widget submitButton(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 100,
        child: Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15.0,bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150,height: 40,
                  decoration: BoxDecoration(
                      gradient:  LinearGradient(colors: [Colors.blue, Colors.cyan],
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
       Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ManagerRateMaster()));
                    },
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu,color: Colors.white,size: 17,),
                        SizedBox(width: 5,),
                        Text(
                          "Old Rate List",
                          style: const TextStyle(fontSize:15,color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 150,height: 40,
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
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu,color: Colors.white,size: 17),
                        SizedBox(width: 5,),
                        Text(
                          "New Price List",
                          style: const TextStyle(fontSize:15,color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
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
                                              widget.validFromDate.toString(),
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
                            onPressed: (){
                          Navigator.of(context).pop();
                        },
                            child: const Text("Cancel")),
                        ElevatedButton(
                          child: const Text("OK"),
                          onPressed: () {
                            previousDate = currentDate!.subtract(Duration(days: 1));
                            //print(previousDate);
                           // print("validFromDate-->$validFromDate");
                            DialogBuilder(context).showLoadingIndicator('');
                            getItemListData(widget.validFromDate);

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

  getItemListData(String validFromDate) async {
    var _url = UT.APIURL! +
        "api/PriceListEnt/GetData4mobileApp?_shop=" +
        UT.shop_no! +
        "&validfrom=" +
        UT.yearMonthDate(validFromDate).toString();
    print("_url-->$_url");
    var itemList = await UT.apiDt(_url);
    print("itemList-->$itemList");
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
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Rate added successfully');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (
                    context) =>
                    MangerAddNewRate(
                        validFromDate: widget.validFromDate,
                        validUptoDate: _newPriceListFromDate!)));
      }
    }
  }

}
