import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/customer_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
class CouponDetails extends StatefulWidget {
  const CouponDetails({Key? key}) : super(key: key);
  @override
  _CouponDetailsState createState() => _CouponDetailsState();
}

class _CouponDetailsState extends State<CouponDetails> {
  List itemRatesData=[];
  List petroList=[];
  String? credVou;
  bool isLoading=true;
  dynamic api;
  @override
  void initState() {
    super.initState();
    api=getCouponList;
  }
  final List _users = [];
   getCouponList() async {
    for(int i=0;i<UT.couponData.length;i++){
      String formattedDate = DateFormat("dd-MM-yyyy").format(DateTime.parse(UT.couponData[i]["issue_dt"]));
        var p={
          "Issue Date":formattedDate,
          "Start No":UT.couponData[i]["coupon_st"].toStringAsFixed(0),
          "End No":UT.couponData[i]["coupon_end"].toStringAsFixed(0),
          "Use":UT.couponData[i]["use"].toString(),
          "Bal":UT.couponData[i]["balance"].toString(),
        };
        _users.add(p);
    }
    return _users;
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
        appBar: AppBar(title: Text('Coupon Details',),
        ),
        body: FutureBuilder(
            future: getCouponList(),
            builder: (context, snapshot) {
              if(snapshot.data!=null){
               return ListView.builder(
                    itemBuilder: (context, index) {
                      String formattedDate = DateFormat("dd-MM-yyyy").format(DateTime.parse(UT.couponData[index]["issue_dt"]));
                          return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 1.0,
                                spreadRadius: 1.0, //extend the shadow
                                offset: Offset(
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
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5,),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Issue Date: "+ formattedDate,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color:  UT.PetrosoftCustomerAppLightColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),

                                          ]),
                                    ),
                                    const SizedBox(height: 5,),
                                    Divider(
                                      color: Colors.orange.shade900,
                                      thickness: 1.0,
                                    ),
                                    const SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                             "Start No: "+UT.couponData[index]["coupon_st"].toStringAsFixed(0)+"  End No : "+UT.couponData[index]["coupon_end"].toStringAsFixed(0),
                                             style: StyleForApp.text_style_normal_16_black,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                      child: Row(
                                        children: [
                                          Text(
                                           "Use: "+ UT.couponData[index]["use"].toString() ,
                                            // CreditSaleData[index]["veh_no"].toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "Bal:  ${UT.couponData[index]["balance"].toString()} " ,
                                            // CreditSaleData[index]["veh_no"].toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue.shade900,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                  ]),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: UT.couponData.length);
              }else{
               return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100,),
                    Center(child:Text("No data found!!",style: UT.PetrosoftCustomerNoDataStyle))
                  ],
                );
              }

            }
        ),
      ),
    );
  }
  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return const PetrosoftCustomerHomePage();
    }));
    // return true if the route to be popped
  }
}
