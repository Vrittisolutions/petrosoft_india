import 'package:petrosoft_india/AdatsoftSeller/acc_statement.dart';
import 'package:petrosoft_india/AdatsoftSeller/memo_list.dart';
import 'package:petrosoft_india/AdatsoftSeller/patti_details.dart';
import 'package:petrosoft_india/AdatsoftSeller/payment_details.dart';
import 'package:petrosoft_india/AdatsoftSeller/seller_drawer.dart';
import 'package:petrosoft_india/AdatsoftSeller/seller_item_rates.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/receipt_entry.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AdatSellerHomePage extends StatefulWidget {
  const AdatSellerHomePage({Key? key}) : super(key: key);

  @override
  _AdatSellerHomePageState createState() => _AdatSellerHomePageState();
}
const simpleBehavior = true;
class _AdatSellerHomePageState extends State<AdatSellerHomePage> {

  final double _rateMaster = 0;
  final double _memoEntry = 0;
  final double _pattiDetails = 0;
  final double _paymentDetails = 0;
  final double _accStatement = 0;

  //Icons.food_bank_rounded;
  List<String> grids = [
    "Memo Entry",
    "Item Rates",
    "Account Statement",
    "Payment Details",
    "Patti Details",
  ];
  List gridsIcons = [
    CupertinoIcons.calendar_badge_plus,
    CupertinoIcons.bag_fill_badge_plus,
    CupertinoIcons.chart_bar_square_fill,
    CupertinoIcons.doc_chart_fill,
    CupertinoIcons.doc_text_fill,
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
     sendDateToApi = UT.dateConverter(selectedDate);
     return WillPopScope(
      onWillPop:  ()async {
        exitAppDialog();
        return true;
      },
      child: Scaffold(
          //backgroundColor: UT.BACKGROUND_COLOR,
          appBar:  AppBar(
            backgroundColor: UT.adatSoftSellerAppColor,
            elevation: 0,
            iconTheme: StyleForApp.iconThemeData,
            title: CommonAppBarText(title: UT.firm_name!),
       actions: [
        IconButton(
        onPressed: () {
          UT.SPF!.setBool("islogin", false);
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
         icon: const Icon(Icons.exit_to_app))
  ],
),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
             // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10,),
                InkWell(
                  onTap: () async {
                    openDatePicker(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Container(
                       alignment: Alignment.center,
                       height: 50,
                       decoration: BoxDecoration(
                         //  border: Border.all(width:2,color: Color(0xFF003b4c)),
                         borderRadius: BorderRadius.circular(30.0),
                       ),
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 const Icon(
                                   Icons.date_range_rounded,
                                   color: Colors.black,
                                 ),
                                 const SizedBox(
                                   width: 10,
                                 ),
                                 Text("$displayDateFormat",style: const TextStyle(fontSize:18,color: Colors.black,fontWeight:FontWeight.bold),)
                               ],
                             ),
                           ],
                         ),
                       ),
                     ),
                   ],
                  ),
                ),
                //const SizedBox(height: 30,),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 15.0),
                        child: GridView.builder(
                         // physics: NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 3 / 2,
                           // crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                             // height: 200,
                             // width: 200,
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
                                        ? goToMemoEntryPage()
                                         : index==1
                                        ? goToRateMaster()
                                    :index==2
                                    ?goToAccStatementPage()
                                   :index==3
                                        ?goToPaymentDeatils()
                                        :index==4
                                    ?goToPattiDetails()
                                        :index==5
                                    ?goToPattiDetails()
                                        : print("WIP");

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                     // height: 140,
                                     // width: 140,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        children: [
                                          Container(
                                            height: 30,
                                           child: Icon(
                                             gridsIcons[index],
                                               color: Colors.grey.shade600),
                                            /*decoration: BoxDecoration(
                                              image: DecorationImage(image: AssetImage(gridsIcons[index]))
                                            ),*/
                                          ),
                                          const SizedBox(
                                            height: 0,
                                          ),
                                          Text(
                                            grids[index],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight:
                                                    FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 0,
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            thickness: 1.0,
                                          ),
                                          const SizedBox(
                                            height: 0,
                                          ),
                                          Text(
                                            index == 0
                                                ?"\u{20B9}"+ _memoEntry.toStringAsFixed(2)
                                                : index == 1
                                                    ? "\u{20B9}"+_rateMaster.toStringAsFixed(2)
                                                    : index == 2
                                                        ? "\u{20B9}"+_accStatement.toStringAsFixed(2)
                                                        : index == 3
                                                            ?"\u{20B9}"+ _paymentDetails.toStringAsFixed(2)
                                                            : index == 4
                                                                ? "\u{20B9}"+_pattiDetails.toStringAsFixed(2)
                                                              : "0",

                                            style:  StyleForApp.text_style_normal_14_owner,
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
          drawer: const AdatSellerDrawer()),
    );

  }

  Future<bool?> exitAppDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(titleTextStyle: TextStyle(fontWeight:FontWeight.bold,fontSize:17,color: UT.ownerAppColor),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to exit from AdatSeller app"),
        actions: <Widget>[
          ButtonBar(
            buttonMinWidth: 100,
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.grey.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    textStyle: const TextStyle(
                        color:Colors.black ,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                child: const Text("No",style: TextStyle(
                    color:Colors.black ,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: UT.adatSoftSellerAppColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    textStyle: const TextStyle(
                        color:Colors.white ,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
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

  goToMemoEntryPage(){
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const MemoEntry()));

  }


  goToAccStatementPage() async {
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const AdatSellerAccStatement()));
  }
  goToPaymentEntry() async {
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const AdatSellerAccStatement()));

  }
  goToPattiDetails() async {
    //GetOTREData(string firmno, string _curyear, string dsrno, string exp_rect,string cashCD)
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const PattiDetails()));
  }
  goToRateMaster(){
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const SellerItemRates()));

  }
  goToPaymentDeatils() async {
     Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const PaymentDetails()));
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

