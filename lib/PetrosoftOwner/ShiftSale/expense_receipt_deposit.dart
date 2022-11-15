import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_rect_deposit_expense.dart';


class ExpenseReceiptBankDeposit extends StatefulWidget {
  final String title;
  const ExpenseReceiptBankDeposit({Key? key, required this.title}) : super(key: key);

  @override
  _ExpenseReceiptBankDepositeState createState() => _ExpenseReceiptBankDepositeState();
}

class _ExpenseReceiptBankDepositeState extends State<ExpenseReceiptBankDeposit> {
  dynamic apiResData;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    // OTRE = GetURLDt(APIURL + "/api/PumpTrnE/GetOthRect?shop=" + Firm("Shop") + "&_curyear=" + Setup('curyear') + "&Where=srno='" + srno + "' order by exp_srno&Addrow=true");
    var _url = UT.APIURL! +
        "api/PumpTrnE/GetOthRect?shop=" +
        UT.shop_no!+"&_curyear="+
        UT.curyear! +
        "&Where=srno%3D"+UT.m["slipNoOld"]+"%20and%20exp_rect=%27${widget.title}%27";
    apiResData = await UT.apiDt(_url);
   // print("apiResData-->$apiResData");
    return apiResData;
  }
  var colors1 = [
    Colors.indigo.shade400,
    Colors.indigo.shade500,
    Colors.indigo.shade600,
    Colors.indigo.shade700,
    Colors.indigo.shade800,
    Colors.indigo.shade900,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        backgroundColor: ColorsForApp.appThemeColor,
        titleSpacing: 0.0,
        leading: IconButton(
          highlightColor: Colors.white,
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ShiftSalePage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.title=="Receipt"?"Receipt":widget.title=="Expense"?"Expense":widget.title=="Deposit"?"Bank deposit":"",style: PetroSoftTextStyle.style17White),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future:  getData(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              if(apiResData.length!=0) {
              return ListView.builder(
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          height: 150.0,
                          margin: const EdgeInsets.only(left: 0.0),
                          child: Card(
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 8.0, bottom: 8.0),
                              child: Center(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5,),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                apiResData[index]['ac_name'].toString(),
                                                maxLines: 2,
                                                style: PetroSoftTextStyle.style16AppColor,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Text(
                                                UT.dateMonthYearFormat(apiResData[index]['exp_date']),
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  //fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ]),
                                      const SizedBox(height: 5,),
                                      const Divider(
                                        color: Colors.grey,
                                        thickness: 1.0,
                                      ),
                                      const SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                                apiResData[index]['narr'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              )),
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(
                                            top: 4, bottom: 4),
                                        child: Row(
                                          children: [
                                            Text(
                                              "\u{20B9}${apiResData[index]['exp_amt'].toStringAsFixed(2)}",
                                              // CreditSaleData[index]["veh_no"].toString(),
                                              style: PetroSoftTextStyle.style16AppColor,
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );

                   },
                  itemCount:apiResData.length );
            }else{
                return Center(
                    child:Text("No Data  found!!",style: UT.PetroOwnerNoDataStyle,));
              }
            }
            return Center(child: CommonWidget.circularIndicator());
          },
        )

      ),
      /*floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: const Icon(Icons.add),
        backgroundColor: ColorsForApp.appThemePetroOwner,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddRectExpDeposit(title: widget.title)));
        },
      ),*/
    );
  }
}
