
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/PetrosoftCustomer/add_sales.dart';
import 'package:petrosoft_india/PetrosoftCustomer/customer_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class SalesOrders extends StatefulWidget {
  const SalesOrders({Key? key}) : super(key: key);

  @override
  _SalesOrdersState createState() => _SalesOrdersState();
}

class _SalesOrdersState extends State<SalesOrders> {
  var SalesOrderData;
  String? credVou;
   var api;
  @override
  void initState() {
    super.initState();
   api= getData();
  }

  getData() async {
    var _url = UT.APIURL! +
        "api/getPetroCustData/getCRSLList?year4crsllist=" +
        UT.curyear! +
        "&shop4crsllist=" +
        UT.shop_no! +
        "&date1=" +
        UT.m['saledate'].toString()+
    "&custcode="+UT.ClientAcno.toString();
    SalesOrderData = await UT.apiDt(_url);
    return SalesOrderData;
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
        appBar: AppBar(
          backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
          title: const Text('Sales Order',),),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: api,
                  builder: (context,snapshot){
                   if(snapshot.hasData){
                   if(SalesOrderData[0]["cred_vou"]==""||SalesOrderData[0]["cred_vou"]==null) {
                     return Center(child:Text("No data found!! ",style:UT.PetrosoftCustomerNoDataStyle,));
                     }else{
                     return ListView.builder(
                         itemBuilder: (context, index) {
                           // credVou=SalesOrderData[index]["cred_vou"].toString();
                           return  SizedBox(
                             height: 130,
                             width: double.infinity,
                             child:  Container(
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 // border: Border.all(),
                                 borderRadius: BorderRadius.circular(25),
                               ),
                               width: double.infinity,
                               height: 120,
                               margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                               child: Padding(
                                 padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                                 child: Row(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: <Widget>[
                                     SalesOrderData[index]["isapproved"]=="Y"?  Container(
                                         width: 30,
                                         height: 30,
                                         margin: const EdgeInsets.only(right: 10),
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(50),
                                           border: Border.all(width: 3, color: Colors.green.shade700),
                                         ),
                                         child:  Icon(
                                           Icons.check_circle,
                                           color: Colors.green.shade700,
                                           size: 20,
                                         )
                                     ):Container(
                                       width: 30,
                                       height: 30,
                                       margin: const EdgeInsets.only(right: 10),
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(50),
                                         border: Border.all(width: 3, color:Colors.orange.shade700),
                                       ),
                                       child:Icon(
                                         Icons.cancel,
                                         color: Colors.orange.shade700,
                                         size: 20,
                                       ),
                                     ),
                                     Expanded(
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: <Widget>[
                                           Text(
                                             SalesOrderData[index]["cred_vou"] +
                                                 " - " +
                                                 SalesOrderData[index]["name"],
                                             style: TextStyle(
                                                 color: UT.PetrosoftCustomerDarkColor,
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 18),
                                           ),
                                           const SizedBox(
                                             height: 6,
                                           ),
                                           Row(
                                             children: <Widget>[
                                               const Icon(
                                                 Icons.receipt,
                                                 color: Colors.black,
                                                 size: 20,
                                               ),
                                               const SizedBox(
                                                 width: 5,
                                               ),
                                               Text(
                                                   SalesOrderData[index]["coupon_no"].toStringAsFixed(0),
                                                   style: const TextStyle(
                                                       color: Colors.black, fontSize: 13,fontWeight: FontWeight.bold, letterSpacing: .3)),
                                             ],
                                           ),
                                           const SizedBox(
                                             height: 6,
                                           ),
                                           Row(
                                             children: <Widget>[
                                               const Icon(
                                                 Icons.directions_car,
                                                 color: Colors.black,
                                                 size: 20,
                                               ),
                                               const SizedBox(
                                                 width: 5,
                                               ),
                                               Text(SalesOrderData[index]["sale_memo"]
                                                   .toString() + " - " +
                                                   SalesOrderData[index]["veh_no"]
                                                       .toString(),
                                                   style: const TextStyle(
                                                       color: Colors.black, fontSize: 13, letterSpacing: .3)),
                                             ],
                                           ),
                                           const SizedBox(
                                             height: 6,
                                           ),
                                           Row(
                                             children: <Widget>[
                                               const Icon(
                                                 Icons.shopping_bag_outlined,
                                                 color: Colors.black,
                                                 size: 20,
                                               ),
                                               const SizedBox(
                                                 width: 3,
                                               ),
                                               Text(
                                                 SalesOrderData[index]["item_desc"] +
                                                     " ",
                                                 // CreditSaleData[index]["veh_no"].toString(),
                                                 style: const TextStyle(
                                                   // color: Colors.grey,
                                                   fontSize: 15,
                                                 ),
                                               ),
                                               Row(
                                                 children: [

                                                   Text(
                                                     SalesOrderData[index]["qty_sold"]
                                                         .toString() + " X " +
                                                         "${SalesOrderData[index]["rate"]
                                                             .toString()} ",
                                                     // CreditSaleData[index]["veh_no"].toString(),
                                                     style: const TextStyle(
                                                       fontSize: 15,
                                                     ),
                                                   ),
                                                   Text(
                                                     "\u{20B9}${SalesOrderData[index]["amount"]
                                                         .toStringAsFixed(2)}",
                                                     // CreditSaleData[index]["veh_no"].toString(),
                                                     style: TextStyle(
                                                         fontWeight: FontWeight.bold,
                                                         fontSize: 15,
                                                         color: Colors.blue.shade900
                                                     ),
                                                   )
                                                 ],
                                               ),
                                             ],
                                           ),
                                         ],
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             ),
                           );
                         },
                         itemCount: SalesOrderData.length);

                     }
                   }
                    return Center(child:CommonWidget.circularIndicator());
                  },
                )
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: const Icon(Icons.add),
          backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const AddSaleOrders()));
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
