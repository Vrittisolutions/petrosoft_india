import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOperator/bloc/home_page_event.dart';
import 'package:petrosoft_india/PetrosoftOperator/bloc/home_page_state.dart';
import 'package:petrosoft_india/PetrosoftOperator/cash_details.dart';
import 'package:petrosoft_india/PetrosoftOperator/dsr_product_sale.dart';
import 'package:petrosoft_india/common_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/PetrosoftOperator/card_sale.dart';
import 'package:petrosoft_india/PetrosoftOperator/dsr_credit_sale.dart';
import 'package:petrosoft_india/PetrosoftOperator/dsr_receipt_expense_bank.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/drawar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petrosoft_india/PetrosoftOperator/pump_reading.dart';
import 'package:upgrader/upgrader.dart';

import 'bloc/APICall/home_repository_impl.dart';
import 'bloc/home_page_bloc.dart';


class PetroSoftOperatorHomePage extends StatefulWidget {
  const PetroSoftOperatorHomePage({Key? key}) : super(key: key);

  @override
  OperatorHomePageState createState() => OperatorHomePageState();
}
const simpleBehavior = true;
class OperatorHomePageState extends State<PetroSoftOperatorHomePage> {

  String _petrosale = "0";
  String? _allowChange ;
  String _prodsale = "0";
  String _credsale = "0";
  String _cardsale = "0";
  String _rectamt = "0";
  String _expense = "0";
  String _deposit = "0";
  double _totrect = 0;
  double _totvou = 0;
  String totalCash = "0";
  String cashDiff = "0";
  double _totalAmount=0;
  String? dSrNo;

  //Icons.food_bank_rounded;
  List<String> grids = [
    "Pump Sale",
    "Product Sale",
    "Credit Sale",
    "Card Sale",
    "Receipt",
    "Bank Deposit",
    "Expense",
    "Cash Details",
    "Difference"
  ];


  List<String> gridsIcons = [
    PetroSoftAssetFiles.pumpSale,
    PetroSoftAssetFiles.productSale,
    PetroSoftAssetFiles.creditSale,
    PetroSoftAssetFiles.cardSale,
    PetroSoftAssetFiles.customerRecipit,
    PetroSoftAssetFiles.expense,
    PetroSoftAssetFiles.bankDeposit,
    PetroSoftAssetFiles.cashBalance,
    PetroSoftAssetFiles.cashBalance,
  ];
  List<DropdownMenuItem<String>> items = [
    const DropdownMenuItem(
      child: const Text("I"),
      value: "I",
    ),
    const DropdownMenuItem(
      child: const Text("II"),
      value: "II",
    ),
    const DropdownMenuItem(
      child: Text("III"),
      value: "III",
    ),
    const DropdownMenuItem(
      child: Text("IV"),
      value: "IV",
    ),
    const DropdownMenuItem(
      child: Text("V"),
      value: "V",
    ),
  ];

  var _seleShift = "I";

  DateTime? selectedDate = DateTime.now();

  double cashDetailsTotal=0;

