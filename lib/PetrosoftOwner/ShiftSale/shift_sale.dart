import 'package:petrosoft_india/AdatsoftOwner/AppTheame/asset_files.dart';
import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/card_sale.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/credit_sale_page.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/expense_receipt_deposit.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/product_sale.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/pump_sale.dart';
import 'package:petrosoft_india/common_home_page.dart';
import 'package:petrosoft_india/PetrosoftOwner/widget/background.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Classes/converter.dart';
class ShiftSalePage extends StatefulWidget {
  const ShiftSalePage({Key? key}) : super(key: key);

  @override
  _ShiftSalePageState createState() => _ShiftSalePageState();
}

class _ShiftSalePageState extends State<ShiftSalePage> {
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
  //final slipNoController=TextEditingController();

  var slipNo;
  //Icons.food_bank_rounded;
  List<String> grids = [
    "Pump Sale",
    "Product Sale",
    "Credit Sale",
    "Card Sale",
    "Receipt",
    "Expense",
    "Bank Deposit",
    "Cash Balance",
    "Bal with shift manager"
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
    PetroSoftAssetFiles.balWithManager,
  ];
  String? displayDateFormat;
  dynamic api;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAcMast();
    getItemList();
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
      slipNo=UT.m["slipNoOld"].padLeft(5,'0');
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
      int slipNo1=int.parse(data)-1;
      // UT.m["slipNoOld"]=slipNo.toString().padLeft(5,'0');
      slipNo=slipNo1.toString().padLeft(5,'0');

      // DialogBuilder(context).showLoadingIndicator('');
      await getLastSlipNo(slipNo);
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
        UT.m["slipNoOld"]=slipNo;
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
      //  backgroundColor: UT.BACKGROUND_COLOR,
        appBar: AppBar(
          elevation: 5,
          titleSpacing: 0.0,
          backgroundColor: ColorsForApp.appThemeColor,
          leading: IconButton(
            highlightColor: Colors.white,
            onPressed: (){
              UT.m["slipNoOld"]=null;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Dashboard()));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          /*title:  Text('Shift sale\t\t\t$displayDateFormat'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                DialogBuilder(context).showLoadingIndicator('');
                getLastSlipNo(slipNo.toString());
              },
            ),
          ],*/
          title: Text(
            'Shift sale',
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
                  child: Text(displayDateFormat!),
                ),
              ],
            )
          ],
        ),

          body: FutureBuilder(
            future: api,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.hasData){
               return Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 40,
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
                                padding: EdgeInsets.only(left: 10),
                                child: Text("Slip No : $slipNo",style: PetroSoftTextStyle.style20AppColor,),
                                //color: Colors.blueGrey.shade50,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text("Shift:${UT.m['shift']}",style: PetroSoftTextStyle.style20AppColor))
                            ],
                          ),
                        )
                    ),
                    Expanded(
                      //height: MediaQuery.of(context).size.height,
                      //width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: 9,
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
                                    index == 0
                                        ? goToPumpSalePage()
                                        : index==1
                                        ? goToProductSalePage()
                                        :index==2
                                        ?goToCreditSalePage()
                                        :index==3
                                        ?goToCardSalePage()
                                        :index==4
                                        ?goToReceiptPage()
                                        :index==5
                                        ?goToExpensePage()
                                        :index==6
                                        ?goToBankDeposit():
                                    index==6
                                        ?print("WIP"):print("WIP");
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
                                                    ? _rectamt.toStringAsFixed(2)
                                                    .toString()
                                                    : index == 5
                                                    ? _expense.toStringAsFixed(2)
                                                    .toString()
                                                    : index == 6
                                                    ? _deposit.toStringAsFixed(2).toString()
                                                    : index == 7
                                                    ? _cashBalance.toStringAsFixed(2).toString()
                                                    : index == 8
                                                    ? balWithShiftManager.toStringAsFixed(2).toString()
                                                    : "0.00",
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
                                                ),
                                              ),
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
                    // const SizedBox(height: 10,)
                  ],
                );
              }else{
                return Center(child: CommonWidget.circularIndicator());
              }
            },
          )


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

  getAcMast() async {
   /* mast = GetURLDt(APIURL + "/api/AccountMaster/GetAcMast?curyear=" + Setup('curyear') +
        "&shop=" + Firm("Shop")
        + "&Where=len(acno) >= 6");*/

    var _url = UT.APIURL! +
        "api/AccountMaster/GetAcMast?curyear=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&Where=len(acno) >= 6";
    print(_url);
    UT.mastData= await UT.apiDt(_url);
    //print("Mast data-->$data");
  }
  getItemList() async {

    var _url = UT.APIURL! +
        "api/ItemEnt9P/GetData?shop=${UT.shop_no}&Where=isdeleted<>'Y' order by item_code";
    UT.itemList = await UT.apiDt(_url);

  }

  goToPumpSalePage(){
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const PumpSalePage()));

  }
  goToCardSalePage(){
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const PetroOwnerCardSale()));

  }
  goToCreditSalePage() async {
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    var _url = UT.APIURL! +
        "api/AccountMaster/GetCust?Yr=" +
        UT.curyear! +
        "&Shop=" +
        UT.shop_no!+"&Cols=acno,name,pager";
    var data = await UT.apiDt(_url);
    UT.customerList=data;
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ShiftSaleCreditSale()));

  }
  goToReceiptPage() async {
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const ExpenseReceiptBankDeposit(title:"Receipt")));

  }
  goToBankDeposit() async {
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const ExpenseReceiptBankDeposit(title:"Deposit")));

  }
  goToProductSalePage(){
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const PetroOwnerProductSale()));

  }
  goToExpensePage() async {
    UT.m["slipNoOld"]=UT.m["slipNoOld"];
    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ExpenseReceiptBankDeposit(title:"Expense")));
  }

}

