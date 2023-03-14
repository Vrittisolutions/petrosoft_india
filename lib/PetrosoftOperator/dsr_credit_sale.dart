import 'dart:convert';

import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/add_credit_sale.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/PetrosoftOperator/dsr_add_credit_sale.dart';
import 'package:petrosoft_india/PetrosoftOperator/operator_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class DsrCreditSale extends StatefulWidget {
  const DsrCreditSale({Key? key}) : super(key: key);

  @override
  _DsrCreditSaleState createState() => _DsrCreditSaleState();
}

class _DsrCreditSaleState extends State<DsrCreditSale> {
  TextEditingController searchController = TextEditingController();
  List CreditSaleData=[];
  List searchSaleData=[];
  String? credVou;
  dynamic api;
  @override
  void initState() {
    super.initState();
    api=getData();
  }

  getData() async {
    // GetCredSLMobile(string myear, string mshop, string mdate, string mshift)
   /* var _url = UT.APIURL! +
        "api/CredSale/getCRSLList?year4crsllist=" +
        UT.curyear! +
        "&shop4crsllist=" +
        UT.shop_no! +
        "&date1=" +
        UT.m['saledate'].toString()+
        "&List_shift="+UT.m['shift'].toString()+
        "&cashCD="+UT.ClientAcno.toString();*/


    var _url = UT.APIURL! +
        "api/CredSale/GetCredSLMobile?myear=" +
        UT.curyear! +
        "&mshop=" +
        UT.shop_no! +"&mdate=${ UT.m["saledate"]}"+"&mshift=${UT.m['shift']}&acno=${UT.ClientAcno}";
    print("CreditSale_url-->$_url");
    CreditSaleData = await UT.apiDt(_url);
    print("CreditSaleData-->$CreditSaleData");
    searchSaleData=CreditSaleData;

    return true;
  }
  Future<bool?> _willPopCallback()async{
    UT.m['saledate']=UT.m['saledate'];
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return  const PetroSoftOperatorHomePage();
    }));
    // return true if the route to be popped
  }
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorsForApp.app_theme_color,
      statusBarBrightness: Brightness.dark,
    ));

    return WillPopScope(
      onWillPop: ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.orange[150],
        appBar: AppBar(title: const Text('Credit Sale ',),
            leading: IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PetroSoftOperatorHomePage()));
              },
              icon: const Icon(Icons.arrow_back),
            ),
            backgroundColor: ColorsForApp.appThemeColor),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        onChanged: (value) {
                          search(value);
                        },
                        controller: searchController,
                        decoration: const InputDecoration(
                            labelText: "Search",
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                      ),
                    ),
                  ),
                  FutureBuilder(
                      future: api,
                      builder: (context,snapshot){
                        print(snapshot.data);
                        if(snapshot.hasData){
                          return  ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {

                                return searchSaleData[index]["cred_vou"].toString()==""?Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 100,),
                                    Center(child:Text("No data found!!",style: UT.PetroOwnerNoDataStyle))
                                  ],
                                )
                                    :InkWell(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DsrAddCreditSale(mode:"Edit",selectedRow:searchSaleData[index])));
                                  },
                                  child: Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                          children:
                                          [
                                            Text(
                                                "${searchSaleData[index]["cred_vou"].toString()} - ${searchSaleData[index]["name"]}",
                                                maxLines: 2,
                                                style: StyleForApp.text_style_bold_16_operator_dark
                                            ),
                                            Divider(color: ColorsForApp.light_gray_color,),

                                            Row(
                                              children: [
                                                Text(
                                                    "Slip No : " ,
                                                    // CreditSaleData[index]["veh_no"].toString(),
                                                    style: StyleForApp.text_style_normal_13_black
                                                ),
                                                Text(
                                                    searchSaleData[index]["sale_memo"]!=""?searchSaleData[index]["sale_memo"].toString():"-",
                                                    style: StyleForApp.text_style_normal_14_black
                                                ),
                                                const SizedBox(width: 20,),
                                                Text(
                                                    "Coupon No : " ,
                                                    // CreditSaleData[index]["veh_no"].toString(),
                                                    style: StyleForApp.text_style_normal_13_black
                                                ),
                                                Text(
                                                    searchSaleData[index]["coupon_no"].toString(),
                                                    style: StyleForApp.text_style_normal_14_black
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                Text(
                                                    searchSaleData[index]["item_desc"] ,
                                                    // CreditSaleData[index]["veh_no"].toString(),
                                                    style: StyleForApp.text_style_normal_14_black
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Row(
                                              children: [
                                                Text(
                                                    searchSaleData[index]["qty_sold"].toStringAsFixed(2) ,
                                                    // CreditSaleData[index]["veh_no"].toString(),
                                                    style: StyleForApp.text_style_normal_14_black
                                                ),
                                                Text(
                                                    " X " ,
                                                    style: StyleForApp.text_style_bold_16_operator_dark
                                                ),
                                                Text(
                                                    "${searchSaleData[index]["rate"].toStringAsFixed(2)} " ,
                                                    // CreditSaleData[index]["veh_no"].toString(),
                                                    style: StyleForApp.text_style_normal_14_black
                                                ),
                                                Text(
                                                    "${searchSaleData[index]["amount"].toStringAsFixed(2)} " ,
                                                    // CreditSaleData[index]["veh_no"].toString(),
                                                    style: StyleForApp.text_style_bold_14_black
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Text(
                                                "${searchSaleData[index]["veh_no"]} - ${searchSaleData[index]['narration']}",
                                                style: StyleForApp.text_style_normal_14_owner
                                            )


                                          ]
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: searchSaleData.length);
                        }
                        return CommonWidget.circularIndicator();
                      })
                ],
              ),
            )

        ),
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          backgroundColor:  ColorsForApp.icon_operator,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => const DsrAddCreditSale(mode: "Add",selectedRow: {},)));
          },
          // isExtended: true,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  void search(String query) {
    if (query.isEmpty) {
      searchSaleData=CreditSaleData;
      setState(() {});
      return;
    }

    query = query.toLowerCase();
    print(query);
    List result = [];
    for (var p in searchSaleData) {
      var name = p["name"].toString().toLowerCase();
      if (name.contains(query)) {
        result.add(p);
      }
    }

    searchSaleData = result;
    setState(() {});
  }
}
