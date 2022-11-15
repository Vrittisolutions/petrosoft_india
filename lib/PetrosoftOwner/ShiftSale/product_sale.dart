import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class PetroOwnerProductSale extends StatefulWidget {
  const PetroOwnerProductSale({Key? key}) : super(key: key);

  @override
  _PetroOwnerProductSaleState createState() => _PetroOwnerProductSaleState();
}

class _PetroOwnerProductSaleState extends State<PetroOwnerProductSale> {
  TextEditingController searchController = TextEditingController();
  FocusNode saleFocusNode = FocusNode();
  FocusNode rateFocusNode = FocusNode();
  List productSaleData=[];
  List searchSaleData=[];
  dynamic api;
  getData() async {
    // PumpHd = GetURLDt(APIURL + "/api/PumpTrnE/GetPumpHD?year=" + Setup('curyear') + "&shop=" + Firm("Shop") + "&Where=isdeleted <>'Y' and srno='" + srno + "'&Addrow=true");
    // PumpBd = GetURLDt(APIURL + "/api/PumpTrnE/GetPumpBD?cur_year=" + Setup('curyear') + "&shop=" + Firm("Shop") + "&Where=isdeleted <>'Y' and srno='" + srno + "'&Addrow=true");
    //PumpBd = GetURLDt(APIURL + "/api/PumpTrnE/GetPumpBD?cur_year=" + Setup('curyear') + "&shop=" + Firm("Shop") + "&Where=isdeleted <>'Y' and srno='" + srno + "'&Addrow=true");
    var _url = UT.APIURL! +
        "api/PumpTrnE/GetPumpBD?cur_year=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&Where=srno=%27" + UT.m["slipNoOld"] + "%27%20and%20pump_no=%27%27%20&Addrow=true";
    print("Product sale _url--->$_url");
    var data = await UT.apiDt(_url);

    for(int i=0;i<data.length;i++){
      var itemName = UT.GetRow(UT.itemList, 'item_code', data[i]['item_code'],'item_desc');
      var map={
        "srno":data[i]['srno'],
        "no":data[i]['no'],
        "date":data[i]['date'],
        "shift":data[i]['shift'],
        "pump_no":data[i]['pump_no'],
        "item_code":data[i]['item_code'],
        "item_desc":itemName,
        "st_meter":data[i]['st_meter'],
        "end_meter":data[i]['end_meter'],
        "diff_meter":data[i]['diff_meter'],
        "ret_meter":data[i]['ret_meter'],
        "st_qty":data[i]['st_qty'],
        "end_qty":data[i]['end_qty'],
        "ret_qty":data[i]['ret_qty'],
        "diff_qty":data[i]['diff_qty'],
        "rate":data[i]['rate'],
        "trn_rate":data[i]['trn_rate'],
        "amount":data[i]['amount'],
        "userid_":data[i]['userid_'],
        "edate":data[i]['edate'],
        "recd_qty":data[i]['recd_qty'],
        "bill_no":data[i]['bill_no'],
        "pump_hold":data[i]['pump_hold'],
        "petro_item":data[i]['petro_item'],
        "oil_item":data[i]['oil_item'],
        "petro_per":data[i]['petro_per'],
        "oil_per":data[i]['oil_per'],
        "itm_igst":data[i]['itm_igst'],
        "itm_cgst":data[i]['itm_cgst'],
        "itm_sgst":data[i]['itm_sgst'],
        "itmgstrt":data[i]['itmgstrt'],
        "trans_qty":data[i]['trans_qty'],
        "pump_name":data[i]['pump_name'],
        "counter":data[i]['counter'],
        "vou_sale":data[i]['vou_sale'],
        "lastchange":data[i]['lastchange'],
        "changedby":data[i]['changedby'],
        "guid":data[i]['guid'],
        "isexport":data[i]['isexport'],
        "creaonby":data[i]['creaonby'],
        "isdeleted":data[i]['isdeleted'],
        "crsl_qty":data[i]['crsl_qty'],
        "crsl_rate":data[i]['crsl_rate'],
        "crsl_amt":data[i]['crsl_amt']
      };
      if (data[i]["st_qty"] != 0.0 || data[i]["recd_qty"] != 0.0){
        productSaleData.add(map);
        searchSaleData.add(map);
      }

    }
    print("product sale data-->$searchSaleData");
    return searchSaleData;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api=getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Product Sale',),
            titleSpacing: 0.0,
            backgroundColor: ColorsForApp.appThemeColor),
        body: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        onChanged: (value) {
                          search(value);
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: "Search",
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                      ),
                    ),
                  ),
                  Center(
                    child: FutureBuilder(
                      future: api,
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          // if(searchSaleData[0]["pump_no"]==""){
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: ScrollController(),
                            itemCount: searchSaleData.length,
                            itemBuilder: (BuildContext context, int index) {
                              var itemName = UT.GetRow(UT.itemList, 'item_code', searchSaleData[index]['item_code'],'item_desc');
                              if(searchSaleData[0]["pump_no"]=="") {
                                if (searchSaleData[index]["st_qty"] != 0.0 ||
                                    searchSaleData[index]["recd_qty"] != 0.0) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Column(children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                      "Amount : \u{20B9}${searchSaleData[index]["amount"]
                                                          .toStringAsFixed(2)}",
                                                      style: PetroSoftTextStyle
                                                          .style16AppColor
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                          const SizedBox(height: 7,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(itemName, style: StyleForApp
                                                  .text_style_bold_13_black,)
                                            ],),
                                          const SizedBox(height: 7,),
                                          /*   Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 100,
                                                        child: Text(
                                                            itemName,maxLines: 2,
                                                            style: StyleForApp.text_style_normal_13_black
                                                        ),
                                                      ),
                                                      Text(
                                                          "Sale Qty \n"+"\u{20B9}${productSaleData[index]["diff_qty"].toStringAsFixed(2)}",
                                                          style: StyleForApp.text_style_normal_13_black
                                                      ),
                                                      Text(
                                                          "Amount\n\u{20B9}${productSaleData[index]["amount"].toStringAsFixed(2)}",
                                                          style: StyleForApp.text_style_bold_14_owner_dark,textAlign: TextAlign.end
                                                      ),

                                                    ],
                                                  ),*/
                                          Divider(color: ColorsForApp.light_gray_color,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                      "Opening Qty : \n" +
                                                          searchSaleData[index]["st_qty"]
                                                              .toStringAsFixed(2),
                                                      style: StyleForApp
                                                          .text_style_bold_14_black
                                                  ),

                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      "Tran. Qty	 : \n" +
                                                          searchSaleData[index]["recd_qty"]
                                                              .toStringAsFixed(2),

                                                      style: StyleForApp
                                                          .text_style_bold_14_black
                                                  ),

                                                ],
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 7,),
                                          /*     Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    "Testing : " +
                                                        searchSaleData[index]["ret_meter"]
                                                            .toStringAsFixed(2)
                                                            .toString(),
                                                    style: StyleForApp
                                                        .text_style_normal_14_black
                                                ),

                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "Sale Ltr : " +
                                                        searchSaleData[index]["diff_meter"]
                                                            .toStringAsFixed(2)
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.red.shade600,
                                                        fontSize: 14)
                                                ),
                                              ],
                                            )
                                          ],
                                        ),*/
                                          SizedBox(height: 7,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                      "Closing Qty : " +
                                                          searchSaleData[index]["end_qty"]
                                                              .toStringAsFixed(2),
                                                      style: StyleForApp
                                                          .text_style_normal_14_black
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      "Sale Qty : \u{20B9}${searchSaleData[index]["diff_qty"]
                                                          .toStringAsFixed(2)}",
                                                      style: StyleForApp
                                                          .text_style_normal_14_black
                                                  ),

                                                ],
                                              )
                                            ],
                                          )
                                        ]
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }else{
                                return Center(
                                    child:Text("No product sale data found!!",style: UT.PetroOwnerNoDataStyle,));
                              }
                            },
                          );
                          // }else{


                          //}
                        }
                        return Center(child: CommonWidget.circularIndicator());
                      },
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );

  }

  void search(String query) {
    if (query.isEmpty) {
      searchSaleData=productSaleData;
      setState(() {});
      return;
    }

    query = query.toLowerCase();
    print(query);
    List result = [];
    searchSaleData.forEach((p) {
      var name = p["item_desc"].toString().toLowerCase();
      if (name.contains(query)) {
        result.add(p);
      }
    });

    searchSaleData = result;
    setState(() {});
  }


  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return const ShiftSalePage();
    }));
    // return true if the route to be popped
  }

}
