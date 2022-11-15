import 'package:petrosoft_india/AdatsoftSeller/add_memo.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/add_sales.dart';
import 'package:petrosoft_india/PetrosoftCustomer/customer_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'farmer_home_page.dart';
class MemoEntry extends StatefulWidget {
  const MemoEntry({Key? key}) : super(key: key);

  @override
  _MemoEntryState createState() => _MemoEntryState();
}

class _MemoEntryState extends State<MemoEntry> {
  dynamic memoEntryData;
  String? credVou;
  dynamic api;
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
    memoEntryData = await UT.apiDt(_url);
    print(memoEntryData["Message"]);

    if(memoEntryData.length==1||memoEntryData[0]["cred_vou"]==""||memoEntryData[0]["cred_vou"]==null) {
      return  memoEntryData=null;
      return Center(child:Text("No data found!! ",style:UT.adatSoftSellerNoDataStyle,));
    }else if(memoEntryData["Message"]=="An error has occurred."){
      return  memoEntryData=null;
      return Center(child:Text("No data found!! ",style:UT.adatSoftSellerNoDataStyle,));
    }else{
      return memoEntryData;
    }

  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: UT.adatSoftSellerAppColor,
          titleSpacing: 0.0,
          leading: IconButton(
            onPressed: (){
              //Navigator.pop(context);
              UT.m['saledate']=UT.m['saledate'];
               Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const AdatSellerHomePage()));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          iconTheme: StyleForApp.iconThemeData,
          title: const CommonAppBarText(title: "Memo Entry"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: api,
                  builder: (context,snapshot){
                    print(snapshot.data);
                    if (snapshot.data==null) {
                      return Center(child:Text("No data found!! ",style:UT.adatSoftSellerNoDataStyle,));

                      // if we got our data
                    }else if(snapshot.hasData){

                     if(memoEntryData.length!=1){
                       return Center(child:Text("No data found!! ",style:UT.adatSoftSellerNoDataStyle,));
                     }else{
                       if(memoEntryData.length!=1||memoEntryData[0]["cred_vou"]==""||memoEntryData[0]["cred_vou"]==null) {
                         return Center(child:Text("No data found!! ",style:UT.adatSoftSellerNoDataStyle,));
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
                                         memoEntryData[index]["isapproved"]=="Y"?  Container(
                                             width: 30,
                                             height: 30,
                                             margin: EdgeInsets.only(right: 10),
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
                                                 memoEntryData[index]["cred_vou"] +
                                                     " - " +
                                                     memoEntryData[index]["name"],
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
                                                       memoEntryData[index]["coupon_no"].toStringAsFixed(0),
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
                                                   Text(memoEntryData[index]["sale_memo"]
                                                       .toString() + " - " +
                                                       memoEntryData[index]["veh_no"]
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
                                                     memoEntryData[index]["item_desc"] +
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
                                                         memoEntryData[index]["qty_sold"]
                                                             .toString() + " X " +
                                                             "${memoEntryData[index]["rate"]
                                                                 .toString()} ",
                                                         // CreditSaleData[index]["veh_no"].toString(),
                                                         style: const TextStyle(
                                                           fontSize: 15,
                                                         ),
                                                       ),
                                                       Text(
                                                         "\u{20B9}${memoEntryData[index]["amount"]
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
                             itemCount: memoEntryData.length);
                       }

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
          backgroundColor: UT.adatSoftSellerAppColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const AddMemoEntry()));
          },
        ),
      ),
    );
  }
  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return const AdatSellerHomePage();
    }));
    // return true if the route to be popped
  }
}
