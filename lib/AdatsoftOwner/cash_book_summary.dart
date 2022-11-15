import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/custome_downloader.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CashBookSummary extends StatefulWidget {
  const CashBookSummary({Key? key}) : super(key: key);

  @override
  _CashBookSummaryState createState() => _CashBookSummaryState();
}

class _CashBookSummaryState extends State<CashBookSummary> {
  dynamic cardSaleData;
  bool isLoading=true;
  String? dSrno;
  int count=0;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    //GetURLDt(APIURL + "/api/CashBKSum?shop=" + Firm("shop") + "&getPrint=false");
    var _url = UT.APIURL! +
        "api/CashBKSum?shop=" +
        UT.shop_no! +
        "&getPrint=false";
    cardSaleData = await UT.apiDt(_url);
    print("cashBook-->$cardSaleData");

      return cardSaleData;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(iconTheme: const IconThemeData(color: Colors.white),title: const CommonAppBarText(title: 'Cash Book',), backgroundColor: ColorsForApp.appThemeColorAdatOwner),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: getData(),
           builder: (context,snapshot){
             if(snapshot.hasData) {
               if (cardSaleData.length!=0) {
                 return Column(
                   children: [
                   /*  Container(
                       height: 50,
                       color: ColorsForApp.app_theme_color_light_owner,
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children:   const [
                           SizedBox(
                            // width: 140,
                             child: Padding(
                               padding: EdgeInsets.all(8.0),
                               child: Text("Date",style:TextStyle(color:Colors.white,fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                             ),
                           ),
                           Padding(
                             padding: EdgeInsets.all(8.0),
                             child: Text("Opening",style:TextStyle(color:Colors.white,fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.end),
                           ),
                           SizedBox(
                             //width: 50,
                             child: Padding(
                               padding: EdgeInsets.all(8.0),
                               child: Text("Receipt",style:TextStyle(color:Colors.white,fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                             ),
                           ),
                           SizedBox(
                             //width: 50,
                             child: Padding(
                               padding: EdgeInsets.all(8.0),
                               child: Text("Payment",style:TextStyle(color:Colors.white,fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                             ),
                           ),
                           SizedBox(
                             //width: 50,
                             child: Padding(
                               padding: EdgeInsets.all(8.0),
                               child: Text("Bal",style:TextStyle(color:Colors.white,fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                             ),
                           ),
                         ],
                       ),
                     ),*/
                     Expanded(child: SingleChildScrollView(
                       scrollDirection: Axis.vertical,
                       child: SingleChildScrollView(
                         scrollDirection: Axis.horizontal,
                         child: DataTable(headingRowHeight: 45,

                 // horizontalMargin: double.maxFinite,
                 headingRowColor: MaterialStateColor
                         .resolveWith(
                         (states) => ColorsForApp.appThemeColorAdatOwner),
             columns: const <DataColumn>[

             DataColumn(label: Text("Date",style: TextStyle(color: Colors.white),)),
             // DataColumn(label: Text("Unit",style: TextStyle(color: Colors.white),)),
             DataColumn(label: Text("Opening",textAlign:TextAlign.end,style: TextStyle(color: Colors.white),)),

               DataColumn(label: Text("Receipt",style: TextStyle(color: Colors.white),)),
               // DataColumn(label: Text("Unit",style: TextStyle(color: Colors.white),)),
               DataColumn(label: Text("Payment",textAlign:TextAlign.end,style: TextStyle(color: Colors.white),)),
               DataColumn(label: Text("Bal",textAlign:TextAlign.end,style: TextStyle(color: Colors.white),)),
             ],
             rows: List<DataRow>.generate(
               cardSaleData.length,
             (index) => DataRow(
             color: MaterialStateProperty.resolveWith<Color>(
             (Set<MaterialState> states) {
             // Even rows will have a grey color.
             if (index % 2 == 0)
             return Colors.white.withOpacity(0.3);
             Divider(color: Colors.grey,);
             return Colors.white; // Use default value for other states and odd rows.
             }),
             cells: <DataCell>[

             DataCell(
                 InkWell(
                   onTap: (){
                     var _url = UT.APIURL! +
                         "api/DayBook?shop=" +
                         UT.shop_no.toString()+
                         "&date="+"${UT.yearMonthDateFormat(cardSaleData[index]["date"])}"+"&withbank=Yes"+"&onlysum=No"+"&getPrint=true";
                     Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) =>
                                 DownloadFile(url:_url, child: Container(),)));
                   },
                   child: Text(UT.dateMonthYearFormat(cardSaleData[index]["date"])
                   ),
                 )
             ),
             // DataCell(Text(petroList[index]["pur_unit"].toString())),
             DataCell(Text(cardSaleData[index]["opening"].toString(),textAlign:TextAlign.end)),
             DataCell(Text(cardSaleData[index]["credit"].toString(),textAlign:TextAlign.end)),
             DataCell(Text(cardSaleData[index]["debit"].toString(),textAlign:TextAlign.end)),
             DataCell(Text(cardSaleData[index]["balance"].toString(),textAlign:TextAlign.end))
             ]
             ),


             )
                    /* ListView.builder(
                             shrinkWrap: true,
                             itemBuilder: (context, index) {
                               return InkWell(
                                 onTap: (){
                                   Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                           builder: (context) =>
                                               CashBookReport(selectedDate:UT.yearMonthDateFormat(cardSaleData[index]["date"]))));
                                 },
                                 child: Padding(
                                   padding: const EdgeInsets.only(top: 8.0),
                                   child: Container(
                                     // height: 100.0,
                                     margin: const EdgeInsets.only(left: 5.0),
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
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Padding(padding: EdgeInsets.only(left: 5, top: 7, bottom: 7,right: 5),
                                           child: Column(
                                             mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Padding(
                                                 padding: const EdgeInsets.all(3.0),
                                                 child: Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [

                                                     Row(
                                                       children: [
                                                         Text(
                                                             "Date: "+UT.dateMonthYearFormat(cardSaleData[index]["date"],),
                                                             style:StyleForApp.text_style_normal_14_black
                                                         ),
                                                       ],
                                                     )
                                                   ],
                                                 ),
                                               ),
                                               Padding(
                                                 padding: const EdgeInsets.all(3.0),
                                                 child: Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Row(
                                                       children: [
                                                         Text(
                                                             "Opening: "+cardSaleData[index]["opening"].toStringAsFixed(2),
                                                             style:StyleForApp.text_style_normal_14_black
                                                         ),

                                                       ],
                                                     ),
                                                     Row(
                                                       children: [
                                                         Text(
                                                             "Receipt: "+cardSaleData[index]["debit"].toStringAsFixed(2)
                                                                 .toString(),
                                                             style: StyleForApp.text_style_normal_14_black
                                                         ),
                                                       ],
                                                     )
                                                   ],
                                                 ),
                                               ),
                                               Padding(
                                                 padding: const EdgeInsets.all(3.0),
                                                 child: Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Row(
                                                       children: [
                                                         Text(
                                                             "Payment: "+cardSaleData[index]["credit"].toStringAsFixed(2),
                                                             style:StyleForApp.text_style_normal_14_black
                                                         ),

                                                       ],
                                                     ),
                                                     Row(
                                                       children: [
                                                         Text(
                                                             "Balance: "+cardSaleData[index]["balance"].toStringAsFixed(2)
                                                                 .toString(),
                                                             style: StyleForApp.text_style_normal_14_black
                                                         ),
                                                       ],
                                                     )
                                                   ],
                                                 ),
                                               )
                                             ],
                                           ),),
                                       ],
                                     ),
                                   ),
                                 ),
                               );
                             },
                             itemCount: cardSaleData.length)*/
                         ),
                       ),
                     )
                    )
                 ]
                 );
                
               } else{
                 return Center(
                     child:Text("No card sale data found!!",style: UT.PetroOwnerNoDataStyle,));
               }
             }else{
               return Center(child: CommonWidget.circularIndicator());
             }

           },
          )

        ),
      ),

    );
  }
}
