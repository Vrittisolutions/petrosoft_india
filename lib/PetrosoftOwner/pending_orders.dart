import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/common_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Classes/styleforapp.dart';
class PendingOrdersPage extends StatefulWidget {
  const PendingOrdersPage({Key? key}) : super(key: key);
  @override
  _PendingOrdersPageState createState() => _PendingOrdersPageState();
}

class _PendingOrdersPageState extends State<PendingOrdersPage> {
  dynamic pendingOrderData;
  @override
  void initState() {
    super.initState();

  }
  getData() async {
   // /api/getPetroCustData/getCRSLList?year4crsllist=" + Setup("curyear") + "&shop4crsllist=" + Firm("Shop") + "&isapproved=N");
    var _url = UT.APIURL! +
        "api/getPetroCustData/getCRSLList?year4crsllist=" +
        UT.curyear! +
        "&shop4crsllist=" +
        UT.shop_no! +
    "&isapproved=N";
    pendingOrderData = await UT.apiDt(_url);
    print("PendingOrderData-->$pendingOrderData");
   return pendingOrderData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.indigo.shade100,
      /*appBar: AppBar(
        backgroundColor: UT.ownerAppColor,
        titleSpacing: 0.0,
        leading: IconButton(
          highlightColor: Colors.white,
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PetroOwnerHomePage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Pending Orders"),
      ),*/
      appBar: AppBar(title:  Text('Pending Orders',style: PetroSoftTextStyle.style17White),titleSpacing: 0.0, backgroundColor: ColorsForApp.appThemeColor),
      body: Center(
        child: FutureBuilder(
          future: getData(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      if(pendingOrderData.length==1&&pendingOrderData[0]["cust_code"]==""){
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 300,),
                              Center(
                                  child:Text("No pending orders found!!",style: UT.PetroOwnerNoDataStyle,))
                            ],
                          ),
                        );
                      }else{
                        return Stack(
                          children: [
                            Container(
                              height: 170.0,
                              margin:  EdgeInsets.only(left: 0.0,top: 5.0),
                              child: Container(
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
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0,top: 8.0,bottom: 8.0),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 5,),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  UT.dateMonthYearFormat(pendingOrderData[index]["date"]),
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    //color: UT.ownerAppColor,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  pendingOrderData[index]["name"],
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                    //  color: UT.ownerAppColor,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ]),
                                        SizedBox(height: 5,),
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1.0,
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                                  pendingOrderData[index]["coupon_no"].toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                )),
                                            Expanded(
                                                child: Text(
                                                  pendingOrderData[index]["veh_no"],
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                )),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 4, bottom: 4),
                                          child: Row(
                                            children: [
                                              Text(
                                               pendingOrderData[index]["item_desc"],
                                                // CreditSaleData[index]["veh_no"].toString(),
                                                style: const TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  // color: UT.ownerAppColor
                                                ),
                                              ),
                                              Text(
                                                " "+  pendingOrderData[index]["qty_sold"].toString()+"X",
                                                // CreditSaleData[index]["veh_no"].toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  // color: UT.ownerAppColor
                                                ),
                                              ),
                                              Text(
                                                pendingOrderData[index]["rate"].toString(),
                                                // CreditSaleData[index]["veh_no"].toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.orangeAccent
                                                ),
                                              ),
                                              Text(
                                                " "+pendingOrderData[index]["amount"].toString(),
                                                // CreditSaleData[index]["veh_no"].toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: UT.ownerAppColor
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(

                                                  height: 40,
                                                  width: 100,
                                                  child:CommonButtonForAllApp(
                                                    onPressed: (){
                                                      approveConfirmationDialog(pendingOrderData[index]["cred_vou"]);
                                                    },
                                                    title: 'Approve',backgroundColor: ColorsForApp.app_theme_color_owner
                                                  )
                                              )
                                            ]
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      },
                    itemCount: pendingOrderData.length)

            );
          }
          return Center(child: CommonWidget.circularIndicator());
        },
        ),
      ),

    );
  }
  Future<bool?> approveConfirmationDialog(String credVou) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(titleTextStyle: TextStyle(fontWeight:FontWeight.bold,fontSize:17,color: UT.ownerAppColor),
        title: const Text("Alert"),
        content: const Text("Do you want to approve request?"),
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
                child: const Text("No"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: UT.ownerAppColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    textStyle: const TextStyle(
                        color:Colors.white ,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                child: const Text("YES"),
                onPressed: (){
                   DialogBuilder(context).showLoadingIndicator('');
                  saveData(credVou);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  saveData(String credVou) async {
    var crhdData=  Map();
    crhdData["cred_vou"]="$credVou";
    crhdData["isapproved"]="K";
    List crhdDataList=[];
    crhdDataList.add(crhdData);
    print(crhdDataList);
    var _url = UT.APIURL! +
        "api/PostData/Post?tblname=mob_crhd" +
        UT.curyear! +
        UT.shop_no!;
    _url += "&Unique=cred_vou";
    var Result = await UT.save2Db(_url,crhdDataList);
    print(Result);
    var _url1 = UT.APIURL! +
        "api/PostData/Post?tblname=mob_crsl" +
        UT.curyear! +
        UT.shop_no!;
    _url1 += "&Unique=cred_vou";
    var Result1 = await UT.save2Db(_url1,crhdDataList);
    if(Result1=="ok"){
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: 'approve successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PendingOrdersPage()));
    }
  }
}
