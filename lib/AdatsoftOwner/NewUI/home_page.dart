import 'dart:async';

import 'package:petrosoft_india/AdatsoftOwner/AppTheame/asset_files.dart';
import 'package:petrosoft_india/AdatsoftOwner/NewUI/cart.dart';
import 'package:petrosoft_india/AdatsoftOwner/NewUI/constants.dart';
import 'package:petrosoft_india/AdatsoftOwner/NewUI/drawer_menu.dart';
import 'package:petrosoft_india/AdatsoftOwner/sale_bill_entry.dart';
import 'package:petrosoft_india/AdatsoftOwner/stock_details.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../ArrivalEntry/add_arrival_entry.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _drawerController = ZoomDrawerController();
  bool clickedCentreFAB = false; //boolean used to handle container animation which expands from the FAB
  int selectedIndex = 0; //to handle which item is currently selected in the bottom app bar
  String text = "Home";

  //call this method on click of each bottom app bar item to update the screen
  void updateTabSelection(int index, String buttonText) {
    setState(() {
      selectedIndex = index;
      text = buttonText;
    });
  }
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  final _animationDuration = Duration(seconds: 2);
  Timer? _timer;
  Color? _color;
  @override
  void initState() {
    data = [
      _ChartData('NILL', 478791),
      _ChartData('HARISH', 230981),
      _ChartData('NAGUJI', 191381),
      _ChartData('SS', 184649),
      _ChartData('AYUB', 178081),
      _ChartData('RR', 172033),
      _ChartData('JJ', 162364),
      _ChartData('MM', 157508),
      _ChartData('GANESH', 146628),
      _ChartData('WASHIM', 142302),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
    _timer = Timer.periodic(_animationDuration, (timer) => _changeColor());
    _color = Colors.blue;
  }

  void _changeColor() {
    final newColor = _color == Colors.blue ? Colors.white : Colors.blue;
    setState(() {
      _color = newColor;
    });
  }
  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
        controller: _drawerController,
        style: DrawerStyle.defaultStyle,
        menuScreen:const DrawerMenuScreen(),
        mainScreen: homeScreenBody(),
        borderRadius: 24.0,
        showShadow: true,
        //angle: -12.0,
        angle: 0.0,
       // menuBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        menuBackgroundColor: Colors.grey.shade300,
        mainScreenTapClose: true,
        drawerShadowsBackgroundColor: Colors.white,
        mainScreenAbsorbPointer: true,
       // mainScreenOverlayColor: Colors.blue.shade50,
       // slideWidth: MediaQuery.of(context).size.width * 0.70,
        menuScreenWidth: double.infinity,
      //  menuScreenHeight: double.infinity,

        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      );

  }

  menuBottomSheet(){
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0),topRight:  Radius.circular(20.0)),
        ),
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                       const Padding(
                         padding: const EdgeInsets.only(left: 8.0),
                         child: const Text("Transaction",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                          fontSize: 16,
                            fontWeight: FontWeight.w600,
                      ),),
                       ),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(Icons.clear,color: Colors.black,),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                       // margin: EdgeInsets.only(right: 8),
                        height: 70,
                         width: 100,
                        /*decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: const [
                          BoxShadow(
                              color: Color(0x10000000),
                              blurRadius: 10,
                              spreadRadius: 4,
                              offset: Offset(0.0, 8.0))
                        ],
                        ),*/
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.blue,
                                child: const Icon(Icons.stream,color: Colors.white),
                              ),
                              const SizedBox(height: 5,),
                               Expanded(
                                child:  Text(
                                  "Arrival Entry",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                      Container(
                        //margin: EdgeInsets.only(right: 8),
                        height: 70,
                       // width: 100,
                        /*decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: const [
                          BoxShadow(
                              color: Color(0x10000000),
                              blurRadius: 10,
                              spreadRadius: 4,
                              offset: Offset(0.0, 8.0))
                        ],
                        ),*/
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.pink,
                                child: const Icon(Icons.signal_cellular_alt,size: 16,color: Colors.white),
                              ),
                              const SizedBox(height: 5,),
                               Expanded(
                                child:  Text(
                                  "Sale bill Entry",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                      Container(
                         // margin: EdgeInsets.only(right: 8),
                          height: 70,
                          // width: 100,
                          /*decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0x10000000),
                                  blurRadius: 10,
                                  spreadRadius: 4,
                                  offset: Offset(0.0, 8.0))
                            ],
                          ),*/
                          child:Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.indigo,
                                  child: const Icon(Icons.photo_filter_sharp,size: 16,color: Colors.white,),
                                ),
                                const SizedBox(height: 5,),
                                 Expanded(
                                  child:  Text(
                                    "Patti Book Entry",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child:  Text("Report",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: 60,
                           // width: 100,
                           /* decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x10000000),
                                    blurRadius: 10,
                                    spreadRadius: 4,
                                    offset: Offset(0.0, 8.0))
                              ],
                            ),*/
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.amber,
                                  child: const Icon(Icons.receipt,size: 16,color: Colors.white),
                                ),
                                const SizedBox(height: 5,),
                                 Text(
                                  "Patti Report",textAlign: TextAlign.center,
                                  style:  TextStyle(
                                      fontSize: 14,
                                    color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: 60,
                            width: 150,
                            /*decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x10000000),
                                    blurRadius: 10,
                                    spreadRadius: 4,
                                    offset: Offset(0.0, 8.0))
                              ],
                            ),*/
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.deepOrange,
                                  child: const Icon(Icons.description,size: 16,color: Colors.white),
                                ),
                                const SizedBox(height: 5,),
                                 Text(
                                  "Bill Report",textAlign: TextAlign.center,
                                  style:  TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,

                                  ),
                                ),
                              ],
                            )



                        ),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: 80,
                           //  width: 150,
                            /* decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x10000000),
                                    blurRadius: 10,
                                    spreadRadius: 4,
                                    offset: Offset(0.0, 8.0))
                              ],
                            ),*/
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.purple,
                                  child: const Icon(Icons.payment,size: 16,color: Colors.white),
                                ),
                                const SizedBox(height: 5,),
                                 Text(
                                  "Supplier\nPayment",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )



                        ),
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text("Ledger",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: 80,
                            //width: 150,
                            /*decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x10000000),
                                    blurRadius: 10,
                                    spreadRadius: 4,
                                    offset: Offset(0.0, 8.0))
                              ],
                            ),*/
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.red,
                                  child: const Icon(Icons.request_page_sharp,size: 16,color: Colors.white),
                                ),
                                const SizedBox(height: 5,),
                                 Text(
                                  "Customer Ledger",textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )



                        ),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: 80,
                            // width: 150,
                           /* decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x10000000),
                                    blurRadius: 10,
                                    spreadRadius: 4,
                                    offset: Offset(0.0, 8.0))
                              ],
                            ),*/
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.green,
                                  child: const Icon(Icons.list,size: 16,color: Colors.white),
                                ),
                                const SizedBox(height: 5,),
                                 Text(
                                  "Supplier\nLedger",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )



                        ),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            height: 80,
                            //width: 150,
                            /* decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x10000000),
                                    blurRadius: 10,
                                    spreadRadius: 4,
                                    offset: Offset(0.0, 8.0))
                              ],
                            ),*/
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.cyan,
                                  child: const Icon(Icons.receipt_long,size: 16,color: Colors.white),
                                ),
                                const SizedBox(height: 5,),
                                 Text(
                                  "Customer\nReceipt",textAlign: TextAlign.center,
                                  style:  TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )



                        ),
                      ),

                    ],
                  ),
                ),


              ],
            ),
          );
        });
  }

  Widget homeScreenBody(){
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // backgroundColor:Colors.grey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // backgroundColor: Colors.grey,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            height: 15,width: 15,
            decoration: BoxDecoration(
              //color: Colors.grey,
                image: DecorationImage(
                    image: AssetImage(AssetFiles.drawerIcon)
                )
            ),
          ),
        ),
        title: const Text(
          'JAI SHANKAR TRADERS',
          style:  TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: kBlackColor,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0.0),
          ),
        ),


      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, //specify the location of the FAB
      floatingActionButton: FloatingActionButton(
       // mini: true,
        onPressed: () {
          setState(() {
            clickedCentreFAB = !clickedCentreFAB;
            menuBottomSheet();//to update the animated container
          });

        },
        tooltip: "Centre FAB",
        child: Container(
          margin: const EdgeInsets.all(15.0),
          child: const Icon(Icons.menu),
        ),
        elevation: 4.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        // color: Theme.of(context).scaffoldBackgroundColor,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor
                ]
            )
        ),

        child:   Stack(
          children: [
            Positioned(
              top: 10,
              left: 0, child: Container(
              // color: Colors.indigo,
              width: MediaQuery.of(context).size.width,
              child:  Padding(
                padding:  const EdgeInsets.only(left: 24, top: 10, bottom: 0, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ArrivalEntry()));
                      },
                      child: Container(
                        //  margin: const EdgeInsets.only(right: 8),
                        height: 70,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue.shade100,
                          boxShadow: [
                            const BoxShadow(
                                color: const Color(0x10000000),
                                blurRadius: 10,
                                spreadRadius: 4,
                                offset: const Offset(0.0, 8.0))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: Colors.blue.shade50,
                              child: const Icon(Icons.stream,size: 18,color: Colors.indigo,),
                            ),
                            const SizedBox(height: 5,),
                            const Text(
                              "Arrival Entry",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SaleBillEntry()));
                      },
                      child: Container(
                        //  margin: const EdgeInsets.only(right: 8),
                        height: 70,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.indigo.shade100,
                          boxShadow: [
                            const BoxShadow(
                                color: const Color(0x10000000),
                                blurRadius: 10,
                                spreadRadius: 4,
                                offset: const Offset(0.0, 8.0))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: Colors.indigo.shade50,
                              child: const Icon(Icons.notes,size: 18,color: Colors.indigo),
                            ),
                            const SizedBox(height: 5,),
                            const Text(
                              "Sale Bill",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
            Positioned(
                top: 100, right: 0, bottom: 0, child: AnimatedContainer(
              width: MediaQuery.of(context).size.width,
              // height: 350,
              decoration:  BoxDecoration(
                color:  _color,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60.0),
                    bottomRight: const Radius.circular(0.0)
                ),
              ), duration: _animationDuration,
            )
            ),
            Positioned(top: 105, right: 0, bottom: 0, child: Container(
              width: 350,
              // height: 584,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60.0),
                  bottomRight: const Radius.circular(0.0),
                  bottomLeft: const Radius.circular(0.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 290,
                      child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            labelIntersectAction: AxisLabelIntersectAction.hide,
                            labelRotation: 320,
                            labelStyle: TextStyle(fontSize: 10),
                            labelAlignment: LabelAlignment.start,
                          ),
                          primaryYAxis: NumericAxis(
                              labelStyle: TextStyle(fontSize: 10),
                              minimum: 100000, maximum: 500000, interval: 50000),
                          tooltipBehavior: _tooltip,
                          isTransposed: true,
                          title: ChartTitle(text: 'Customer balance',alignment:ChartAlignment.near,textStyle: StyleForApp.text_style_bold_13_indigo),
                          series: <ChartSeries<_ChartData, String>>[
                            BarSeries<_ChartData, String>(
                                dataSource: data,
                                width: 0.5,
                                xValueMapper: (_ChartData data, _) => data.x,
                                yValueMapper: (_ChartData data, _) => data.y,
                                name: 'Customer balance',
                               color: ColorsForApp.appThemeColorAdatOwner,
                            )
                               // color: const Color.fromRGBO(8, 142, 255, 1))
                          ]),
                    ),
                  )
                  /* Padding(
                    padding:
                    const EdgeInsets.only(left: 24, top: 32, bottom: 16, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          'Balance stock',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: kBlackColor,
                          ),
                        ),
                        Text(
                          'view more',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: kBlueColor,
                          ),
                        ),
                      ],
                    )),
                ListView.builder(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  scrollDirection: Axis.vertical,
                  itemCount: transactions.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>StockEntryDetails()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(

                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              // border: Border.all(),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0,left: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      Expanded(child: Text("00009",style: StyleForApp.text_style_normal_13_black)),
                                      Expanded(child: Text("ONION",style: StyleForApp.text_style_normal_13_black)),
                                      Expanded(child: Text("MH12 833",style: StyleForApp.text_style_normal_13_black)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0,left: 8.0,bottom: 8.0),
                                  child: Row(
                                    children:  [
                                      Expanded(child: Text("Recd Qty: 4460.00",style: StyleForApp.text_style_normal_13_black)),
                                      Expanded(child: Text("Sold Qty:\n 4460.00",style: StyleForApp.text_style_normal_13_black)),
                                      Expanded(child: Text("Balance : 1000.00",style: StyleForApp.text_style_bold_13_indigo,)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                    );
                  },
                ),*/
                ],
              ),
            )
            )
          ],
        ),

      ),
    );

  }

}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}