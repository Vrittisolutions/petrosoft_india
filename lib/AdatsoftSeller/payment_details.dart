import 'package:petrosoft_india/Classes/appbar.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'farmer_home_page.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({Key? key}) : super(key: key);

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  dynamic paymentData;
  dynamic api;
  double totalDebit=0.0;
  @override
  void initState() {
    super.initState();
   api= getData();
  }
  getData() async {
    var _url = UT.APIURL! +
        "api/GeneralLdpr?shop=" +
        UT.shop_no! +
        "&date1="+UT.yearStartDate! +
        "&date2="+UT.yearEndDate! +
        "&acno="+UT.ClientAcno.toString();
    paymentData = await UT.apiDt(_url);
    for(int i=0;i<paymentData.length;i++){
      totalDebit+=paymentData[i]["debit"];
    }
    setState(() {});
    return paymentData;
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarWithoutTrailing(title: 'Payment Details',onPressed: (){
          UT.m['saledate']=UT.m['saledate'];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdatSellerHomePage()));
        },backgroundColor:UT.adatSoftSellerAppColor! ,),

        body: FutureBuilder(
          future: api,
              builder: (context,snapshot){
               if(snapshot.connectionState==ConnectionState.done && snapshot.hasData == true){
                 if(paymentData.length!=0) {
                   return Column(
                     children: [
                       const SizedBox(height: 10),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children:  const [
                           SizedBox(
                             width: 100,
                             child: Padding(
                               padding: EdgeInsets.all(8.0),
                               child: Text("Date",style:TextStyle(fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                             ),
                           ),
                           SizedBox(
                             width: 150,
                             child: Padding(
                               padding: EdgeInsets.all(8.0),
                               child: Text("Received Amount",style:TextStyle(fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                             ),
                           )
                         ],
                       ),
                       const Divider(thickness: 1.0,color: Colors.grey,),
                      Expanded(
                        child: ListView.builder(
                          itemCount:paymentData.length ,
                        itemBuilder: (context, index){
                            if(paymentData[index]["debit"]!=0){
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                       // height: 30,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(UT.dateMonthYearFormat(paymentData[index]["date"])),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                       // height: 30,
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(paymentData[index]["amount"].toStringAsFixed(2),textAlign: TextAlign.end,)
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(thickness: 1.0,color: Colors.grey,),
                                ],
                              );
                            }else{
                              return Container();
                            }


                        },
                        ),
                      ),
                     ],
                   );
                 }else{
                   return Center(child:Text("No data found!! ",style: UT.adatSoftSellerNoDataStyle));
                 }
               }
                return Center(child:CommonWidget.circularIndicator(),);
              },
            ),
        bottomNavigationBar: Container(
          alignment: Alignment.bottomCenter,
          height: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child:   Container(
                  height: 40,
                  color: UT.adatSoftSellerAppColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(alignment:Alignment.center,child: Text("Total Bal : \u{20B9}${totalDebit.toStringAsFixed(2)}",style: const TextStyle(fontSize:15,fontWeight: FontWeight.bold,color: Colors.white),)),
                    ],
                  ),
                ),//last one
              )
            ],
          ),
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
