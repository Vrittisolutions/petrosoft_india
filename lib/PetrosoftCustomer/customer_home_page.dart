import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/accept_request.dart';
import 'package:petrosoft_india/PetrosoftCustomer/account_statement.dart';
import 'package:petrosoft_india/PetrosoftCustomer/coupon_details.dart';
import 'package:petrosoft_india/PetrosoftCustomer/sales_order.dart';
import 'package:petrosoft_india/PetrosoftCustomer/vehicles.dart';
import 'package:petrosoft_india/PetrosoftOwner/widget/background.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common/widget/buyer_drawer.dart';
import 'payment.dart';
import 'item_rates.dart';

class PetrosoftCustomerHomePage extends StatefulWidget {
  const PetrosoftCustomerHomePage({Key? key}) : super(key: key);

  @override
  _PetrosoftCustomerHomePageState createState() => _PetrosoftCustomerHomePageState();
}
const simpleBehavior = true;
class _PetrosoftCustomerHomePageState extends State<PetrosoftCustomerHomePage> {

  String _salesOrders = "0.00";
  double _itemRates = 0;
  String _accStatement = "0.00";
  String _payment = "0.00";
  double _vehicles = 0;
  double _drivers = 0;
  double _unBilledBalance=0;
  num? couponCount;
  String? dSrNo;

