
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/customer_home_page.dart';
import 'package:petrosoft_india/PetrosoftCustomer/periodic_bill.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AccountStatement extends StatefulWidget {
  const AccountStatement({Key? key}) : super(key: key);
  @override
  _AccountStatementState createState() => _AccountStatementState();
}

class _AccountStatementState extends State<AccountStatement> {
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
        "api/GeneralLdpr?cyr=${UT.curyear}&shop=" +
        UT.shop_no! +
        "&date1="+UT.yearStartDate! +
        "&date2="+UT.yearEndDate! +
        "&acno="+UT.ClientAcno.toString();
    print(_url);
    accStatementData = await UT.apiDt(_url);

    print(accStatementData);

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
      //  backgroundColor: Colors.pink[50],
        appBar: AppBar(
          backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
          title: Text('Account Statement',),),
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
                                  Icon(Icons.date_range,color:ColorsForApp.icon, size: 15,),
                                  const SizedBox(width: 5,),
                                  Text(formattedDate.toString(),
                                    maxLines: 2,
                                    style: StyleForApp.text_style_normal_14_black,
                                  ),
                                  ],
                                ),
                                 Row(
                                     children: [
                                 Text(
                                 "\u{20B9}${accStatementData[index]["amount"].toStringAsFixed(2)}",
                                 // CreditSaleData[index]["veh_no"].toString(),
                                 style: StyleForApp.text_style_bold_14_grn,
                                 ),
                                  SizedBox(width: 5,),
                                 Text(accStatementData[index]["debit"]==0?"Cr":"Dr",
                                 // CreditSaleData[index]["veh_no"].toString(),
                                 style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     fontSize: 14,
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
                                      trailing:accStatementData[index]["debit"]!=0?Container(
                                        width: 80,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [ColorsForApp.app_theme_color, ColorsForApp.icon],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                            borderRadius: BorderRadius.circular(20.0)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 0.0,right:0.0),
                                          child: TextButton(
                                            onPressed:(){
                                              if(accStatementData[index]["jfoliono"].contains("PERB")){
                                                var newBillNo = accStatementData[index]["jfoliono"].substring(accStatementData[index]["jfoliono"].length - 5);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PeriodicBillDetails(billNo:newBillNo)));
                                              }else{
                                                Fluttertoast.showToast(msg: "bill not found");
                                              }

                                            },
                                            child:   Text(
                                              "Bill Details",
                                              style: StyleForApp.text_style_normal_13_white,
                                            ),
                                          ),
                                        ),
                                      ):const SizedBox(height: 0,width: 0,),
                                    )
                                  ],
                                ),

                               ),
                             );
                           },
                           itemCount: accStatementData.length);
                     }else{
                       return Center(child:Text("No data found!! ",style: UT.PetrosoftCustomerNoDataStyle,));
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
                    color: ColorsForApp.app_theme_color_light_drawer,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Total Cr : \u{20B9}${totalCredit.toStringAsFixed(2)}",style: StyleForApp.text_style_bold_14_grn),
                        const SizedBox(width: 10,),
                        Text("Dr : \u{20B9}${totalDebit.toStringAsFixed(2)}",style: StyleForApp.text_style_bold_14_grn),
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
              color: ColorsForApp.appThemeColorPetroCustomer,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(alignment:Alignment.center,child: Text("Bal : \u{20B9}${totalBal.toStringAsFixed(2)}",style:StyleForApp.text_style_bold_14_white)),
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
      return const PetrosoftCustomerHomePage();
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
                title:  Text('Pick Dates',style: TextStyle(color:UT.PetrosoftCustomerDarkColor),),
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
                    color: UT.PetrosoftCustomerDarkColor,
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
                                builder: (context) => const AccountStatement()));
                       //  _selectedFromDate = 'Select From date';
                         //_selectedToDate   = 'Select To date  ';

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
