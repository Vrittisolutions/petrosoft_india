import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'acc_statement.dart';

class AdatPeriodicBillDetails extends StatefulWidget {
  final String billNo;
  const AdatPeriodicBillDetails({Key? key, required this.billNo}) : super(key: key);

  @override
  _AdatPeriodicBillDetailsState createState() => _AdatPeriodicBillDetailsState();
}

class _AdatPeriodicBillDetailsState extends State<AdatPeriodicBillDetails> {
  dynamic billListData;
  dynamic api;
  getData() async {
    var _url = UT.APIURL! +
        "api/CredSale/getBillData?year4bill=" +
        UT.curyear! +
        "&shop4bill=" +
        UT.shop_no! +
        "&bill_no=${widget.billNo}";

    billListData = await UT.apiDt(_url);
    billListData=null;
    return billListData;
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
        appBar:  AppBar(
           backgroundColor: UT.adatSoftSellerAppColor,
          titleSpacing: 0.0,
          elevation: 4,
          title: const Text("Periodic Bill Details"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(0.0),
            ),
          ),

        ),
        body: Padding(
            padding: EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0,bottom: 15.0),
            child: FutureBuilder(
              future: api,
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: ScrollController(),
                    itemCount: billListData.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(billListData[index]["cred_vou"]==""){
                        return Center(child:Text("No data found!! ",style: UT.PetrosoftCustomerNoDataStyle,));
                      }else{
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
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
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Column(children: [
                                  Row(children: [
                                    Expanded(
                                        child: Text(
                                          UT.dateMonthYearFormat(billListData[index]["date"]),
                                          style:const TextStyle(
                                            // fontSize: 16,
                                          ),
                                        )),
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                          children: [
                                            Text(
                                              "Voucher No : " +
                                                  billListData[index]["cred_vou"],
                                              style:const TextStyle(
                                                //fontSize: 16,
                                              ),
                                            ),

                                          ],
                                        )),
                                  ]),
                                  const SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                            billListData[index]["item_desc"],
                                            style:const TextStyle(
                                             // color: UT.ownerAppColor,
                                              fontSize: 15,
                                            ),
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                            "Quantity : " + "${billListData[index]["qty_sold"]}",
                                            style: const TextStyle(
                                              //fontSize: 16,
                                            ),
                                          )),
                                      Expanded(
                                          child: Text(
                                            "Rate : " + "${billListData[index]["rate"]}",
                                            style: const TextStyle(
                                             // fontSize: 16,
                                            ),
                                          )),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                   children: [
                                     Expanded(
                                         child: Text(
                                           "Amount : " +
                                               "\u{20B9}${billListData[index]["amount"].toStringAsFixed(2)}",
                                           style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                             color: Colors.blue.shade700,
                                             fontSize: 15,
                                           ),
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
    return const AdatSellerAccStatement();
  }));
    // return true if the route to be popped
  }
}

