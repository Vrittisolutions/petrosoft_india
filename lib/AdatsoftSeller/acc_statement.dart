import 'package:petrosoft_india/AdatsoftSeller/farmer_home_page.dart';
import 'package:petrosoft_india/AdatsoftSeller/periodic_bill1.dart';
import 'package:petrosoft_india/PetrosoftCustomer/customer_home_page.dart';
import 'package:petrosoft_india/PetrosoftCustomer/periodic_bill.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AdatSellerAccStatement extends StatefulWidget {
  const AdatSellerAccStatement({Key? key}) : super(key: key);
  @override
  _AdatSellerAccStatementState createState() => _AdatSellerAccStatementState();
}

class _AdatSellerAccStatementState extends State<AdatSellerAccStatement> {
  String _selectedFromDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(UT.yearStartDate!));
  String _selectedToDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(UT.yearEndDate!));
  dynamic accStatementData;
  double totalCredit=0.0;
  double totalDebit=0.0;
  double totalBal=0.0;
  dynamic api;
  @override
  void initState() {
    super.initState();
    api=getData();
  }
  getData() async {
    // CustList = GetURLDt(APIURL + "/api/CustLdpr/GetLdgr?curyear=" + Setup("curyear") + "&shop=" + Firm("Shop") + "&custprefix=" + AC("CustPrefix") + "&getPrint=false" );
    var _url = UT.APIURL! +
        "api/GeneralLdpr?shop=" +
        UT.shop_no! +
        "&date1="+UT.yearStartDate! +
        "&date2="+UT.yearEndDate! +
        "&acno="+UT.ClientAcno.toString();
    accStatementData = await UT.apiDt(_url);
   Map totalBal1=accStatementData.last;
    totalBal=totalBal1["balance"];
    for(int i=0;i<accStatementData.length;i++){
      totalCredit+=accStatementData[i]["credit"];
      totalDebit+=accStatementData[i]["debit"];
    }
    setState(() {});
    return accStatementData;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
      //  backgroundColor: Colors.pink[50],
        appBar: AppBar(
          backgroundColor: UT.adatSoftSellerAppColor,
          titleSpacing: 0.0,
          leading: IconButton(
            onPressed: (){
              //Navigator.pop(context);
               Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const AdatSellerHomePage()));
            },
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
          ),
          actions: [
            IconButton(
              onPressed: (){
                pickDateDialog(context);
              },
              icon: const Icon(Icons.calendar_today_outlined,color: Colors.white,),
            ),
          ],
          title: const CommonAppBarText(title: "Account Statement"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: api,
                  builder: (context,snapshot){
                   if(snapshot.hasData){
                     if(accStatementData.length!=0) {
                       return ListView.builder(
                           itemBuilder: (context, index) {
                             String formattedDate = DateFormat("dd-MM-yyyy").format(DateTime.parse(accStatementData[index]["date"]));
                             return Card(
                               elevation: 2,
                               child: Padding(
                                 padding: const EdgeInsets.all(0.0),
                                child: ExpansionTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                  Row(
                                  children: [
                                  const Icon(Icons.calendar_today_outlined,color: Colors.black,size: 18,),
                                  const SizedBox(width: 5,),
                                  Text(formattedDate.toString(),
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        //fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  ],
                                ),
                                 Row(
                                     children: [
                                 Text(
                                 "\u{20B9}${accStatementData[index]["amount"].toStringAsFixed(2)}",
                                 // CreditSaleData[index]["veh_no"].toString(),
                                 style: const TextStyle(
                                     fontWeight: FontWeight.bold,
                                     fontSize: 16,
                                     color: Colors.black
                                 ),
                                 ),
                                 const SizedBox(width: 1,),
                                 Text(accStatementData[index]["debit"]==0?"Cr":"Dr",
                                 // CreditSaleData[index]["veh_no"].toString(),
                                 style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     fontSize: 16,
                                     color:accStatementData[index]["debit"]==0? Colors.green:Colors.red[900]
                                 ),
                                 ),
                                     ]
                               )
                                   ]
                               ),
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        accStatementData[index]["desc_"].toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                     /* trailing:accStatementData[index]["debit"]==0?Container(
                                        width: 90,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [Colors.green.shade600, Colors.green.shade900],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius: BorderRadius.circular(20.0)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 0.0,right:0.0),
                                          child: TextButton(
                                            onPressed:(){
                                              if(accStatementData[index]["jfoliono"].contains("PS")){
                                                var newBillNo = accStatementData[index]["jfoliono"].substring(accStatementData[index]["jfoliono"].length - 5);
                                                print(newBillNo);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdatPeriodicBillDetails(billNo:newBillNo)));
                                              }else{
                                                Fluttertoast.showToast(msg: "bill not found");
                                              }

                                            },
                                            child:  const Text(
                                              "Patti Details",
                                              style: TextStyle(fontSize:13,color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ):const SizedBox(height: 0,width: 0,),*/
                                    )
                                  ],
                                ),

                               ),
                             );
                           },
                           itemCount: accStatementData.length);
                     }else{
                       return Center(child:Text("No data found!! ",style: UT.adatSoftSellerNoDataStyle,));
                     }
                   }
                    return Center(child: CommonWidget.circularIndicator(),);
                  },
                )
          ),
        ),
        bottomNavigationBar: Container(
          alignment: Alignment.bottomCenter,
          height: 77,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child:  Container(
                    height: 40,
                    color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Total Cr : \u{20B9}${totalCredit.toStringAsFixed(2)}",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold,color:UT.adatSoftSellerAppColor),),
                        const SizedBox(width: 10,),
                        Text("Dr : \u{20B9}${totalDebit.toStringAsFixed(2)}",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold,color:UT.adatSoftSellerAppColor),),
                        const SizedBox(width: 5,),
                      ],
                    ),
                  ), //last one
                ),
              ),
          Align(
            alignment: Alignment.bottomCenter,
            child:   Container(
              height: 36,
              color: UT.adatSoftSellerAppColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(alignment:Alignment.center,child: Text("Bal : \u{20B9}${totalBal.toStringAsFixed(2)}",style: const TextStyle(fontSize:15,fontWeight: FontWeight.bold,color: Colors.white),)),
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
  Future<void> _selectFromDate(BuildContext context,StateSetter setState2) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015,8),
      lastDate: DateTime(2101),
    );
    if (d != null) {
      setState2(() {
       // _selectedFromDate = new DateFormat.yMMMMd("en_US").format(d);
        _selectedFromDate = DateFormat("yyyy-MM-dd").format(d);
      });
    }
  }
  Future<void> _selectToDate(BuildContext context,StateSetter setState1) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015,8),
      lastDate: DateTime(2101),
    );
    if (d != null) {
      setState1(() {
        _selectedToDate =  DateFormat("yyyy-MM-dd").format(d);
        //_selectedToDate = new DateFormat.yMd().format(d);
      });
    }
  }
  pickDateDialog(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context,StateSetter setState1){
             return AlertDialog(
                title:  const Text('Pick Dates'),
                content: SizedBox(
                    height: MediaQuery.of(context).size.height*0.3,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 45,width: 200,
                                decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(width: 1.0, color: Colors.black),
                                      left: BorderSide(width: 1.0, color: Colors.black),
                                      right: BorderSide(width: 1.0, color: Colors.black),
                                      bottom: BorderSide(width: 1.0, color: Colors.black),
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
                                        child: Text(
                                            _selectedFromDate,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Color(0xFF000000))
                                        ),
                                        onTap: (){
                                            _selectFromDate(context,setState1);
                                            },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: (){
                                          _selectFromDate(context,setState1);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 45,width:200,
                                decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(width: 1.0, color: Colors.black),
                                      left: BorderSide(width: 1.0, color: Colors.black),
                                      right: BorderSide(width: 1.0, color: Colors.black),
                                      bottom: BorderSide(width: 1.0, color: Colors.black),
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
                                        child: Text(
                                            _selectedToDate,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: Color(0xFF000000))
                                        ),
                                        onTap: (){
                                          _selectToDate(context,setState1);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed:(){
                                          _selectToDate(context,setState1);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ])
                ),
                actions: <Widget>[
                  Container(
                    height: 30,
                    width: 70,
                    color: Colors.grey.shade100,
                    child: TextButton(
                      child: const Text('Cancel',
                          style: TextStyle(
                            color: Colors.black,
                          )),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Container(
                    height: 30,
                    width: 70,
                    color: UT.adatSoftSellerAppColor,
                    child: TextButton(
                      child: const Text('Ok',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        UT.yearStartDate=_selectedFromDate;
                        UT.yearEndDate=_selectedToDate;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AdatSellerAccStatement()));

                      },
                    ),
                  ),
                ],
              );
            }
          );
        });
  }
}
