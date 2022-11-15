
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'customer_home_page.dart';
import 'image_list.dart';
class AcceptRequest extends StatefulWidget {
  const AcceptRequest({Key? key}) : super(key: key);

  @override
  _AcceptRequestState createState() => _AcceptRequestState();
}

class _AcceptRequestState extends State<AcceptRequest> {
  TextEditingController newEndMeter =  TextEditingController();
  //Icons.food_bank_rounded;
  dynamic approveListData;
  dynamic api;
  getData() async {

     var _url = UT.APIURL! +
        "api/CredSale/getUnApproveSale?year4UnApproveSale=" +
        UT.curyear! +
        "&shop4UnApproveSale=" +
        UT.shop_no! +
        "&cust_code=${UT.ClientAcno}";
    approveListData = await UT.apiDt(_url);
    print(approveListData);
    return approveListData;
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
        appBar: AppBar(title: Text('Credit Sale',),),
        body: Padding(
            padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0,bottom: 15.0),
            child: FutureBuilder(
              future: api,
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: ScrollController(),
                    itemCount: approveListData.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(approveListData[index]["cred_vou"]==""){
                        return Center(child:Text("No data found!! ",style: UT.PetrosoftCustomerNoDataStyle,));
                      }else{
                        return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: ( context)=> ImageList(approveListData[index]["cred_vou"])));

                        },
                          child: Padding(
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
                                            UT.dateMonthYearFormat(approveListData[index]["date"]),
                                            style: const TextStyle(
                                              // fontSize: 16,
                                            ),
                                          )),
                                      Expanded(
                                          child: Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                            children: [
                                              Text(
                                                "Voucher No : " +
                                                    approveListData[index]["cred_vou"],
                                                style: const TextStyle(
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
                                              approveListData[index]["item_desc"],
                                              style: const TextStyle(
                                               // color: UT.ownerAppColor,
                                                fontSize: 15,
                                              ),
                                            )),
                                        Expanded(
                                            child: Text(
                                              "Vehicle No:${approveListData[index]["veh_no"]}",
                                              style: const TextStyle(
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
                                              "Quantity : " + "${approveListData[index]["qty_sold"].toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                //fontSize: 16,
                                              ),
                                            )),
                                        Expanded(
                                            child: Text(
                                              "Rate : " + "${approveListData[index]["rate"].toStringAsFixed(2)}",
                                              style: const TextStyle(
                                               // fontSize: 16,
                                              ),
                                            )),
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    Row(
                                     children: [
                                       Expanded(
                                           child: Text(
                                             "Amount : " +
                                                 "\u{20B9}${approveListData[index]["amount"].toStringAsFixed(2)}",
                                             style: TextStyle(
                                               fontWeight: FontWeight.bold,
                                               color: UT.PetrosoftCustomerDarkColor,
                                               fontSize: 15,
                                             ),
                                           )),
                                       const Expanded(
                                           child: Text(
                                             "Driver Name : ",
                                             style: TextStyle(
                                               // fontSize: 16,
                                             ),
                                           )),
                                     ],
                                   ),
                                  ]),
                                ),
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
    return const PetrosoftCustomerHomePage();
  }));
    // return true if the route to be popped
  }
}

