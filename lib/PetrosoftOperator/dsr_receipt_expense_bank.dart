import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/PetrosoftOperator/operator_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dsr_add_receipt_and_cashdeposit.dart';

class DsrReceiptCashDeposit extends StatefulWidget {
 final String title;

  const DsrReceiptCashDeposit({Key? key, required this.title}) : super(key: key);

  @override
  _DsrReceiptCashDepositState createState() => _DsrReceiptCashDepositState();
}

class _DsrReceiptCashDepositState extends State<DsrReceiptCashDeposit> {
String? srNo;
dynamic receiptDepositList;
dynamic api;
  @override
  void initState() {
    super.initState();
    print(widget.title);
    api=getData();
  }

  getData() async {
    if(widget.title=="Receipt"){
      var _url = UT.APIURL! +
          "api/getPetroData/GetOTREData?firmno=" +
          UT.shop_no! +
          "&_curyear=" +
          UT.curyear!+
          "&dsrno=" + UT.m["dSrNo"].toString() + "&exp_rect=Receipt&cashCD="+UT.ClientAcno.toString();
      receiptDepositList = await UT.apiDt(_url);
      print("receiptList-->$_url");
      print("receiptList-->$receiptDepositList");
     return receiptDepositList;
    }else if(widget.title=="Deposit"){
      var _url = UT.APIURL! +
          "api/getPetroData/GetOTREData?firmno=" +
          UT.shop_no! +
          "&_curyear=" +
          UT.curyear!+
          "&dsrno=" + UT.m["dSrNo"].toString() + "&exp_rect=Deposit&cashCD="+UT.ClientAcno.toString();
      receiptDepositList = await UT.apiDt(_url);
      print("DepositList-->$receiptDepositList");
      return receiptDepositList;
    }else{
      var _url = UT.APIURL! +
          "api/getPetroData/GetOTREData?firmno=" +
          UT.shop_no! +
          "&_curyear=" +
          UT.curyear!+
          "&dsrno=" + UT.m["dSrNo"].toString() + "&exp_rect=Expense&cashCD="+UT.ClientAcno.toString();
      receiptDepositList = await UT.apiDt(_url);
      print("expense-->$receiptDepositList");
      return receiptDepositList;
    }
}
Future<bool?> _willPopCallback()async{
  UT.m['saledate']=UT.m['saledate'];
  return Navigator.of(context)
      .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
    return const PetroSoftOperatorHomePage();
  }));
  // return true if the route to be popped
}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
       // backgroundColor: Colors.blue[50],
        appBar: AppBar(title: Text(widget.title,style: PetroSoftTextStyle.style17White,),titleSpacing: 0.0, backgroundColor: ColorsForApp.appThemeColor,
          leading: IconButton(
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PetroSoftOperatorHomePage()));
            },
            icon: const Icon(Icons.arrow_back),
          ),),

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: FutureBuilder(
              future: api,
              builder: (context,snapshot){
                if(snapshot.hasData){
                  if(receiptDepositList[0]["srno"]!=""){
                    return ListView.builder(
                        itemBuilder: (context, index) {
                          srNo=receiptDepositList[index]["srno"].toString();
                          if (srNo=="") {
                            return  Center(child:Text("No data found!!",style: UT.PetroOperatorNoDataStyle,));
                          } else {
                            return InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddReceiptCashDeposite(title:widget.title,mode: "Edit",selectedRow: receiptDepositList[index],)));
                              },
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding:  EdgeInsets.all(10),
                                  child:
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                       Text('Amount', style: StyleForApp.text_style_normal_12_black,),
                                        const SizedBox(height: 5,),
                                        Text(
                                            "\u{20B9}${receiptDepositList[index]["exp_amt"].toStringAsFixed(2 )}" ,
                                            // CreditSaleData[index]["veh_no"].toString(),
                                            style: StyleForApp.text_style_bold_16_operator_dark
                                        ),
                                        Divider(color: ColorsForApp.light_gray_color,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                                children: [
                                                  Column
                                                    (
                                                    mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('From', style: StyleForApp.text_style_normal_12_black,),
                                                      const  SizedBox(height: 5,),
                                                      Text(
                                                          receiptDepositList[index]["name"],
                                                          maxLines: 2,
                                                          style: StyleForApp.text_style_bold_14_black
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    receiptDepositList[index]["narr"],
                                                    style: StyleForApp.text_style_normal_14_black
                                                ),

                                              ],
                                            )
                                          ],
                                        ),


                                      ]
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        itemCount: receiptDepositList.length);
                  }else{
                    return Center(
                        child:Text("No data found!!",style: UT.PetroOwnerNoDataStyle,));

                  }
                }
                return Center(child: CommonWidget.circularIndicator());
              },
            ),
          )
        ),
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: const Icon(Icons.add),
          backgroundColor: ColorsForApp.icon_operator,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddReceiptCashDeposite(title:widget.title,mode: "Add",selectedRow: {},)));
          },
        ),
      ),
    );
  }
}
