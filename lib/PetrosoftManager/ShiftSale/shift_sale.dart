import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/generate_shift.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/manager_cash_details.dart';
import 'package:petrosoft_india/PetrosoftManager/manager_home_page.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/card_sale.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/manager_creditSale.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/expense_receipt_deposit.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/product_sale.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/pump_sale.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petrosoft_india/common_home_page.dart';

import '../../Classes/converter.dart';
class ManagerShiftSalePage extends StatefulWidget {
  const ManagerShiftSalePage({Key? key }) : super(key: key);

  @override
  _ManagerShiftSalePageState createState() => _ManagerShiftSalePageState();
}

class _ManagerShiftSalePageState extends State<ManagerShiftSalePage> {
  double _petroSale =0;
  double _prodSale = 0;
  double _credSale = 0;
  double _cardSale = 0;
  double _rectamt = 0;
  double _expense = 0;
  double _deposit = 0;
  double balWithShiftManager = 0;
  double _cashBalance=0;
  double _cashSale=0;
  double cashDetailsTotal=0;
  double _totalAmount=0;
  final slipNoController=TextEditingController();

  //Icons.food_bank_rounded;
  List<String> grids = [
    "Pump Sale",
    "other Product Sale",
    "Credit Sale",
    "Petro/Credit Card",
    "Cash Sale",
    "Other Receipt",
    "Other Expense",
    "Bank Deposit",
    "Bal with shift manager",
    "Cash Details"
  ];

  List<String> gridsIcons = [
    PetroSoftAssetFiles.pumpSale,
    PetroSoftAssetFiles.productSale,
    PetroSoftAssetFiles.creditSale,
    PetroSoftAssetFiles.cardSale,
    PetroSoftAssetFiles.cashBalance,
    PetroSoftAssetFiles.customerRecipit,
    PetroSoftAssetFiles.expense,
    PetroSoftAssetFiles.bankDeposit,
    PetroSoftAssetFiles.balWithManager,
    PetroSoftAssetFiles.cashBalance,
  ];

