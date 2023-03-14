import 'dart:convert';

import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/customer_home_page.dart';
import 'package:petrosoft_india/PetrosoftOperator/operator_home_page.dart';
import 'package:petrosoft_india/PetrosoftOwner/owner_drawar.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/report_list.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/PetrosoftOwner/payment_entry.dart';
import 'package:petrosoft_india/PetrosoftOwner/pending_orders.dart';
import 'package:petrosoft_india/PetrosoftOwner/rate_master.dart';
import 'package:petrosoft_india/PetrosoftOwner/receipt_entry.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:upgrader/upgrader.dart';

import 'PetrosoftManager/Reports/report_list.dart';
import 'PetrosoftManager/ShiftSale/shift_sale.dart';
import 'PetrosoftManager/add_new_rate.dart';
import 'PetrosoftManager/payment_entry.dart';
import 'PetrosoftManager/pending_orders.dart';
import 'PetrosoftManager/receipt_entry.dart';
import 'common/widgets/customdialog.dart';




class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _checker = AppVersionChecker();
  final double _rateMaster = 0;
  final double _pendingOrders = 0;
  final double _shiftSale = 0;
  final double _customerReciept = 0;
  final double _paymentEntry = 0;
  final double _reports = 0;
  final double _acceptReq = 0;
  String? validFromDate;
  String? validUptoDate;
  String? dSrNo;
  String? startFY, endFY;
  //Icons.food_bank_rounded;
  List salesItem = [];
  List<TodaySale> todaySale = [];


  Map<String, double> dataMap = {
    "Petrol": 5,
    "P Petrol": 3,
    "Diesel": 2,
    "Speed Diesel": 2,
  };


  List<String> titles = [
    "Rate Master",
    "Pending orders",
    "Shift Sale",
    "Customer Receipt",
    "Payment Entry",
    "Reports",
  ];
  List gridsIcons = [
    PetroSoftAssetFiles.rateMaster,
    PetroSoftAssetFiles.pendingOrders,
    PetroSoftAssetFiles.worker,
    PetroSoftAssetFiles.customerRecipit,
    PetroSoftAssetFiles.paymentHistory,
    PetroSoftAssetFiles.reports,
  ];
  /*List<ChartData > chartData = <ChartData>[
    ChartData('China',  10.541,ColorsForApp.pie_Chart_petrol_Color),
    ChartData('Brazil', 15.818,ColorsForApp.pie_Chart_speed_Color),
    ChartData('Bolivia', 19.51,ColorsForApp.pie_Chart_diesel_Color),
    ChartData( 'Mexico', 18.302,ColorsForApp.pie_Chart_speed_diesel_Color),
    ChartData('Egypt', 14.017,ColorsForApp.pie_Chart_speed_Color),
    ChartData( 'Mongolia',  15.683,ColorsForApp.pie_Chart_diesel_Color),
  ];*/
  DateTime? selectedDate = DateTime.now();
  Color kPrimaryLightColor = const Color(0xFFF1E6FF);
  @override
  void initState() {
    _tooltip1 = TooltipBehavior(enable: true);
    _tooltip2 = TooltipBehavior(enable: true);
    getData();
    // TODO: implement initState
    super.initState();
    checkVersion();
    managerRateMasterDates();
    salesItem = [
      Sales("Petrol", "10,0000", PetroSoftAssetFiles.petrol),
      Sales("Speed Petrol", "10,0000", PetroSoftAssetFiles.speedPetrol),
      Sales("Diesel", "10,0000", PetroSoftAssetFiles.diesel),
      Sales("Petrol", "10,0000", PetroSoftAssetFiles.petrol)
    ];

    todaySale = [
      TodaySale("Petrol", "90.2", PetroSoftAssetFiles.petrol),
      TodaySale("Speed", "90.2", PetroSoftAssetFiles.speedPetrol),
      TodaySale("Diesel", "90.2", PetroSoftAssetFiles.diesel),
      TodaySale("Petrol", "90.2", PetroSoftAssetFiles.petrol)
    ];
    const simpleBehavior = true;

    if(UT.m["saledate"]!=null){
      DateTime date1 = DateTime.parse(UT.m["saledate"]);
      displayDateFormat=UT.displayDateConverter(date1);
     }else{
      sendDateToApi = UT.dateConverter(selectedDate);
      displayDateFormat=UT.displayDateConverter(selectedDate);
      UT.m['saledate']=sendDateToApi;
       }
    resetVal();
    startFY = DateFormat.y().format(DateTime.parse(UT.yearStartDate.toString()));
    endFY = DateFormat.y().format(DateTime.parse(UT.yearEndDate.toString()));
  }
  String? sendDateToApi;
  String? displayDateFormat;
  late TooltipBehavior _tooltip1;
  late TooltipBehavior _tooltip2;
  late ChartData credData;
  late ChartData balData;
  late List<ChartData> combCredData=[];
  late List<ChartData> combBalData=[];

  getData() async {
    var url = "${UT.APIURL!}api/PetroChart/getcreditsale?_yr=${UT.curyear}&_sh=${UT.shop_no}";
    var custCred = await UT.apiStr(url);
    var custCredData = jsonDecode(custCred);
    for (int i = 0; i < custCredData.length; i++) {
      credData = ChartData(
        custCredData[i]["name"],
        custCredData[i]["totamt"],
      );
      combCredData.add(credData);
    }

    var url1 = "${UT.APIURL!}api/ChartCustBal/Get?yr=${UT.curyear}&sh=${UT.shop_no}";
    var custBal = await UT.apiStr(url1);
    var custBalData = jsonDecode(custBal);
    for (int i = 0; i < custBalData.length; i++) {
      balData = ChartData(
        custBalData[i]["name"],
        custBalData[i]["balance"],
      );
      combBalData.add(credData);
    }
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorsForApp.app_theme_color_owner,
      statusBarBrightness: Brightness.dark,
    ));


     sendDateToApi = UT.dateConverter(selectedDate);
     return WillPopScope(
      onWillPop:  ()async {
        exitAppDialog();
        return true;
      },
      child: Scaffold(
         // backgroundColor: UT.BACKGROUND_COLOR,
          appBar: AppBar(
            titleSpacing: 0.0,
            backgroundColor: ColorsForApp.appThemeColor,
            //automaticallyImplyLeading: false,
            title: Text(
              UT.firm_name!,
              style: PetroSoftTextStyle.style17White,
            ),
            actions: [
              Row(
                children: [
                  Image.asset(PetroSoftAssetFiles.calender,height: 20,width: 20,),
                  const SizedBox(
                    width: 5,
                  ),
                   Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text('$startFY-$endFY'),
                  ),
                ],
              )
            ],
          ),
          body: UpgradeAlert(
            upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.material),
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Text('Welcome to ',style: PetroSoftTextStyle.style15Black,),
                          Text(
                            'PetroSoft',
                            style: PetroSoftTextStyle.style20Black,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Sales',
                        style: StyleForApp.text_style_normal_14_black,
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: salesItem.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  //height: 80,
                                  width: 120,
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                      gradient:  LinearGradient(
                                        colors: [Colors.cyan.shade100, const Color(0xffdcecffff),],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0, right: 2, top: 2),
                                            child: Image.asset(
                                              salesItem[index].image,
                                              height: 30,
                                              width: 40,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(right: 8.0),
                                            child: Text(
                                              'view',
                                              style: StyleForApp
                                                  .text_style_bold_12_light_gray,
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                                        child: Text(salesItem[index].name),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0,top: 5.0,bottom: 5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Image.asset(PetroSoftAssetFiles.rupees,height: 15,width: 15,),
                                            Text(
                                              '${salesItem[index].amount}',
                                              style: TextStyle(
                                                  foreground: Paint()..shader = const LinearGradient(
                                                    colors: <Color>[
                                                      Color(0xff00487C),
                                                      Color(0xff84E4FF),
                                                      //add more color here.
                                                    ],
                                                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Today's Rate",
                        style: StyleForApp.text_style_normal_14_black,
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: todaySale.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  //height: 80,
                                  width: 120,
                                  alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                      gradient:  LinearGradient(
                                        colors: [const Color(0xFFD5ECAE), ColorConverter.hexToColor("#DBF4A7").withOpacity(0.1),],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0, right: 2, top: 2),
                                            child: Image.asset(
                                              todaySale[index].image,
                                              height: 30,
                                              width: 40,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(right: 8.0),
                                            child: Text(
                                              'view',
                                              style: StyleForApp
                                                  .text_style_bold_12_light_gray,
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                                        child: Text(todaySale[index].name),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0,top: 5.0,bottom: 5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Image.asset(PetroSoftAssetFiles.rupees,height: 15,width: 15,),
                                            Text(
                                              todaySale[index].amount,
                                              style: TextStyle(
                                                  foreground: Paint()..shader = const LinearGradient(
                                                    colors: <Color>[
                                                      Color(0xff00487C),
                                                      Color(0xff84E4FF),
                                                      //add more color here.
                                                    ],
                                                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Fuel Sale",
                        style: StyleForApp.text_style_normal_14_black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          decoration: const BoxDecoration(
                            color: Colors.grey,

                            borderRadius:  BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                          child: PieChart(
                            dataMap: dataMap,
                            animationDuration: const Duration(milliseconds: 800),
                            chartLegendSpacing: 40,
                            chartRadius: 120,
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            colorList: [
                              ColorsForApp.pie_Chart_petrol_Color,
                              ColorsForApp.pie_Chart_speed_Color,
                              ColorsForApp.pie_Chart_diesel_Color,
                              ColorsForApp.pie_Chart_speed_diesel_Color
                            ],
                            legendOptions: LegendOptions(
                              showLegends: true,
                              // legendPosition: LegendPosition.right,
                              legendTextStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                  color: ColorsForApp.white
                              ),
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              chartValueStyle: TextStyle(color: Colors.white),
                              showChartValueBackground: false,
                              showChartValues: true,
                              showChartValuesInPercentage: false,
                              showChartValuesOutside: false,
                              decimalPlaces: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 290,
                          child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                labelIntersectAction: AxisLabelIntersectAction.hide,
                                labelRotation: 320,
                                labelStyle: const TextStyle(fontSize: 8),
                                labelAlignment: LabelAlignment.start,
                              ),
                              primaryYAxis: NumericAxis(
                                  labelStyle: const TextStyle(fontSize: 10),
                                  minimum: 0, maximum: 1200000, interval: 200000),
                              tooltipBehavior: _tooltip1,
                              isTransposed: true,
                              title: ChartTitle(text: 'Customer wise Credit Sale',alignment:ChartAlignment.near,textStyle: StyleForApp.text_style_bold_13_indigo),
                              series: <ChartSeries<ChartData, String>>[
                                BarSeries<ChartData, String>(
                                  dataSource: combCredData,
                                  width: 0.5,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  name: 'Customer wise Credit Sale',
                                  color: ColorsForApp.appThemeColorPetroOperator,
                                )
                                // color: const Color.fromRGBO(8, 142, 255, 1))
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 290,
                          child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                labelIntersectAction: AxisLabelIntersectAction.hide,
                                labelRotation: 320,
                                labelStyle: const TextStyle(fontSize: 8),
                                labelAlignment: LabelAlignment.start,
                              ),
                              primaryYAxis: NumericAxis(
                                  labelStyle: const TextStyle(fontSize: 10),
                                  minimum: 0, maximum: 12000, interval: 2000),
                              tooltipBehavior: _tooltip2,
                              isTransposed: true,
                              title: ChartTitle(text: 'Customer wise Balance',alignment:ChartAlignment.near,textStyle: StyleForApp.text_style_bold_13_indigo),
                              series: <ChartSeries<ChartData, String>>[
                                BarSeries<ChartData, String>(
                                  dataSource: combBalData,
                                  width: 0.5,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  name: 'Customer wise Credit Sale',
                                  color: ColorsForApp.appThemeColorAdatOwner,
                                )
                                // color: const Color.fromRGBO(8, 142, 255, 1))
                              ]),
                        ),
                      ),
                      Text(
                        "Daily Sale",
                        style: StyleForApp.text_style_normal_14_black,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 190,
                            child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),

                                primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10,majorGridLines: const MajorGridLines(width: 0)),
                                //tooltipBehavior: _tooltip,
                                /*palette: [
                          ColorsForApp.pie_Chart_petrol_Color,
                          ColorsForApp.pie_Chart_speed_Color,
                          ColorsForApp.pie_Chart_diesel_Color,
                          ColorsForApp.pie_Chart_speed_diesel_Color
                        ],*/
                                series: <ChartSeries<ChartSampleData, String>>[
                                  ColumnSeries<ChartSampleData, String>(
                                    onCreateRenderer: (ChartSeries<ChartSampleData, String> series) {
                                      return _CustomColumnSeriesRenderer();
                                    },
                                    dataSource: <ChartSampleData>[
                                      ChartSampleData(
                                          x: 'Petrol',
                                          y: 20.54,
                                          pointColor: const Color.fromARGB(53, 92, 125, 1)),
                                      ChartSampleData(
                                          x: 'Diesel',
                                          y: 25.46,
                                          pointColor: const Color.fromARGB(192, 108, 132, 1)),
                                      ChartSampleData(
                                          x: 'Speed Petrol',
                                          y: 30.18,
                                          pointColor: const Color.fromARGB(246, 114, 128, 1)),
                                      ChartSampleData(
                                          x: 'Ms',
                                          y: 22.56,
                                          pointColor: const Color.fromARGB(248, 177, 149, 1)),
                                      ChartSampleData(
                                          x: 'oil',
                                          y: 15.29,
                                          pointColor: const Color.fromARGB(116, 180, 155, 1)),
                                    ],
                                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                                    xValueMapper: (ChartSampleData data, _) => data.x,
                                    yValueMapper: (ChartSampleData data, _) => data.y,
                                    width: 0.6,
                                    //name: 'Gold',
                                    // color: const Color.fromRGBO(8, 142, 255, 1)
                                  )
                                ]),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          drawer: const PetrosoftOwnerDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, //specify the location of the FAB
        floatingActionButton: FloatingActionButton(
          // mini: true,
          onPressed: () {
            if(App.Type=="PetroOperator"){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const PetroSoftOperatorHomePage(),
                ), (route) => false,
              );
            }else  if(App.Type=="PetroBuyer"){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const PetrosoftCustomerHomePage(),
                ), (route) => false,
              );
            }else if(App.Type=="PetroOwner"){
              ownerMenuBottomSheet();
            }else if(App.Type=="PetroManager"){
              managerMenuBottomSheet();
              /*Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Dashboard(),
                ), (route) => false,
              );*/
            }

          },
          tooltip: "Centre FAB",
          backgroundColor: ColorsForApp.secondary,
          elevation: 4.0,
          child: Container(
            margin: const EdgeInsets.all(15.0),
            child: const Icon(Icons.menu),
          ),
        )),
    );

  }
  void checkVersion() async {
    _checker.checkUpdate().then((value) {
      print(value.canUpdate); //return true if update is available
      print(value.currentVersion); //return current app version
      print(value.newVersion);

      UT.m["AppVersion"]=value.currentVersion;//return the new app version
      print(value.appURL); //return the app url
      print(value.errorMessage); //return error message if found else it will return null
    });
  }

  ownerMenuBottomSheet(){
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight:  Radius.circular(20.0)),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:  [
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
                Expanded(
                  child: GridView.builder(
                      itemCount: 6,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 8),
                      itemBuilder: (context,index){
                        return  InkWell(
                          onTap: () async {
                            index == 0
                                ? ownerRateMasterPage()
                                : index==1
                                ? ownerPendingOrdersPage()
                                :index==2
                                ?ownerShiftSale()
                                :index==3
                                ?ownerReceiptEntryPage()
                                :index==4
                                ?ownerPaymentEntry()
                                :index==5
                                ?ownerReport()
                                : print("WIP");

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              // margin: EdgeInsets.only(right: 8),
                                height: 110,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  gradient:  LinearGradient(
                                    colors: [ColorConverter.hexToColor("#EAEAEA"), ColorConverter.hexToColor("#FFFFFF"),],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  /* boxShadow: const [
                              BoxShadow(
                                  color: Color(0x10000000),
                                  blurRadius: 10,
                                  spreadRadius: 4,
                                  offset: Offset(0.0, 8.0))
                            ],*/
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // const SizedBox(height: 5,),
                                      Image.asset(gridsIcons[index],height: 50,width: 50,),
                                      const SizedBox(height: 5,),
                                      Text(
                                        titles[index],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: ColorsForApp.black_color,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      Expanded(
                                        child: SizedBox(width: 40,
                                          child: Divider(thickness:2.0,color: ColorsForApp.secondary,),),
                                      )
                                    ],
                                  ),
                                )
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }
  managerMenuBottomSheet(){
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight:  Radius.circular(20.0)),
        ),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:  [
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
                Expanded(
                  child: GridView.builder(
                      itemCount: 6,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 8),
                      itemBuilder: (context,index){
                        return  InkWell(
                          onTap: () async {
                            index == 0
                                ? managerRateMasterPage()
                                : index==1
                                ? managerPendingOrders()
                                :index==2
                                ?managerShiftSalePage()
                                :index==3
                                ?managerReceiptEntryPage()
                                :index==4
                                ?managerPaymentEntry()
                                :index==5
                                ?managerReport()
                                : print("WIP");

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              // margin: EdgeInsets.only(right: 8),
                                height: 110,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  gradient:  LinearGradient(
                                    colors: [ColorConverter.hexToColor("#EAEAEA"), ColorConverter.hexToColor("#FFFFFF"),],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  /* boxShadow: const [
                              BoxShadow(
                                  color: Color(0x10000000),
                                  blurRadius: 10,
                                  spreadRadius: 4,
                                  offset: Offset(0.0, 8.0))
                            ],*/
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // const SizedBox(height: 5,),
                                      Image.asset(gridsIcons[index],height: 50,width: 50,),
                                      const SizedBox(height: 5,),
                                      Text(
                                        titles[index],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: ColorsForApp.black_color,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      Expanded(
                                        child: SizedBox(width: 40,
                                          child: Divider(thickness:2.0,color: ColorsForApp.secondary,),),
                                      )
                                    ],
                                  ),
                                )
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  managerShiftSalePage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const ManagerShiftSalePage()));

  }
  managerReceiptEntryPage() async {
    var _url = "${UT.APIURL!}api/AccountMaster/GetCust?Yr=${UT.curyear!}&Shop=${UT.shop_no!}";
    var data = await UT.apiDt(_url);
    UT.customerList=data;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const ManagerReceiptEntry()));
  }
  managerPaymentEntry() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const ManagerPaymentEntry()));

  }
  managerReport() async {
    //GetOTREData(string firmno, string _curyear, string dsrno, string exp_rect,string cashCD)
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const ManagerReportList()));
  }
  managerRateMasterDates() async {
    var _url = "${UT.APIURL!}api/PriceListEnt/GetDistinctDate4mobile?_shopno=${UT.shop_no!}";
    var data = await UT.apiDt(_url);
    var lastRc = data[data.length - 1];
    validFromDate = UT.yearMonthDateFormat(lastRc["validfrom"]);
    validUptoDate = UT.dateMonthYearFormat(lastRc["validupto"]);
    print("validFromDate-->$validFromDate");
    print("validUptoDate-->$validUptoDate");
  }
  managerRateMasterPage(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (
                context) =>
                MangerAddNewRate(
                    validFromDate: validFromDate!,
                    validUptoDate: validUptoDate!)));
    /*Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ManagerRateMaster()));*/

  }
  managerPendingOrders() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const ManagerPendingOrders()));


  }

  Future<bool?> exitAppDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
      ),
    );
  }
  resetVal() async {
    if(UT.m['saledate']!=null){
      UT.m['saledate']=UT.m['saledate'];
    }else{
      UT.m['saledate']=sendDateToApi;
    }
  }

  ownerShiftSale(){
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ShiftSalePage()));

  }
  ownerReceiptEntryPage() async {
    var _url = "${UT.APIURL!}api/AccountMaster/GetCust?Yr=${UT.curyear!}&Shop=${UT.shop_no!}";
    var data = await UT.apiDt(_url);
    UT.customerList=data;
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ReceiptEntryPage()));
  }
  ownerPaymentEntry() async {
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const PaymentEntryPage()));

  }
  ownerReport() async {
    //GetOTREData(string firmno, string _curyear, string dsrno, string exp_rect,string cashCD)
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const ReportListPage()));
  }
  ownerRateMasterPage(){

       Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const RateMasterPage()));

  }
  ownerPendingOrdersPage() async {
     Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const PendingOrdersPage()));


  }

  Future<void> openDatePicker(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now()))!;
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        sendDateToApi = UT.dateConverter(selectedDate);
        displayDateFormat = UT.displayDateConverter(selectedDate);
        UT.m['saledate']=sendDateToApi;
      });
    }
  }
}

