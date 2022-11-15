import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/manager_home_page.dart';
import 'package:petrosoft_india/PetrosoftManager/add_payment_entry.dart';
import 'package:petrosoft_india/PetrosoftManager/manager_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common_home_page.dart';
class ManagerPaymentEntry extends StatefulWidget {
  const ManagerPaymentEntry({Key? key}) : super(key: key);

  @override
  _ManagerPaymentEntryState createState() => _ManagerPaymentEntryState();
}

class _ManagerPaymentEntryState extends State<ManagerPaymentEntry> {
  dynamic paymentEntryData;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  getData() async {
    var _url = UT.APIURL! +
        "api/PayVou/getVouList4mobileApp?_year=" +
        UT.curyear! +
        "&_shop=" +
        UT.shop_no! +
        "&date=" +
        UT.m['saledate'].toString();
    paymentEntryData = await UT.apiDt(_url);
    return paymentEntryData;
  }
  Future<bool?> _willPopCallback()async{
    UT.m['saledate']=UT.m['saledate'];
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return const Dashboard();
    }));
    // return true if the route to be popped
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
       // backgroundColor: Colors.indigo.shade100,
        appBar: AppBar(title: const Text('Payment Entry',), backgroundColor: ColorsForApp.app_theme_color_owner),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: getData(),
             builder: (context,snapshot){
               if(snapshot.hasData){
                 return  ListView.builder(
                     itemBuilder: (context, index) {
                      if(paymentEntryData.length==1&&paymentEntryData[0]["srno"]==""){
                      return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      const SizedBox(height: 300,),
                      Center(
                      child:Text("No payment entry found!!",style: UT.PetroOwnerNoDataStyle,))
                      ],
                      );
                      }else {
                        return  Stack(
                          children: [
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddPaymentEntry(voucherNo:paymentEntryData[index]["srno"].padLeft(5,'0'),
                                                mode:"Edit",selectedRow:paymentEntryData[index])));
                              },
                              child: Card(
                                elevation: 3, color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                       Row(
                         children: [
                           Text('Amount: ', style: StyleForApp.text_style_bold_16_owner_dark,),
                       Text(
                       "\u{20B9}"+ paymentEntryData[index]["amount"].toStringAsFixed(2).toString(),
                       style: StyleForApp.text_style_bold_16_owner_dark
                       ),
                         ],
                       ),

                       Divider(color: ColorsForApp.light_gray_color,),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                       Text(
                       paymentEntryData[index]["srno"],
                       style: StyleForApp.text_style_normal_14_black
                       ),

                             ],
                           ),
                           Row(
                             children: [
                       Text(
                       paymentEntryData[index]["name"],
                       style: StyleForApp.text_style_normal_14_black
                       ),


                       ],
                           )
                         ],
                       )


                       /* Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: Text(
                                                  PaymentEntryData[index]["narration"],
                                                  style: TextStyle(
                                                    //   color: UT.ownerAppColor,
                                                    fontSize: 16,
                                                    // fontWeight: FontWeight.bold
                                                  ),
                                                )),
                                          ],
                                        ),*/
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                     },
                     itemCount: paymentEntryData.length);
               }
               return Center(child: CommonWidget.circularIndicator());
             },
            )

          ),
        ),
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: const Icon(Icons.add),
          backgroundColor: ColorsForApp.appThemePetroOwner,
          onPressed: () {
            getMaxNo();
          },
        ),
      ),
    );
  }
  getMaxNo()async{
    var _url = UT.APIURL! +
        "api/PayVou/GetMaxSrno?year=" +
        UT.curyear! +
        "&shop="+UT.shop_no.toString();
    var data = await UT.apiStr(_url);
    if(data!=null||data!=''){
     return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>  AddPaymentEntry(voucherNo: data.toString().padLeft(5,'0'),
                  mode:"Add",selectedRow: {})));
    }
  }
}
