import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/manager_home_page.dart';
import 'package:petrosoft_india/PetrosoftManager/add_new_rate.dart';
import 'package:petrosoft_india/PetrosoftManager/manager_home_page.dart';
import 'package:petrosoft_india/PetrosoftManager/old_rate_list.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../common_home_page.dart';


class ManagerRateMaster extends StatefulWidget {
  const ManagerRateMaster({Key? key}) : super(key: key);

  @override
  _ManagerRateMasterState createState() => _ManagerRateMasterState();
}

class _ManagerRateMasterState extends State<ManagerRateMaster> {
  dynamic rateMasterData;
  bool isLoading = true;
  String? dSrno;
  DateTime? currentDate = DateTime.now();
  String? _newPriceListFromDate;
  String? validFromDate;
  String? validUptoDate;
  String? formatSelectedNewPriceDate;
  dynamic previousDate;

  @override
  void initState() {
    super.initState();
    _newPriceListFromDate = UT.yearMonthDateConverter(currentDate);
  }

  getData() async {
    var _url = UT.APIURL! +
        "api/PriceListEnt/GetDistinctDate4mobile?_shopno=" +
        UT.shop_no!;
    var data = await UT.apiDt(_url);
    rateMasterData = data;
    var lastRc = rateMasterData[rateMasterData.length - 1];
    validFromDate = UT.yearMonthDateFormat(lastRc["validfrom"]);
     validUptoDate = UT.dateMonthYearFormat(lastRc["validupto"]);
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
        appBar: AppBar(title: const Text('Rate Master',),
            backgroundColor: ColorsForApp.app_theme_color_manager,
        ),

        body: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    color: ColorsForApp.app_theme_color_light_owner_drawer,
                    height: 40,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "     Valid From",
                              maxLines: 2,
                              style: StyleForApp.text_style_bold_14_owner_icon
                          ),
                          ),
                          Expanded(
                            child: Text(
                              "Valid Upto",
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
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
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
                                                IconButton(
                                                  icon: Icon(Icons.remove_red_eye, size: 15, color: ColorsForApp.icon_owner,),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                MangerOldRateList(
                                                                    validFromDate: rateMasterData[index]["validfrom"],
                                                                    validUptoDate: rateMasterData[index]["validupto"])));
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
            )

        ),
      //  bottomNavigationBar: submitButton(),
      ),
    );
  }

  Widget submitButton() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: CommonButtonForAllApp(onPressed: (){

      }, title: 'New Price List',backgroundColor: ColorsForApp.app_theme_color_owner),
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
                            print("validFromDate-->$validFromDate");
                            DialogBuilder(context).showLoadingIndicator('');
                           // getItemListData(validFromDate!);

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
}