class Sales {
  Sales(this.name, this.amount, this.image);
  final String name;
  final String amount;
  final String image;
}

class TodaySale {
  TodaySale(this.name, this.amount, this.image);
  final String name;
  final String amount;
  final String image;
}

class ChartData {
  final String x;
  final double y;
  ChartData(this.x, this.y);

}
class _CustomColumnSeriesRenderer extends ColumnSeriesRenderer {
  _CustomColumnSeriesRenderer();

  @override
  ChartSegment createSegment() {
    return _ColumnCustomPainter();
  }
}

class _ColumnCustomPainter extends ColumnSegment {
  List<Color> colorList = <Color>[
    ColorsForApp.pie_Chart_petrol_Color,
    ColorsForApp.pie_Chart_speed_Color,
    ColorsForApp.appThemeColor,
    ColorsForApp.lightCyan,
    ColorsForApp.appThemeColor,

  ];

  @override
  int get currentSegmentIndex => super.currentSegmentIndex!;

  @override
  Paint getFillPaint() {
    final Paint customerFillPaint = Paint();
    customerFillPaint.isAntiAlias = false;
    customerFillPaint.color = colorList[currentSegmentIndex];
    customerFillPaint.style = PaintingStyle.fill;
    return customerFillPaint;
  }

  @override
  Paint getStrokePaint() {
    final Paint customerStrokePaint = Paint();
    customerStrokePaint.isAntiAlias = false;
    customerStrokePaint.color = Colors.transparent;
    customerStrokePaint.style = PaintingStyle.stroke;
    return customerStrokePaint;
  }

  @override
  void onPaint(Canvas canvas) {
    double x, y;
    x = segmentRect.center.dx;
    y = segmentRect.top;
    double width = 0;
    const double height = 0;
    width = segmentRect.width;
    final Paint paint = Paint();
    paint.color = getFillPaint().color;
    paint.style = PaintingStyle.fill;
    final Path path = Path();
    final double factor = segmentRect.height * (1 - animationFactor);
    path.moveTo(x - width / 2, y + factor + height);
    path.lineTo(x, (segmentRect.top + factor + height) - height);
    path.lineTo(x + width / 2, y + factor + height);
    path.lineTo(x + width / 2, segmentRect.bottom + factor);
    path.lineTo(x - width / 2, segmentRect.bottom + factor);
    path.close();
    canvas.drawPath(path, paint);
  }
}
///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
        this.y,
        this.xValue,
        this.yValue,
        this.secondSeriesYValue,
        this.thirdSeriesYValue,
        this.pointColor,
        this.size,
        this.text,
        this.open,
        this.close,
        this.low,
        this.high,
        this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

