
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/account_statement.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'customer_home_page.dart';
import 'image_list.dart';
class PeriodicBillDetails extends StatefulWidget {
  final String billNo;
  const PeriodicBillDetails({Key? key, required this.billNo}) : super(key: key);

  @override
  _PeriodicBillDetailsState createState() => _PeriodicBillDetailsState();
}

class _PeriodicBillDetailsState extends State<PeriodicBillDetails> {
  var BillListData;
  var api;
  getData() async {
    var _url = UT.APIURL! +
        "api/CredSale/getBillData?year4bill=" +
        UT.curyear! +
        "&shop4bill=" +
        UT.shop_no! +
        "&bill_no=${widget.billNo}";

    BillListData = await UT.apiDt(_url);

    return BillListData;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api=getData();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorsForApp.app_theme_color,
      statusBarBrightness: Brightness.dark,
    ));



    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.orange[150],
        appBar: AppBar(title: Text('Periodic Bill Details',),),
        body: Padding(
            padding: EdgeInsets.all(7),
            child: FutureBuilder(
              future: api,
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: ScrollController(),
                    itemCount: BillListData.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(BillListData[index]["cred_vou"]==""){
                        return Center(child:Text("No data found!! ",style: UT.PetrosoftCustomerNoDataStyle,));
                      }else{
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade100,
                                  blurRadius: 1.0,
                                  spreadRadius: 1.0, //extend the shadow
                                  offset: const Offset(
                                    3.0, // Move to right 10  horizontally
                                    3.0, // Move to bottom 5 Vertically
                                  ),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(7),
                              child: Center(
                                child: Column(children: [

                                  Row(children:
                                  [
                                    Expanded(
                                        child: Text(
                                            "Date: " +
                                          UT.dateMonthYearFormat(BillListData[index]["date"]),
                                          style: StyleForApp.text_style_normal_14_black
                                        )),
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                          children: [
                                            Text(
                                              "Voucher No: " +
                                                  BillListData[index]["cred_vou"],
                                          style: StyleForApp.text_style_normal_14_black),

                                          ],
                                        )),
                                  ]),
                                  const SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                            BillListData[index]["item_desc"],
                                              style: StyleForApp.text_style_normal_14_black
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                            "Quantity : " + "${BillListData[index]["qty_sold"]}",
                                            style: const TextStyle(
                                              //fontSize: 16,
                                            ),
                                          )),
                                      Expanded(
                                          child: Text(
                                            "Rate : " + "${BillListData[index]["rate"]}",
                                              style: StyleForApp.text_style_normal_14_black
                                          )),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                   children: [
                                     Expanded(
                                         child: Text(
                                           "Amount : " +
                                               "\u{20B9}${BillListData[index]["amount"].toStringAsFixed(2)}",
                                           style: StyleForApp.text_style_bold_14_grn
                                         )),
                                   ],
                                 ),
                                ]),
                              ),
                            ),
                          ),
                        );
                      }
                      },
                  );
                }
                return Center(child: CommonWidget.circularIndicator());
              },
            )),
      ),
    );

  }

  Future<bool?> _willPopCallback()async{return Navigator.of(context)
      .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
    return const AccountStatement();
  }));
    // return true if the route to be popped
  }
}

