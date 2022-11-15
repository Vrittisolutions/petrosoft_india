import 'package:petrosoft_india/AdatsoftOwner/adat_owner_drawar.dart';
import 'package:petrosoft_india/AdatsoftOwner/bank_book.dart';
import 'package:petrosoft_india/AdatsoftOwner/cash_book_summary.dart';
import 'package:petrosoft_india/AdatsoftOwner/cash_credit_sale_report.dart';
import 'package:petrosoft_india/AdatsoftOwner/customer_ledger.dart';
import 'package:petrosoft_india/AdatsoftOwner/outstanding_list.dart';
import 'package:petrosoft_india/AdatsoftOwner/patti_register.dart';
import 'package:petrosoft_india/AdatsoftOwner/sale_register.dart';
import 'package:petrosoft_india/AdatsoftOwner/supplier_ledger.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/widget/background.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class AdatOwnerHomePage extends StatefulWidget {
  const AdatOwnerHomePage({Key? key}) : super(key: key);

  @override
  _AdatOwnerHomePageState createState() => _AdatOwnerHomePageState();
}
const simpleBehavior = true;
class _AdatOwnerHomePageState extends State<AdatOwnerHomePage> {

  String? _customerLedger="0.00" ;
  String? _supplierLedger="0.00" ;
  String? _bankBook="0.00" ;
  String? _cashBook="0.00" ;
  final String _outsandingList="";
  String? _pattiRegister="0.00" ;
  String? _saleRegister="0.00" ;

  String? dSrNo;

  //Icons.food_bank_rounded;
  List<String> grids = [
    "Customer Ledger",
    "Supplier Ledger ",
    "Bank Book",
    "Cash Book",
    "Outstanding List",
    "Patti Register ",
    "Sale Register ",
  ];
  List gridsIcons = [
   CupertinoIcons.archivebox,
    CupertinoIcons.today_fill,
    CupertinoIcons.money_dollar_circle,
    CupertinoIcons.money_dollar_circle,
    CupertinoIcons.list_bullet_below_rectangle,
    CupertinoIcons.line_horizontal_3_decrease,
    CupertinoIcons.list_bullet,
  ];
  DateTime? selectedDate = DateTime.now();
  Color kPrimaryLightColor = const Color(0xFFF1E6FF);
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

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorsForApp.app_theme_color_light_owner,
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
        appBar:  AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title:  Text(UT.firm_name!,style:  StyleForApp.text_style_bold_14_white,),
            backgroundColor: ColorsForApp.appThemeColorAdatOwner),
          body: SingleChildScrollView(
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
                                      openDatePicker(context);
                                    },
                                    child: Row(
                                      children: [
                                        Padding(padding: const EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.date_range_rounded,
                                                color: ColorsForApp.icon_owner,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text("$displayDateFormat",style: StyleForApp.text_style_bold_14_owner_icon),
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
                        padding: const EdgeInsets.only(left: 9.0,right: 9.0, top: 5),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: grids.length,
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 5),
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
                                        ? goToSCustLedgerPage()
                                        : index==1
                                        ? goToSupLedgerPage()
                                        :index==2
                                        ?goToBankBook()
                                        :index==3
                                        ?goToCashBook()
                                        :index==4
                                        ?goToOutstandingList()
                                        :index==5
                                        ?goToPattiRegister()
                                        :index==6
                                        ?goToSaleRegister()
                                        : print("WIP");

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Center(
                                      // height: 140,
                                      // width: 140,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                            child: Icon(gridsIcons[index]),

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
                                                ?"\u{20B9}"+ _customerLedger.toString()
                                                : index == 1
                                                ? "\u{20B9}"+_supplierLedger.toString()
                                                : index == 2
                                                ? "\u{20B9}"+_bankBook.toString()
                                                : index == 3
                                                ?"\u{20B9}"+_cashBook.toString()
                                                : index == 4
                                                ? _outsandingList.toString()
                                                : index == 5
                                                ?"\u{20B9}"+ _pattiRegister.toString()
                                                : index == 6
                                                ? "\u{20B9}"+_saleRegister.toString()
                                                : "0.00",


                                            style: StyleForApp.text_style_normal_14_owner
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

          drawer: const AdatOwnerDrawer()),
    );

  }

  Future<bool?> exitAppDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(titleTextStyle: StyleForApp.text_style_bold_14_owner_icon,
        title: const Text("Logout"),
        content: const Text("Are you sure you want to exit from AdatOwner app?"),
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
                    primary: ColorsForApp.appThemeColorAdatOwner,
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
    var _url = UT.APIURL! +
        "api/AdatOwnerHome/Get?year=" + UT.curyear! + "&shop=" + UT.shop_no! + "&date=" + "${UT.m['saledate']}";
    var data = await UT.apiDt(_url);
    print("data-->$data");

      _customerLedger= await UT.converter(data[0]["cust"]);
      _supplierLedger = await UT.converter(data[0]["supp"]);
      _bankBook = await UT.converter(data[0]["bank"]);
      _cashBook = await UT.converter(data[0]["cash"]);
      // _outsandingList = await UT.converter(data[0]["patti"]);
      _pattiRegister = await UT.converter(data[0]["patti"]);
      _saleRegister = await UT.converter(data[0]["bill"]);

    setState(() {

    });
  }

  goToSCustLedgerPage(){
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const CustomerLedger()));

  }


  goToSupLedgerPage() async {
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
                  const SupplierLedger()));
  }
  goToBankBook() async {
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const BankBook()));

  }
  goToCashBook() async {
    //GetOTREData(string firmno, string _curyear, string dsrno, string exp_rect,string cashCD)
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const CashBookSummary()));
  }
  goToOutstandingList(){

       Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const OutstandingList()));

  }
  goToSaleRegister() async {
    print(UT.Setup("CustBlEn"));
    if (UT.Setup("CustBlEn") == "No") {

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const SaleRegister()));
    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const CashCreditSaleReport()));
    }



  }
  goToPattiRegister() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const PattiRegister()));


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

