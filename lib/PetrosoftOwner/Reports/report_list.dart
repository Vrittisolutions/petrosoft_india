import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/bank_book_report.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/cardex_report.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/customer_ledger.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/daily_report.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/general_ledger_report.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/shift_sale_report.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/stock_report.dart';
import 'package:petrosoft_india/common_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({Key? key}) : super(key: key);

  @override
  _ReportListPageState createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {

  String? dSrNo;

  //Icons.food_bank_rounded;
  List<String> grids = [
    "Shift Sale Report",
    "Daily Report",
    "Stock Report",
    "Customer Ledger",
    "Bank Book",
    "General Ledger",
    "Cardex Report",
  ];
  List<String> gridsIcons = [
    PetroSoftAssetFiles.reports,
    PetroSoftAssetFiles.dailyReport,
    PetroSoftAssetFiles.stockReport,
    PetroSoftAssetFiles.customerRecipit,
    PetroSoftAssetFiles.bankBook,
    PetroSoftAssetFiles.generalLedger,
    PetroSoftAssetFiles.cardexReport,
  ];
  var colors = [
    ColorsForApp.icon_owner,
    UT.ownerAppColor,
    ColorsForApp.icon_owner,
    UT.ownerAppColor,
    ColorsForApp.icon_owner,
    UT.ownerAppColor,
    ColorsForApp.icon_owner
  ];


  DateTime? selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
     sendDateToApi = UT.dateConverter(selectedDate);
     //displayDateFormat = UT.displayDateConverter(selectedDate);

    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        appBar:  AppBar(
          backgroundColor: ColorsForApp.appThemeColor,
          titleSpacing: 0.0,
          elevation: 0,
          title:  Text("Reports",style: PetroSoftTextStyle.style17White,),
        ),
          body:Padding(
              padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0,bottom: 15.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                controller: ScrollController(),
                itemCount: 7,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 10.0,bottom: 10.0),
                    child: Container(
                      height: 110,
                      width: 100,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFD1DCFF),
                            blurRadius: 2.0, // has the effect of softening the shadow
                            spreadRadius: 0.0, // has the effect of extending the shadow
                          ),
                        ],
                        gradient:  LinearGradient(
                          colors: [Colors.cyan.shade100, const Color(0xffdcecffff),],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                      ),
                      child: InkWell(
                        onTap: (){
                          index == 0
                              ? goToShiftSaleReport()
                              : index==1
                              ? goToDailyReport()
                              :index==2
                              ?goToStockReport()
                              :index==3
                              ?goToCustomerLedger()
                              :index==4
                              ?goToBankBook()
                              :index==5
                              ?goToGeneralLedger():
                          index==6
                              ?goToCardexReport()
                              :print("WIP");
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(gridsIcons[index],height: 40,width: 40,),
                            const SizedBox(width: 5,),
                            Container(
                              margin: const EdgeInsets.only(left: 15.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      grids[index],
                                      style: PetroSoftTextStyle.style15Black
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(width: 40,
                                child: Divider(thickness:2.0,color: ColorsForApp.secondary,))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
       ),
    );
  }
  Future<bool?> _willPopCallback()async{
    return Navigator.of(context).push(CupertinoPageRoute<bool>(builder: (BuildContext context) {return  const Dashboard();}));
    // return true if the route to be popped
  }
  resetVal() async {



  }
  goToShiftSaleReport(){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const OwnerShiftSaleReport()));

  }
  goToDailyReport() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const DailySalesSummaryReport()));
  }
  goToStockReport() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const OpeningPurchaseSalesStock()));
  }
  goToCustomerLedger(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const CustomerLedger()));
  }
  goToBankBook() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const BankBookReport()));

  }
  goToGeneralLedger() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const GeneralLedgerReport()));
  }
  goToCardexReport() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const CardexReport()));
  }

}

