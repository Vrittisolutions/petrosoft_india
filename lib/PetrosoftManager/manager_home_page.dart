import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/Reports/report_list.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/PetrosoftManager/add_new_rate.dart';
import 'package:petrosoft_india/PetrosoftManager/owner_drawar.dart';
import 'package:petrosoft_india/PetrosoftManager/payment_entry.dart';
import 'package:petrosoft_india/PetrosoftManager/pending_orders.dart';
import 'package:petrosoft_india/PetrosoftManager/petrosoft_manager_app_theme.dart';
import 'package:petrosoft_india/PetrosoftManager/rate_master.dart';
import 'package:petrosoft_india/PetrosoftManager/receipt_entry.dart';

import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class PetroManagerHomePage extends StatefulWidget {
  const PetroManagerHomePage({Key? key}) : super(key: key);

  @override
  _PetroManagerHomePageState createState() => _PetroManagerHomePageState();
}

class _PetroManagerHomePageState extends State<PetroManagerHomePage> {

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

  //Icons.food_bank_rounded;
  List<String> grids = [
    "Rate Master",
    "Pending orders",
    "Shift Sale",
    "Customer Receipt",
    "Payment Entry",
    "Reports",
  ];
  List<Color> boxBgColors = [
    ColorConverter.hexToColor('#fff8dc'),
    ColorConverter.hexToColor('#d7efff'),
    ColorConverter.hexToColor('#e0d7ff'),
    ColorConverter.hexToColor('#fbe1fb'),
    ColorConverter.hexToColor('#b8eedc'),
    ColorConverter.hexToColor('#ffdfcd'),
  ];
  List<Color> textColors = [
   ColorConverter.hexToColor('#fab65f'),
   ColorConverter.hexToColor('#3a9ef7'),
   ColorConverter.hexToColor('#9980f5'),
   ColorConverter.hexToColor('#f371ce'),
   ColorConverter.hexToColor('#70c3a7'),
   ColorConverter.hexToColor('#fe8e75'),
  ];
  List<Color> iconBgColor = [
    ColorConverter.hexToColor('#fffae7'),
    ColorConverter.hexToColor('#f1f9ff'),
    ColorConverter.hexToColor('#f4f1ff'),
    ColorConverter.hexToColor('#ffefff'),
    ColorConverter.hexToColor('#e3fff6'),
    ColorConverter.hexToColor('#fff2eb'),
  ];
  List gridsIcons = [
    Icons.brightness_auto_rounded,
    Icons.personal_video_rounded,
    Icons.credit_card_rounded,
    Icons.card_membership,
    Icons.wysiwyg_sharp,
    Icons.wysiwyg_sharp,
  ];
  DateTime? selectedDate = DateTime.now();
  Color kPrimaryLightColor = const Color(0xFFF1E6FF);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Instantiate NewVersion manager object (Using GCP Console app as example)


    // You can let the plugin handle fetching the status and showing a dialog,
    // or you can fetch the status and display your own dialog, or no dialog.
    const simpleBehavior = true;
    managerRateMasterDates();
    if(UT.m["saledate"]!=null){
      DateTime date1 = DateTime.parse(UT.m["saledate"]);
      displayDateFormat=UT.displayDateConverter(date1);
     }else{
      sendDateToApi = UT.dateConverter(selectedDate);
      displayDateFormat=UT.displayDateConverter(selectedDate);
      UT.m['saledate']=sendDateToApi;
       }
    resetVal();
  }
  String? sendDateToApi;
  String? displayDateFormat;

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
          appBar:AppBar(
            backgroundColor: PetroManagerAppTheme.blueColor,
            centerTitle: true,
            /*title: Text(
              'Dashboard',
              style:
              TextStyle(fontSize: 17, color: Colors.white, letterSpacing: 0.53),
            ),*/
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
           /* leading: InkWell(
              onTap: () {},
              child: Icon(
                Icons.subject,
                color: Colors.white,
              ),
            ),*/
            actions: [
              InkWell(
                  onTap: () async {
                    openDatePicker(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Center(
                        child: Row(
                          children: [
                            Icon(
                              Icons.date_range_rounded,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("$displayDateFormat",style: StyleForApp.text_style_bold_14_white),
                          ],
                        ),
                      ),
                    ),))
            ],
            bottom: PreferredSize(
                child: getAppBottomView(),
                preferredSize: Size.fromHeight(80.0)),
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            // scrollDirection: Axis.horizontal,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 9.0,right: 9.0, top: 5),
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
                                border: Border.all(color: Colors.transparent),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.transparent,
                                    blurRadius: 1.0,
                                    spreadRadius: 1.0, //extend the shadow
                                    offset: Offset(
                                      3.0, // Move to right 10  horizontally
                                      3.0, // Move to bottom 5 Vertically
                                    ),
                                  ),
                                ],
                                color: boxBgColors[index],
                              ),
                              child: InkWell(
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
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: iconBgColor[index],
                                          child: Icon(
                                            gridsIcons[index],
                                            size: 25,
                                            color: textColors[index],
                                          ),
                                        ),
                                        Text(
                                          grids[index],
                                          style: TextStyle(
                                            color: textColors[index],
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                          )
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          },
                        ))),
              ],
            ),
          ),
          drawer: const PetrosoftManagerDrawer()),
    );

  }
  Widget getAppBottomView() {
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 30),
      child: Row(
        children: [
          Container(
            //margin: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi ${UT.userName}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  //'Financial Year : ${UT.yearStartDate} to  ${UT.yearEndDate}',
                  'Financial Year : 2022-2023',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Future<bool?> exitAppDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(titleTextStyle: StyleForApp.text_style_bold_14_owner_icon,
        title: const Text("Logout"),
        content: const Text("Are you sure you want to exit from PetroOwner app?"),
        actions: <Widget>[
          ButtonBar(
            buttonMinWidth: 100,
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: ColorsForApp.app_theme_color_light_owner_drawer,
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                    textStyle: StyleForApp.text_style_bold_14_black),
                child: const Text("No",style: TextStyle( color:Colors.black ,),),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: ColorsForApp.app_theme_color_owner,
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
  resetVal() async {
    if(UT.m['saledate']!=null){
      UT.m['saledate']=UT.m['saledate'];
    }else{
      UT.m['saledate']=sendDateToApi;
    }
  }

  managerShiftSalePage(){
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ManagerShiftSalePage()));

  }
  managerReceiptEntryPage() async {
    var _url = UT.APIURL! +
        "api/AccountMaster/GetCust?Yr=" +
        UT.curyear! +
        "&Shop=" +
        UT.shop_no!;
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
    var _url = UT.APIURL! +
        "api/PriceListEnt/GetDistinctDate4mobile?_shopno=" +
        UT.shop_no!;
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

  Future<void> openDatePicker(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)))!;
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