  //Icons.food_bank_rounded;
  List<String> grids = [
    "Sales Orders",
    "Item Rates",
    "Account Statement",
    "Payment",
    "Vehicles",
    "Drivers",
    "Approve Fuel Filling"
  ];
  List gridsIcons = [
    Icons.memory,
    Icons.card_travel,
    Icons.credit_card_rounded,
    Icons.money,
    Icons.directions_car,
    Icons.person,
    Icons.add_task_outlined
  ];
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    if(UT.m['saledate']!=null){
      UT.m['saledate']=UT.m['saledate'];
    }else{
      convertedDateTime = "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')}";
      UT.m['saledate']=convertedDateTime;
    }
    resetVal();
    couponDetails();
  }
  String? convertedDateTime;

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorsForApp.app_theme_color,
      statusBarBrightness: Brightness.dark,
    ));


     convertedDateTime = "${selectedDate.day.toString().padLeft(2,"0")}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.year.toString().padLeft(2,'0')}";
     return WillPopScope(
      onWillPop:  ()async {
        exitAppDialog();
        return true;
      },
      child: Scaffold(
         // backgroundColor: Colors.orange[150],
          appBar: AppBar(
            backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
            title: Text(UT.firm_name!),),
          body: OwnerBackground(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
             // scrollDirection: Axis.horizontal,
              child: Column(
               // mainAxisAlignment: MainAxisAlignment.spaceAround,
               // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Container(
                           height: 50,
                           decoration: BoxDecoration(
                             //  border: Border.all(width:2,color: Color(0xFF003b4c)),
                             borderRadius: BorderRadius.circular(30.0),
                           ),
                           child: Padding(
                             padding: const EdgeInsets.all(5.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 InkWell(
                                     onTap: () async {
                                       // openDatePicker(context);
                                     },
                                     child: Row(
                                       children: [
                                         Padding(padding: EdgeInsets.only(left: 10),
                                         child: Row(
                                           children: [
                                             Icon(
                                               Icons.date_range_rounded,
                                               color: ColorsForApp.appThemeColorPetroCustomer,
                                             ),
                                             const SizedBox(
                                               width: 10,
                                             ),
                                             Text("$convertedDateTime",style: StyleForApp.text_style_bold_14_black),
                                           ],
                                         ),)
                                       ],
                                     )),
                               ],
                             ),
                           ),
                         ),
                       ],
                     )
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 9.0,right: 9.0),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
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
                                child: InkWell(
                                    onTap: () async {
                                      index == 0
                                          ? goToSalesOrderPage()
                                          : index == 1
                                          ?goToItemRatePage()
                                          :index==2
                                          ?goToAccStatementPage()
                                          :index==3
                                          ?goToPaymentSalePage()
                                          :index==4
                                          ?goToVehiclePage()
                                          :index==6
                                          ?goToRequestPage()
                                          : print("WIP");

                                    },
                                    child: SizedBox(
                                      height: 140,
                                      width: 140,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          children: [
                                            Icon(
                                              gridsIcons[index],
                                              size: 25,
                                              color: ColorsForApp.appThemeColorPetroCustomer,
                                            ),
                                            const SizedBox(
                                              height: 0,
                                            ),
                                            Text(
                                              grids[index],
                                              style: StyleForApp.text_style_normal_14_black
                                            ),
                                            const SizedBox(
                                              height: 0,
                                            ),
                                            StyleForApp.horizontal_divider_light_gray,
                                            const SizedBox(
                                              height: 0,
                                            ),
                                            Text(
                                              index == 0
                                                  ?"\u{20B9}"+ _salesOrders
                                                      .toString()
                                                  : index == 1
                                                      ? _itemRates
                                                          .toStringAsFixed(0)
                                                      : index == 2
                                                          ? "\u{20B9}"+_accStatement
                                                              .toString()
                                                          : index == 3
                                                              ?"\u{20B9}"+ _payment
                                                                  .toString()
                                                              : index ==
                                                                      4
                                                                  ? _vehicles
                                                                      .toStringAsFixed(0)
                                                                  : index == 5
                                                                      ? _drivers.toStringAsFixed(0)
                                                  : "0",
                                              style: StyleForApp.text_style_normal_16_black,
                                            ),
                                            const SizedBox(
                                              height: 0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              );
                            },
                          ))),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              elevation: 5,
              notchMargin: 5,
              clipBehavior: Clip.antiAlias,
              color: ColorsForApp.appThemeColorPetroCustomer,
              shape:  const CircularNotchedRectangle(),
                  /*CircularNotchedRectangle(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),*/
              child:SizedBox(
                width: double.infinity,
                height: 50,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.bottomRight,
                    //margin: EdgeInsets.only(left: 90, bottom: 20),
                    width: 170,
                    height: 65,
                  child:  Padding(
                  padding:  EdgeInsets.only(left: 0.0,top: 10.0,bottom: 0.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         Text("Unbilled",style: StyleForApp.text_style_normal_14_white),
                        Text("\u{20B9}${_unBilledBalance.toStringAsFixed(2 )}",style: StyleForApp.text_style_bold_14_white),
                      ],
                    ),
                  )
              ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CouponDetails()));
                    },
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      //margin: EdgeInsets.only(left: 90, bottom: 20),
                      width: 160,
                      height: 65,
                       child: Padding(
                         padding: const EdgeInsets.only(left: 0.0,top: 10.0,bottom: 0.0),
                         child: Center(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               Text("Coupon Count",style: StyleForApp.text_style_normal_14_white),
                               Text(couponCount!=null?"$couponCount":"0",style: StyleForApp.text_style_bold_14_white),
                             ],
                           ),
                         )
                       ),
                    ),
                  ),
                ],
              ),
              )),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(elevation: 0,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            onPressed: () {},
            child: Image.asset("assets/petrol-pump.png",height: 45,),
          ),
          drawer: const BuyerDrawer()),

    );
  }

  Future<bool?> exitAppDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(titleTextStyle: StyleForApp.text_style_bold_14_grn,
        title:  Text("Logout"),
        content:  Text("Are you sure you want to exit from PetroTransport app"),
        actions: <Widget>[
          ButtonBar(
            buttonMinWidth: 100,
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: ColorsForApp.app_theme_color_light_drawer,
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                    textStyle: StyleForApp.text_style_bold_14_black),
                child: const Text("No",style: TextStyle( color:Colors.black ,),),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: ColorsForApp.app_theme_color,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    textStyle: StyleForApp.text_style_bold_14_white),
                child: const Text("YES"),
                onPressed: (){     
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  //Couponent/getCouponDetails(string year, string shopNo, string cust_code)
  resetVal() async {
    var _url = UT.APIURL! +
        "api/getPetroCustData/getPetroBuyerData?curyear=" +
        UT.curyear! +
        "&firmno=" +
        UT.shop_no! +
        "&date=" +
        "${UT.m['saledate']}" +
        "&custcode="+UT.ClientAcno!;
    var data = await UT.apiDt(_url);
    print(data);
    _salesOrders =data[0]["creditsale"].toStringAsFixed(2);
    _itemRates = double.parse(data[0]["itemcount"].toStringAsFixed(0));
    _accStatement = data[0]["custbal"].toStringAsFixed(2);
    _payment = data[0]["rectamt"].toStringAsFixed(2);
    _vehicles = double.parse(data[0]["vehiclecount"].toStringAsFixed(0));
    _drivers = double.parse(data[0]["drivercount"].toStringAsFixed(0));
    var _url1 = UT.APIURL! +
        "api/getPetroCustData/getCustUnbilledAmt?year4amt=" +
        UT.curyear! +
        "&shop4amt=" +
        UT.shop_no! +
        "&cust_code="+UT.ClientAcno!;
    var data1= await UT.apiStr(_url1);

    _unBilledBalance=double.parse(data1);
    setState(() {});
  }
  couponDetails() async {
    var _url = UT.APIURL! +
        "api/Couponent/getCouponDetails?year=" +
        UT.curyear! +
        "&shopNo=" +
        UT.shop_no! +
        "&cust_code="+UT.ClientAcno!;
    var data = await UT.apiDt(_url);
    UT.couponData=data;
    num aa=0;
    if(data["Message"]=="An error has occurred."){

    }else{
      for(int i=0;i<data.length;i++){
        aa+=data[i]["balance"];
      }
      couponCount=aa;
      setState(() {});
    }

  }
  goToSalesOrderPage(){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const SalesOrders()));

  }
  goToItemRatePage() async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ItemRates()));
  }
  goToAccStatementPage() async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const AccountStatement()));

  }
  goToPaymentSalePage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const Payment()));

  }
  goToVehiclePage() async {
       Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const VehiclePage()));
  }
  goToRequestPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const AcceptRequest()));

  }
  Future<void> openDatePicker(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)))!;
    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        convertedDateTime = "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')}";
        UT.m['saledate']=convertedDateTime;
      });
    }
  }
}