  String? displayDateFormat;
  dynamic api;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(UT.m["saledate"]!=null){
      DateTime date1 = DateTime.parse(UT.m["saledate"]);
      displayDateFormat=UT.displayDateConverter(date1);
    }
    api=callAllApi();
  }
  callAllApi() async {
    await getMaxNo();
    getAcMast();
    getItemList();
    return true;

  }

  Future getMaxNo()async{
    print("old slip no-->${UT.m["slipNoOld"]}");
    if(UT.m["slipNoOld"]!=null){
      print("mew slip no-->${UT.m["slipNoOld"]}");
      UT.m["slipNoOld"]=UT.m["slipNoOld"];
      slipNoController.text=UT.m["slipNoOld"].padLeft(5,'0');
     // DialogBuilder(context).showLoadingIndicator('');
      await getLastSlipNo(UT.m["slipNoOld"]);
    }else{
      print("else slip no-->${UT.m["slipNoOld"]}");
      var _url = UT.APIURL! +
          "api/PumpTrnE/GetMaxNo?curyear=" +
          UT.curyear! +
          "&shop="+UT.shop_no.toString();
      var data = await UT.apiStr(_url);
      print("latest Slip No-->$data");
      int slipNo=int.parse(data)-1;
     // UT.m["slipNoOld"]=slipNo.toString().padLeft(5,'0');
      slipNoController.text=slipNo.toString().padLeft(5,'0');

      // DialogBuilder(context).showLoadingIndicator('');
      await getLastSlipNo(slipNoController.text);
    }

  }

  getLastSlipNo(String srno ) async {
    //TOdO : this logic for hinding dialog after slip no chnaged


      var _url = UT.APIURL! +
          "api/PumpTrnE/CalcGetPumpHD?cyear=" +
          UT.curyear! +
          "&cshop=" +
          UT.shop_no! +
          "&csrno=$srno";
      print(_url);
      var data = await UT.apiDt(_url);
      print(data);
      for(int i=0;i<data.length;i++){
        setState(() {
          UT.m["slipNoOld"]=slipNoController.text;
          UT.m['shift']=data[i]["shift"];
          _petroSale = double.parse(data[i]["pump_amt"].toStringAsFixed(2));
          _prodSale = double.parse(data[i]["othprod_am"].toStringAsFixed(2));
          _credSale = double.parse(data[i]["credsale"].toStringAsFixed(2));
           _cashSale = double.parse(data[i]["cashsale"].toStringAsFixed(2));
          _cardSale = double.parse(data[i]["batch_amt"].toStringAsFixed(2));
          _rectamt = double.parse(data[i]["othincome"].toStringAsFixed(2));
          _expense = double.parse(data[i]["othexp"].toStringAsFixed(2));
          _deposit = double.parse(data[i]["othbnkdpt"].toStringAsFixed(2));
          _cashBalance=double.parse(data[i]["cashbal"].toStringAsFixed(2));
          balWithShiftManager=double.parse(data[i]["diffamt"].toStringAsFixed(2));
          var rs = (UT.Flt(data[i]["rs_500"]) * 500) + (UT.Flt(data[i]["rs_200"]) * 200) + (UT.Flt(data[i]["rshund"]) * 100) + (UT.Flt(data[i]["rsfifty"]) * 50);
          rs += (UT.Flt(data[i]["rs_2000"]) * 2000) + (UT.Flt(data[i]["rs_20"]) * 20) + (UT.Flt(data[i]["rsten"]) * 10);
          rs += (UT.Flt(data[i]["rsfive"]) * 5)  + (UT.Flt(data[i]["_coin10"]) * 10) + (UT.Flt(data[i]["_coin5"]) * 5)  + UT.Flt(data[i]["coins"]);
          double tot=_petroSale-_prodSale-_credSale-_cardSale-_expense-_deposit;
          _totalAmount=tot+_rectamt;
          cashDetailsTotal=rs;
          UT.m["saledate"]=data[i]["date"];
          DateTime date1 = DateTime.parse(data[i]["date"]);
          displayDateFormat=UT.displayDateConverter(date1);
        });

      }


   //  DialogBuilder(context).hideOpenDialog();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:  AppBar(
        //backgroundColor: PetroManagerAppTheme.blueColor,
        backgroundColor: ColorsForApp.appThemeColor,
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        centerTitle: false,
        titleSpacing: 0.0,
        title:  Text(
              'Shift Sale',
              style: PetroSoftTextStyle.style17White,
            ),
        /*shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),*/
            actions: [
              Row(
                children: [
                  Image.asset(PetroSoftAssetFiles.calender,height: 20,width: 20,),
                  const SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(displayDateFormat!),
                  ),
                ],
              )
            ],
        /* leading: InkWell(
              onTap: () {},
              child: Icon(
                Icons.subject,
                color: Colors.white,
              ),
            ),*/
       /* bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: getAppBottomView()),*/
      ),

        body: FutureBuilder(
            future: api,
            builder: (context,snapshot){
           if(snapshot.hasData){
             return  Column(
               children: [
                 const SizedBox(height: 10,),
                 getAppBottomView(),
                 Expanded(
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: GridView.builder(
                       shrinkWrap: true,
                       physics: const AlwaysScrollableScrollPhysics(),
                       itemCount: grids.length,
                       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                         maxCrossAxisExtent: 200,
                         childAspectRatio: 3 / 2,
                         // crossAxisCount: 2,
                         mainAxisSpacing: 10,
                         crossAxisSpacing: 10,
                       ),
                       itemBuilder: (BuildContext context, int index) {
                         return Container(
                           width: MediaQuery.of(context).size.width,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20),
                             // border: Border.all(color:Colors.grey.shade300),
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
                             /*   boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade100,
                                blurRadius: 1.0,
                                spreadRadius: 1.0, //extend the shadow
                                offset: const Offset(
                                  3.0, // Move to right 10  horizontally
                                  3.0, // Move to bottom 5 Vertically
                                ),
                              ),
                            ],*/
                           ),
                           child: InkWell(
                               onTap: () async {
                                 index == 0
                                     ? goToPumpSalePage()
                                     : index==1
                                     ? goToProductSalePage()
                                     :index==2
                                     ?goToCreditSalePage()
                                     :index==3
                                     ?goToCardSalePage()
                                     :index==4
                                     ?print("wip")
                                     :index==5
                                     ?goToReceiptPage()
                                      :index==6
                                     ?goToExpensePage()
                                     :index==7
                                     ?goToBankDeposit()
                                     : index==8
                                     ?print("WIP")
                                     :index==9
                                     ?goToCashDetails()
                                     :print("WIP");
                               },
                               child: Padding(
                                 padding: const EdgeInsets.all(5.0),
                                 child: Center(
                                   child: Column(
                                     mainAxisAlignment:
                                     MainAxisAlignment
                                         .spaceBetween,
                                     children: [
                                       Image.asset(gridsIcons[index],height: 40,width: 40,),
                                       /*Container(
                                        padding: const EdgeInsets.all(8.0),
                                        height: 30,width: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorsForApp.appThemePetroOwner
                                        ),
                                        child: Icon(
                                          gridsIcons[index],
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),*/
                                       Text(
                                           grids[index],
                                           style:PetroSoftTextStyle.style15Black
                                       ),
                                       SizedBox(width: 40,
                                         child: Divider(thickness:2.0,color: ColorsForApp.secondary,),),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Image.asset(PetroSoftAssetFiles.rupees,height: 17,width: 17,),
                                           Text(
                                               index == 0
                                                   ? _petroSale.toStringAsFixed(2)
                                                   .toString()
                                                   : index == 1
                                                   ? _prodSale.toStringAsFixed(2)
                                                   .toString()
                                                   : index == 2
                                                   ? _credSale.toStringAsFixed(2)
                                                   .toString()
                                                   : index == 3
                                                   ? _cardSale.toStringAsFixed(2)
                                                   .toString()
                                                   : index == 4
                                                   ? _cashSale.toStringAsFixed(2)
                                                   .toString()
                                                   : index == 5
                                                   ?_rectamt.toStringAsFixed(2)
                                                   .toString()
                                                   : index == 6
                                                   ? _expense.toStringAsFixed(2).toString()
                                                   : index == 7
                                                   ? _deposit.toStringAsFixed(2).toString()
                                                   : index == 8
                                                   ? balWithShiftManager.toStringAsFixed(2).toString()
                                                   : cashDetailsTotal.toStringAsFixed(2),
                                             style: TextStyle(
                                                 fontSize: 20,
                                                 fontWeight: FontWeight.w400,
                                                 foreground: Paint()..shader = const LinearGradient(
                                                   colors: <Color>[
                                                     Color(0xff00487C),
                                                     Color(0xff84E4FF),
                                                     //add more color here.
                                                   ],
                                                 ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0))
                                             ),),
                                         ],
                                       )

                                     ],
                                   ),
                                 ),
                               )),
                         );
                       },
                     ),
                   ),
                 ),
               ],
             );
           }else{
             return Center(child: CommonWidget.circularIndicator());
           }
         },
          ),
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
  Widget getAppBottomView() {
    return Container(
      padding: const EdgeInsets.only(left: 20, bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100,
              height: 50,
             /* decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color:Colors.grey.shade300),
                color: Colors.white,
              ),*/
              child:  TextFormField(
                controller: slipNoController,
                keyboardType: TextInputType.number,
                autofocus: false,
                readOnly: true,
                enabled: false,
                style:StyleForApp.text_style_normal_14_black ,
                decoration:InputDecoration(
                  hintText: "Slip No",
                  labelText: 'Slip No',
                  labelStyle: StyleForApp.text_style_normal_14_black,
                  hintStyle: StyleForApp.text_style_normal_14_black,
                 // fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                       //color: Colors.white,
                    ),
                  ),
                  /*enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),*/
                ),
                onFieldSubmitted: (value){
                  UT.m["slipNoOld"]=value;
                  DialogBuilder(context).showLoadingIndicator('');
                  getLastSlipNo(value);

                },
              ),
            ),
            Container(
              width: 50,
              height: 50,
              /* decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color:Colors.grey.shade300),
                color: Colors.white,
              ),*/
              child:  TextFormField(
                readOnly: true,
                enabled: false,
                autofocus: false,
                style:StyleForApp.text_style_normal_14_black ,
                decoration:InputDecoration(
                  hintText: "Slip No",
                  labelText: UT.m['shift'],
                  labelStyle: StyleForApp.text_style_normal_14_black,
                  hintStyle: StyleForApp.text_style_normal_14_black,
                  // fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      // color: Colors.blue,
                    ),
                  ),
                  /*enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),*/
                ),
                onFieldSubmitted: (value){
                  UT.m["slipNoOld"]=value;
                  DialogBuilder(context).showLoadingIndicator('');
                  getLastSlipNo(value);

                },
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const GenerateShift()));
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorsForApp.secondary,
                      ColorsForApp.secondary.withOpacity(0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black12,
                      offset: const Offset(5, 5),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'New Shift',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _willPopCallback()async{
    UT.m["slipNoOld"]=null;
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return  const Dashboard();
    }));
    // return true if the route to be popped
  }

  //Todo: API call
  getAcMast() async {
    var _url = UT.APIURL! +
        "api/AccountMaster/GetAcMast?curyear=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&Where=len(acno) >= 6";
    UT.mastData= await UT.apiDt(_url);
  }
  getItemList() async {
    var _url = UT.APIURL! +
        "api/ItemEnt9P/GetData?shop=${UT.shop_no}&Where=isdeleted<>'Y' order by item_code";
    UT.itemList = await UT.apiDt(_url);

  }

  //Todo: Navigation route
  goToPumpSalePage(){
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const MangerPumpSalePage()));

  }
  goToCardSalePage(){
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ManagerCreditCardSale()));

  }
  goToCreditSalePage() async {
    UT.m["slipNoOld"]=UT.m["slipNoOld"];

    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ManagerCreditSale()));

  }
  goToReceiptPage() async {
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const ManagerExpReceiptBankDeposit(title:"Receipt")));

  }
  goToBankDeposit() async {
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const ManagerExpReceiptBankDeposit(title:"Deposit")));

  } goToCashDetails() async {
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const ManagerCashDetails()));

  }
  goToProductSalePage(){
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ManagerProductSale()));

  }
  goToExpensePage() async {
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ManagerExpReceiptBankDeposit(title:"Expense")));
  }

}

