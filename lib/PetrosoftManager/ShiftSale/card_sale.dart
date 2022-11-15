import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/save_card_sale.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ManagerCreditCardSale extends StatefulWidget {
  const ManagerCreditCardSale({Key? key}) : super(key: key);

  @override
  _ManagerCreditCardSaleState createState() => _ManagerCreditCardSaleState();
}

class _ManagerCreditCardSaleState extends State<ManagerCreditCardSale> {
  dynamic cardSaleData;
  bool isLoading=true;
  String? dSrno;
  int count=0;

  var cardList;
  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    await  getCardList();
    var _url = UT.APIURL! +
        "api/PumpTrnE/CardData?shopno=" +
        UT.shop_no! +
        "&curyear=" +
        UT.curyear! +
    "&Where=dsr_no%3D"+UT.m["slipNoOld"].toString()+"order by bsrno&Addrow=true";
    cardSaleData = await UT.apiDt(_url);
   // print("cardSaleData-->$cardSaleData");
   return cardSaleData;

  }
  var colors1 = [
    Colors.indigo.shade400,
    Colors.indigo.shade500,
    Colors.indigo.shade600,
    Colors.indigo.shade700,
    Colors.indigo.shade800,
    Colors.indigo.shade900,
  ];
  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return  const ManagerShiftSalePage();
    }));
    // return true if the route to be popped
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
       // backgroundColor: Colors.indigo.shade100,
        appBar: AppBar(title:  Text('Card Sale',style: PetroSoftTextStyle.style17White,),
            leading: IconButton(
              highlightColor: Colors.white,
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ManagerShiftSalePage()));
              },
              icon: const Icon(Icons.arrow_back),
            ),
            backgroundColor: ColorsForApp.app_theme_color_manager),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: FutureBuilder(
                future: getData(),
               builder: (context,snapshot){
                 if(snapshot.hasData) {
                   if(cardSaleData[0]["dsr_no"]!=""){
                     return ListView.builder(
                         itemBuilder: (context, index) {
                           count=index+1;
                           if(cardSaleData[index]["dsr_no"]!="") {
                            var _cardName = UT.GetRow(cardList, "acno", cardSaleData[index]['acno'].trim(),'name');
                             print("cardNN-->$_cardName");
                             return InkWell(
                               onTap: (){
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (context) =>
                                          ManagerSaveCardSale(mode:"Edit",selectedRow:cardSaleData[index])));
                               },
                               child: Stack(
                                 children: [
                                   Container(
                                    // height: 140.0,
                                     margin: const EdgeInsets.only(left: 25.0),
                                     child: Card(
                                         elevation: 3,
                                        // color: ColorsForApp.app_theme_color_light_owner_drawer,
                                         child:
                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment
                                               .start,
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           children: [
                                             Column(
                                               children: [
                                                 Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: [
                                                     Expanded(

                                                       child: Padding(
                                                         padding: EdgeInsets.only(
                                                           left: 15, top: 7),
                                                         child: Text(_cardName,
                                                           style: StyleForApp
                                                               .text_style_bold_16_owner_dark,),),
                                                     ),
                                                     Padding(
                                                       padding: EdgeInsets.only(
                                                         left: 10, top: 7,right: 6),
                                                       child: Text('Amount',
                                                         style: StyleForApp
                                                             .text_style_normal_12_black,),),
                                                   ],
                                                 ),
                                                 Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: [
                                                     Row(
                                                       children: [
                                                         Padding(
                                                           padding: const EdgeInsets.only(left: 25.0,top: 8),
                                                           child: Text(
                                                               "DSR No: " +
                                                                   cardSaleData[index]["dsr_no"],
                                                               maxLines: 2,
                                                               style: StyleForApp
                                                                   .text_style_normal_14_black
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     Padding(
                                                       padding: EdgeInsets.only(left: 15,right: 4),
                                                       child: Padding(
                                                         padding: EdgeInsets.only(
                                                             left: 15, top: 7),
                                                         child: Text("\u{20B9}"+cardSaleData[index]["bamount"].toStringAsFixed(2),
                                                           style: PetroSoftTextStyle
                                                               .style16AppColor,),),),
                                                   ],
                                                 )
                                               ],
                                             ),

                                             Padding(padding: EdgeInsets.only(
                                                 left: 25,
                                                 top: 7,
                                                 bottom: 7,
                                                 right: 10),
                                               child: Column(
                                                 mainAxisAlignment: MainAxisAlignment
                                                     .start,
                                                 crossAxisAlignment: CrossAxisAlignment
                                                     .start,
                                                 children: [

                                                   Divider(color: ColorsForApp
                                                       .light_gray_color,),
                                                   //SizedBox(height: 7,),
                                                   Row(
                                                     mainAxisAlignment: MainAxisAlignment
                                                         .spaceBetween,
                                                     crossAxisAlignment: CrossAxisAlignment
                                                         .start,
                                                     children: [
                                                       Text(
                                                           "Batch No: " +
                                                               cardSaleData[index]["bat_no"]
                                                                   .toString()
                                                                   .replaceAll(
                                                                   ".0", " ")
                                                                   .toString(),
                                                           style: StyleForApp
                                                               .text_style_normal_14_black
                                                       ),
                                                       Row(
                                                         children: [
                                                           Text(
                                                             " Date: " + UT
                                                                 .dateMonthYearFormat(
                                                                 cardSaleData[index]["dsr_date"]),
                                                           ),
                                                         ],
                                                       )
                                                     ],
                                                   ),
                                                   SizedBox(height: 4,),
                                                   Text(
                                                       "Mode: " +
                                                           cardSaleData[index]["mode"]
                                                               .toString(),
                                                       style: StyleForApp
                                                           .text_style_normal_14_black
                                                   ),
                                                 ],
                                               ),),
                                           ],
                                         )
                                     ),
                                   ),
                                   Container(
                                     // color: colors1[index],
                                     height: 100.0,
                                     margin: const EdgeInsets.symmetric(
                                         vertical: 20.0
                                     ),
                                     alignment: FractionalOffset.centerLeft,
                                     child: CircleAvatar(
                                       backgroundColor: ColorsForApp.appThemeColor,
                                       radius: 25,
                                       child: Text(
                                         count.toString(), style: const TextStyle(
                                           color: Colors.white),),
                                     ),
                                   ),
                                 ],
                               ),
                             );
                           }else{
                             return Center(
                                 child:Text("No card sale data found!!",style: UT.PetroOwnerNoDataStyle,));
                           }
                         },
                         itemCount: cardSaleData.length);
                   }else{
                     return Center(
                         child:Text("No card sale data found!!",style: UT.PetroOwnerNoDataStyle,));
                   }


                 }else{
                   return Center(child: CommonWidget.circularIndicator());
                 }

               },
              ),
            )

          ),
        ),
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          backgroundColor: ColorsForApp.appThemeColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ManagerSaveCardSale(mode: "Add",selectedRow: {},)));
          },
          // isExtended: true,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  getCardList() async {

    var _url = UT.APIURL! +
        "api/AccountMaster/GetAcMast?curyear="+UT.curyear!+
        "&shop=" +
        UT.shop_no! +
        "&Where=acno%20like%20'" + UT.AC("swapmcac") + "%%27%20and%20acno!=%27" + UT.AC("swapmcac") + "'";
    cardList = await UT.apiDt(_url);

  }
}