  var api;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(UT.m["saledate"]!=null &&  UT.m['shift']!=null){
      DateTime date1 = DateTime.parse(UT.m["saledate"]);
      displayDateFormat=UT.displayDateConverter(date1);
      _seleShift=UT.m['shift'];
    }else{
      sendDateToApi = UT.dateConverter(selectedDate);
      displayDateFormat=UT.displayDateConverter(selectedDate);
      UT.m['saledate']=sendDateToApi;
    }
    api=resetVal();
  }
  void _onScroll() {
     context.read<HomePageBloc>().add(HomePageDataFetched());
  }
  String? sendDateToApi;
  String? displayDateFormat;

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorsForApp.appThemeColor,
      statusBarBrightness: Brightness.dark,
    ));

     sendDateToApi = UT.dateConverter(selectedDate);
     //displayDateFormat = UT.displayDateConverter(selectedDate);
     Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title:  Text(UT.firm_name!, style: PetroSoftTextStyle.style17White,), backgroundColor: ColorsForApp.appThemeColor,
            actions: [
              Row(
                children: [
                  Image.asset(PetroSoftAssetFiles.calender,height: 20,width: 20,),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: (){
                      openDatePicker(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(displayDateFormat!),
                    ),
                  ),
                ],
              )
            ],),
          body:






         /* BlocProvider(
            create: (context) => HomePageBloc(HomeRepositoryImpl()),
            child:  SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child:
                Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: ColorsForApp.appThemePetroOwner,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text("Slip No : ${dSrNo ?? ''}",style: PetroSoftTextStyle.style20AppColor,),
                                    //color: Colors.blueGrey.shade50,
                                  ),
                                  const SizedBox(width: 15,),
                                  Container(
                                      height: 30,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(color: Colors.black12)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: DropdownButton(
                                          isExpanded: true,
                                          items: items,
                                          underline: Container(),
                                          hint: const Text("Select Shift"),
                                          value: _seleShift,
                                          onChanged: (val) async {
                                            _seleShift = val.toString();
                                            UT.m['shift']=_seleShift;
                                            setState(() {});
                                          },
                                        ),
                                      )
                                  ),
                                  const SizedBox(width: 5,),

                                  Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child:
                                      IconButton(
                                        icon: Icon(Icons.refresh, color: ColorsForApp.icon_operator,),
                                        onPressed: () {
                                          api= resetVal();
                                        },

                                      )

                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                    BlocBuilder<HomePageBloc,HomePageState>(
                      builder: (context,state){
                        if(state is HomePageInitial){
                          print('loading');
                          return showLoader();
                        }else if (state is HomePageDataLoaded) {
                          print(state.data);
                          return  SizedBox(
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
                                        mainAxisSpacing: 10),
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                          gradient:  LinearGradient(
                                            colors: [const Color(0xFFD5ECAE), ColorConverter.hexToColor("#DBF4A7").withOpacity(0.1),],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color:Colors.grey.shade100,
                                                blurRadius: 1,
                                                spreadRadius: 0,
                                                offset: Offset(2.0, 2.0)
                                            )
                                          ],
                                        ),
                                        child: InkWell(
                                            onTap: () async {
                                              if(_allowChange=="No"){
                                                Fluttertoast.showToast(msg: "User does not have access to change old entry");
                                              }else{
                                                index == 0
                                                    ? goToPumpSalePage()
                                                    : index==1
                                                    ? goToProductSalePage()
                                                    :index==2
                                                    ?goToCreditSalePage()
                                                    :index==3
                                                    ? goToCardSalePage()
                                                    :index==4
                                                    ?goToReceiptPage()
                                                    :index==5
                                                    ?goToCashDeposit()
                                                    :index==6
                                                    ?goToExpense()
                                                    :index==7
                                                    ?goToCashDetails()
                                                    : print("WIP");
                                              }

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
                                                    Image.asset(gridsIcons[index],height: 40,width: 40,),
                                                    Text(
                                                        grids[index],
                                                        style: StyleForApp.text_style_normal_14_black
                                                    ),
                                                    SizedBox(width: 40,
                                                      child: Divider(thickness:2.0,color: ColorsForApp.secondary,),),

                                                    Text(
                                                      index == 0
                                                          ?"\u{20B9}"+ _petrosale
                                                          .toString()
                                                          : index == 1
                                                          ? "\u{20B9}"+_prodsale
                                                          .toString()
                                                          : index == 2
                                                          ? "\u{20B9}"+_credsale
                                                          .toString()
                                                          : index == 3
                                                          ?"\u{20B9}"+ _cardsale
                                                          .toString()
                                                          : index == 4
                                                          ? "\u{20B9}"+_rectamt
                                                          .toString()
                                                          : index == 5
                                                          ?"\u{20B9}"+ _deposit.toString()
                                                          : index == 6
                                                          ? "\u{20B9}"+_expense.toString()
                                                          : index == 7
                                                          ? "\u{20B9}"+totalCash.toString()
                                                          : index == 8
                                                          ?"\u{20B9}"+cashDiff.toString()
                                                          :"0",
                                                      style: StyleForApp.text_style_normal_16_owner,
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
                                  )));
                        }else{
                          print('loading else');
                          return showLoader();
                        }
                      },
                    ),

                   SizedBox(height: 10,)
                  ],
                )
            ),
          ),*/


          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child:
            Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ColorsForApp.appThemePetroOwner,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text("Slip No : ${dSrNo ?? ''}",style: PetroSoftTextStyle.style20AppColor,),
                                //color: Colors.blueGrey.shade50,
                              ),
                              const SizedBox(width: 15,),
                              Container(
                                  height: 30,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(color: Colors.black12)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      items: items,
                                      underline: Container(),
                                      hint: const Text("Select Shift"),
                                      value: _seleShift,
                                      onChanged: (val) async {
                                        _seleShift = val.toString();
                                        UT.m['shift']=_seleShift;
                                        setState(() {});
                                      },
                                    ),
                                  )
                              ),
                              const SizedBox(width: 5,),

                              Padding(
                                  padding: const EdgeInsets.only(left: 0.0),

                                  child:
                                  IconButton(
                                    icon: Icon(Icons.refresh, color: ColorsForApp.icon_operator,),
                                    onPressed: () {
                                      api= resetVal();
                                    },

                                  )

                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
                FutureBuilder<bool>(
                  future: api,
                 builder: (context,snapshot){
                    if(snapshot.hasData){

                  return SizedBox(
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
                                 mainAxisSpacing: 10),
                             itemBuilder: (BuildContext context, int index) {
                               return Container(
                                 width: MediaQuery.of(context).size.width,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10),
                                   color: Colors.white,
                                   gradient:  LinearGradient(
                                     colors: [const Color(0xFFD5ECAE), ColorConverter.hexToColor("#DBF4A7").withOpacity(0.1),],
                                     begin: Alignment.topCenter,
                                     end: Alignment.bottomCenter,
                                   ),
                                   boxShadow: [
                                     BoxShadow(
                                         color:Colors.grey.shade100,
                                         blurRadius: 1,
                                         spreadRadius: 0,
                                         offset: Offset(2.0, 2.0)
                                     )
                                   ],
                                 ),
                                 child: InkWell(
                                     onTap: () async {
                                       if(_allowChange=="No"){
                                         Fluttertoast.showToast(msg: "User does not have access to change old entry");
                                       }else{
                                         index == 0
                                             ? goToPumpSalePage()
                                             : index==1
                                             ? goToProductSalePage()
                                             :index==2
                                             ?goToCreditSalePage()
                                             :index==3
                                             ? goToCardSalePage()
                                             :index==4
                                             ?goToReceiptPage()
                                             :index==5
                                             ?goToCashDeposit()
                                             :index==6
                                             ?goToExpense()
                                             :index==7
                                             ?goToCashDetails()
                                             : print("WIP");
                                       }

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
                                             Image.asset(gridsIcons[index],height: 40,width: 40,),
                                             Text(
                                                 grids[index],
                                                 style: StyleForApp.text_style_normal_14_black
                                             ),
                                             SizedBox(width: 40,
                                               child: Divider(thickness:2.0,color: ColorsForApp.secondary,),),

                                             Text(
                                               index == 0
                                                   ?"\u{20B9}"+ _petrosale
                                                   .toString()
                                                   : index == 1
                                                   ? "\u{20B9}"+_prodsale
                                                   .toString()
                                                   : index == 2
                                                   ? "\u{20B9}"+_credsale
                                                   .toString()
                                                   : index == 3
                                                   ?"\u{20B9}"+ _cardsale
                                                   .toString()
                                                   : index == 4
                                                   ? "\u{20B9}"+_rectamt
                                                   .toString()
                                                   : index == 5
                                                   ?"\u{20B9}"+ _deposit.toString()
                                                   : index == 6
                                                   ? "\u{20B9}"+_expense.toString()
                                                   : index == 7
                                                   ? "\u{20B9}"+totalCash.toString()
                                                   : index == 8
                                                   ?"\u{20B9}"+cashDiff.toString()
                                                    :"0",
                                               style: StyleForApp.text_style_normal_16_owner,
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
                           )));
                 }
                 return const Center(child: CircularProgressIndicator(),);
               },
                ),
                SizedBox(height: 10,)
              ],
            )
          ),



          drawer: const petroDSRDrawer(),
          bottomNavigationBar: SizedBox(
              height: 80,
              width: MediaQuery.of(context).size.width,
              child:Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 0, right: 0, top: 0, bottom: 16),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Container(
                                    width:300,
                                    decoration: BoxDecoration(
                                      color: ColorConverter.hexToColor("#D7E0F9"),
                                      borderRadius: const BorderRadius.only(
                                          topLeft: const Radius.circular(8.0),
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0)),
                                      // boxShadow: <BoxShadow>[
                                      //   BoxShadow(
                                      //       color: SavangadiAppTheme.grey.withOpacity(0.2),
                                      //       offset: Offset(1.1, 1.1),
                                      //       blurRadius: 10.0),
                                      // ],
                                    ),
                                    child:
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 68, bottom: 12, right: 16, top: 12),
                                      child:
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Total Amount',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                 // fontFamily: SavangadiAppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: 0.0,
                                                  color: ColorsForApp.appThemeColor
                                                      .withOpacity(0.8),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                      text: '\u{20B9}', style: TextStyle(
                                                   // fontFamily: SavangadiAppTheme.fontName,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20,
                                                    letterSpacing: 0.0,
                                                    color: ColorsForApp.appThemeColor
                                                        .withOpacity(0.8),
                                                  ),
                                                      children: <TextSpan>[
                                                        TextSpan(text: _totalAmount.toStringAsFixed(2) ,
                                                          style:TextStyle(
                                                            //fontFamily: SavangadiAppTheme.fontName,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 18,
                                                            letterSpacing: 0.0,
                                                            color: ColorsForApp.appThemeColor
                                                                .withOpacity(0.8),
                                                          ),
                                                        ),



                                                      ]
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -12,
                                  left: -5,
                                  child: SizedBox(
                                    width: 85,
                                    height: 85,
                                    child: Image.asset(PetroSoftAssetFiles.dsrCashBalance,),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

    ),
    ),
    );
  }
  Widget showLoader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  Future<bool> getData() async {

    await resetVal();
    await Future<dynamic>.delayed(const Duration(milliseconds: 10));
    return true;
  }
  Future<bool?> _willPopCallback()async{
    UT.m["slipNoOld"]=null;
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return  const Dashboard();
    }));
    // return true if the route to be popped
  }
  Future<bool?> exitAppDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(titleTextStyle: StyleForApp.text_style_bold_14_operator_blu,
        title:  const Text("Logout"),
        content:  const Text("Are you sure you want to exit from PetroOperator app"),
        actions: <Widget>[
          ButtonBar(
            buttonMinWidth: 100,
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: ColorsForApp.app_theme_color_light_drawer_operator,
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                    textStyle: StyleForApp.text_style_bold_14_black),
                child: const Text("No",style: TextStyle( color:Colors.black ,),),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: ColorsForApp.appThemeColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    textStyle: StyleForApp.text_style_bold_14_white),
                child: const Text("YES"),
                onPressed: (){
                  SystemNavigator.pop();
                },
              ),
            ],
          ),
      ]
      )
    );
  }
  Future<bool>resetVal() async {
    if(UT.m['saledate']!=null){
      UT.m['saledate']=UT.m['saledate'];
    }else{
      UT.m['saledate']=sendDateToApi;
    }
    var _url;
    print("shift-->${UT.m['shift']}");
    if(UT.m['shift']==null){
       _url = UT.APIURL! +
          "api/PumpTrnE/GetPumpSale?saleYear=" +
          UT.curyear! +
          "&firmno=" +
          UT.shop_no! +
          "&date=" +
          "${UT.m['saledate']}" +
          "&shift=last" +
          "&cashcode="+UT.ClientAcno!;

    }else{

       _url = UT.APIURL! +
          "api/PumpTrnE/GetPumpSale?saleYear=" +
          UT.curyear! +
          "&firmno=" +
          UT.shop_no! +
          "&date=" +
          "${UT.m['saledate']}" +
          "&shift=" +
          _seleShift.toString() +
          "&cashcode="+UT.ClientAcno!;

    }
    print("Url-->$_url");
    var data = await UT.apiDt(_url);
    print("data11-->$data");
      UT.m['saledate']=data[0]["date"];
      displayDateFormat=UT.displayDateConverter(DateTime.parse(UT.m['saledate']));
      print(displayDateFormat);
      UT.m['shift']=data[0]["shift"];
      UT.m["PUMP_NO"]=data[0]['pump_no'];
      _petrosale = data[0]["petrosale"].toStringAsFixed(2);
      _prodsale = data[0]["prodsale"].toStringAsFixed(2);
      _credsale = data[0]["credsale"].toStringAsFixed(2);
      _cardsale = data[0]["cardsale"].toStringAsFixed(2);
      _rectamt = data[0]["rectamt"].toStringAsFixed(2);
      _deposit = data[0]["deposit"].toStringAsFixed(2);
      _expense = data[0]["expamt"].toStringAsFixed(2);
      var cashTot=data[0]["cash_diff"];
    if(cashTot==null){

    }else{
      cashDiff =data[0]['cash_diff'].toStringAsFixed(2);
      print("cashDiff-->$cashDiff");
    }



      var recAmt=data[0]["cash_total"];
      if(recAmt==null){

      }else{
        totalCash = data[0]["cash_total"].toStringAsFixed(2);
      }

       dSrNo=data[0]["dsrno"].toString();
      _allowChange=data[0]["allowChange"].toString();

       UT.m["dSrNo"]=dSrNo;
     // _totrect = double.parse(_petrosale) + double.parse(_prodsale) + double.parse(_rectamt);
      //_totvou = double.parse(_credsale) + double.parse(_expense) + double.parse(_cardsale);
     double tot=double.parse(_petrosale)-double.parse(_prodsale)-double.parse(_credsale)-double.parse(_cardsale)-double.parse(_expense)-double.parse(_deposit);
      _totalAmount=tot+double.parse(_rectamt);
     // _totalAmount=_totrect.toDouble()-_totvou;
      UT.m["cash_balance"]=_totalAmount.toStringAsFixed(2);
      print("Is cash detail updated-->${UT.m["cashUpdated"]}");
      if(UT.m["cashUpdated"]=="Yes"){
        double cashD=_totalAmount-double.parse(totalCash);
        cashDiff=cashD.toStringAsFixed(2);
        print("Updated cashDiff-->$cashDiff");
      }

      setState(() {});
      return true;
  }
  goToCardSalePage(){
    if(dSrNo!=""){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const CardSale()));
    }else{
      Fluttertoast.showToast(msg: "No shift generated");
    }
  }
  goToReceiptPage() async {
    print("calling receipt");
    if(dSrNo!=""){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const DsrReceiptCashDeposit(title:"Receipt")));
    }else{
      Fluttertoast.showToast(msg: "No shift generated");
    }
  }
  goToCashDeposit() async {
    //GetOTREData(string firmno, string _curyear, string dsrno, string exp_rect,string cashCD)

    if(dSrNo!=""){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const DsrReceiptCashDeposit(title:"Deposit")));
    }else{
      Fluttertoast.showToast(msg: "No shift generated");
    }
  }
  goToExpense() async {
    //GetOTREData(string firmno, string _curyear, string dsrno, string exp_rect,string cashCD)

    if(dSrNo!=""){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const DsrReceiptCashDeposit(title:"Expense")));
    }else{
      Fluttertoast.showToast(msg: "No shift generated");
    }
  }
  goToPumpSalePage(){
    if(dSrNo!=""){
      UT.m['shift']=_seleShift;
       Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const PumpReading()));
    }else{
       Fluttertoast.showToast(msg: "No shift generated");
    }
  }
  goToProductSalePage(){
    if(dSrNo!=""){
      UT.m['shift']=_seleShift;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const DsrProductSale()));
    }else{
      Fluttertoast.showToast(msg: "No shift generated");
    }
  }
  goToCreditSalePage() async {
   // String convertedDateTime = "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')}";
    UT.m['shift']=_seleShift;
    UT.m['saledate']=UT.m['saledate'];
    var _url = UT.APIURL! +
        "api/AccountMaster/GetCust?Yr=" +
        UT.curyear! +
        "&Shop=" +
        UT.shop_no!+"&Cols=acno,name,pager";
    var data = await UT.apiDt(_url);
    UT.customerList=data;
    if(dSrNo!=""){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const DsrCreditSale()));
    }else{
      Fluttertoast.showToast(msg: "No shift generated");
    }

  }
  Future<void> openDatePicker(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)))!;
    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        sendDateToApi = UT.dateConverter(selectedDate);
        displayDateFormat = UT.displayDateConverter(selectedDate);
        UT.m['saledate']=sendDateToApi;

      });
    }
  }

  goToCashDetails() {
    if(dSrNo!=""){
      UT.m['shift']=_seleShift;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
              const cashDetails()));
    }else{
      Fluttertoast.showToast(msg: "No shift generated");
    }
  }
}

