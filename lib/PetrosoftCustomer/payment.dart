import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/customer_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'add_payment.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  dynamic paymentData;
  dynamic api;
  @override
  void initState() {
    super.initState();
   api= getData();
  }
  getData() async {
    var _url = UT.APIURL! +
        "api/getPetroCustData/getReceiptList?_year=" +
        UT.curyear! +
        "&_shop=" +
        UT.shop_no! +
        "&date1=" +
        UT.m['saledate'].toString()+
        "&custcode="+UT.ClientAcno.toString();
    paymentData = await UT.apiDt(_url);
    print(paymentData);
    return paymentData;
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
        appBar: AppBar(
          backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
          title: const Text('Payment to Pump',),),
        body: Center(
          child: Padding(padding: const EdgeInsets.all(7),
          child:  FutureBuilder(
            future: api,
            builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.done && snapshot.hasData == true){
                if(paymentData[0]["srno"]!="") {
                  return Padding(
                    padding: const EdgeInsets.only(top:7),
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
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
                                  child: Padding(padding: const EdgeInsets.all(7),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text( "Amt: \u{20B9}${paymentData[index]["amount"].toStringAsFixed(2)}", style: StyleForApp.text_style_bold_16_blue),
                                                const SizedBox(width: 5,),
                                                Icon(Icons.check_circle_rounded, color: ColorsForApp.icon,),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(paymentData[index]["srno"].toString(),
                                                    style: StyleForApp.text_style_normal_14_black),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[

                                            paymentData[index]["mode"]=="cash"? Container(alignment: Alignment.centerRight,child: Text("Mode: ${paymentData[index]["mode"]}", style: StyleForApp.text_style_normal_14_black)):Text("Mode: ${paymentData[index]["mode"]}", style: StyleForApp.text_style_normal_14_black),
                                            paymentData[index]["mode"]=="cheque"||paymentData[index]["mode"]=="RTGS"||paymentData[index]["mode"]=="Transfer"?Text("Cheque No: ${paymentData[index]["chqno"]}", style: StyleForApp.text_style_normal_14_black):Container()
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Bank Name: ${paymentData[index]["bank"]}", style:  StyleForApp.text_style_normal_14_black),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Row(
                                          children: [
                                            const Text('Date: ',),
                                            Text( UT.dateMonthYearFormat(paymentData[index]["date"].toString()),
                                                style: StyleForApp.text_style_normal_14_black),
                                          ],
                                        ),

                                      ],
                                    ),)
                                  ,),

                              ]
                          );
                        },
                        itemCount: paymentData.length),
                  );
                }else{
                  return Center(child:Text("No data found!! ",style: UT.PetrosoftCustomerNoDataStyle));
                }
              }
              return Center(child:CommonWidget.circularIndicator(),);
            },
          ),),

        ),

        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: const Icon(Icons.add),
          backgroundColor:ColorsForApp.appThemeColorPetroCustomer,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const AddPayment()));
          },
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
