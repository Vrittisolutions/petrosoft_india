import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/PetrosoftOperator/dsr_add_credit_sale.dart';
import 'package:petrosoft_india/PetrosoftOperator/operator_home_page.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class DsrProductSale extends StatefulWidget {
  const DsrProductSale({Key? key}) : super(key: key);

  @override
  _DsrProductSaleState createState() => _DsrProductSaleState();
}

class _DsrProductSaleState extends State<DsrProductSale> {
  TextEditingController closingQtyController	 =  TextEditingController();
  TextEditingController saleQtyController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  FocusNode saleFocusNode = FocusNode();
  FocusNode rateFocusNode = FocusNode();
  List productSaleData=[];
  List searchSaleData=[];
  dynamic api;
  List itemList=[];
  @override
  void initState() {
    super.initState();

    api= getData();

  }


  getData() async {
    await getItemList();
    var _url = UT.APIURL! +
        "api/PumpTrnE/GetPumpBD?cur_year=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&Where=srno=%27" + UT.m["dSrNo"] + "%27%20and%20pump_no=%27%27%20&Addrow=true";
    print(_url);
   var data = await UT.apiDt(_url);
    print("productSaleData-->$data");
    for(int i=0;i<data.length;i++){
      var itemName = UT.GetRow(itemList, 'item_code', data[i]['item_code'],'item_desc');
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
  getItemList() async {

    var _url = UT.APIURL! +
        "api/ItemEnt9P/GetData?shop=${UT.shop_no}&Where=isdeleted<>'Y' order by item_code";
    var data = await UT.apiDt(_url);
    print(_url);
    itemList=data;
    print(itemList);
    setState(() {

    });
    return itemList;
  }
  Future<bool?> _willPopCallback()async{
    UT.m['saledate']=UT.m['saledate'];
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return const PetroSoftOperatorHomePage();
    }));
    // return true if the route to be popped
  }
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorsForApp.app_theme_color,
      statusBarBrightness: Brightness.dark,
    ));

    return WillPopScope(
      onWillPop: ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.orange[150],
        appBar: AppBar(
            title:  Text('Product Sale' ,style: PetroSoftTextStyle.style17White,),titleSpacing: 0.0,
            leading: IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PetroSoftOperatorHomePage()));
              },
              icon: const Icon(Icons.arrow_back),
            ),backgroundColor: ColorsForApp.appThemeColor),
        body:   Padding(
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
                        decoration: const InputDecoration(
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
                              var itemName = UT.GetRow(itemList, 'item_code', searchSaleData[index]['item_code'],'item_desc');
                              if(searchSaleData[0]["pump_no"]=="") {
                                if (searchSaleData[index]["st_qty"] != 0.0 ||
                                    searchSaleData[index]["recd_qty"] != 0.0) {
                                  return InkWell(
                                    onTap: () {
                                      UT.m['selectedPumpIndex'] = index;
                                      closingQtyController = TextEditingController(text: searchSaleData[index]["end_qty"].toStringAsFixed(2));
                                      saleQtyController = TextEditingController(text: searchSaleData[index]["diff_qty"].toStringAsFixed(2));
                                      rateController = TextEditingController(text: searchSaleData[index]["rate"].toStringAsFixed(2));
                                      editDialog(context, setState);
                                    },
                                    child: Card(
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
                                                        style: PetroSoftTextStyle.style16AppColor
                                                    ),
                                                  ],
                                                ),
                                                Image.asset(PetroSoftAssetFiles.edit,height: 20,width: 20,)
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
                                            const SizedBox(height: 7,),
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
  editDialog(BuildContext context,StateSetter setState1){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context,setState1){
                return AlertDialog(
                  title: Text('Add Product Sale',style: StyleForApp.text_style_bold_14_owner_icon),
                  content: SizedBox(
                      height: MediaQuery.of(context).size.height*0.30,
                      child: SingleChildScrollView(
                        child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 45,
                                    width: 220,
                                    child: TextFormField(
                                      controller:closingQtyController ,
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      onFieldSubmitted: (value){
                                        FocusScope.of(context).requestFocus(saleFocusNode);
                                      },
                                      onChanged: (value){
                                        if(value.isNotEmpty){
                                          calClosingQty(setState1);

                                        }
                                      },
                                      decoration: InputDecoration(
                                        // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                          labelText: "Closing Qty", labelStyle: StyleForApp.text_style_normal_14_black
                                        //contentPadding: EdgeInsets.all(15.0),
                                      ),
                                    ),

                                  )
                                ],
                              ),
                              const SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 45,
                                    width: 220,
                                    child: TextFormField(
                                      focusNode: saleFocusNode,
                                      controller: saleQtyController,
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      onChanged: (value){
                                        if(value.isNotEmpty){
                                          calSaleQty(setState1);
                                        }
                                      },
                                      decoration: InputDecoration(
                                        // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                          labelText: "Sale Qty", labelStyle: StyleForApp.text_style_normal_14_black
                                        //contentPadding: EdgeInsets.all(15.0),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 45,
                                    width: 220,
                                    child: TextFormField(
                                      focusNode: rateFocusNode,
                                      controller: rateController,
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                          labelText: "Rate", labelStyle: StyleForApp.text_style_normal_14_black
                                        //contentPadding: EdgeInsets.all(15.0),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ]),
                      )
                  ),
                  actions: <Widget>[
                    ButtonBar(
                      buttonMinWidth: 100,
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: ColorsForApp.app_theme_color_light_owner_drawer,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            textStyle:StyleForApp.text_style_normal_14_owner,
                          ),
                          child: Text("Cancel",style: StyleForApp.text_style_bold_14_black),
                          onPressed: (){
                            closingQtyController.clear();
                            saleQtyController.clear();
                            rateController.clear();
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: ColorsForApp.app_theme_color_owner,
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              textStyle: StyleForApp.text_style_bold_14_white),
                          child: const Text("Save"),
                          onPressed: (){
                            DialogBuilder(context).showLoadingIndicator('');
                            saveData(context);
                          },
                        ),
                      ],
                    ),

                  ],
                );
              }
          );
        });
  }
  calClosingQty(StateSetter setState1){
    int tapIndex = int.parse(UT.m['selectedPumpIndex'].toString());

    productSaleData[tapIndex]["end_qty"] = UT.Flt(closingQtyController.text);

    var saleQty = UT.Flt(productSaleData[tapIndex]["st_qty"]) + UT.Flt(productSaleData[tapIndex]["recd_qty"]) - UT.Flt(productSaleData[tapIndex]["end_qty"]);
    //$('#diffqty' + sr).val(saleQty.toFixed(2));
    saleQtyController.text=saleQty.toStringAsFixed(2);
    productSaleData[tapIndex]["diff_qty"] = UT.Flt(saleQty);

    var amt = UT.Flt(productSaleData[tapIndex]["diff_qty"]) * UT.Flt(productSaleData[tapIndex]["rate"]);
    //$('#amt' + sr).text(amt.toFixed(2));
    productSaleData[tapIndex]["amount"] = UT.Flt(amt);
  }

  calSaleQty(StateSetter setState1){
    int tapIndex = int.parse(UT.m['selectedPumpIndex'].toString());

    productSaleData[tapIndex]["diff_qty"] = UT.Flt(saleQtyController.text);

    var clsqty = UT.Flt(productSaleData[tapIndex]["st_qty"]) + UT.Flt(productSaleData[tapIndex]["recd_qty"]) - UT.Flt(productSaleData[tapIndex]["diff_qty"]);
    closingQtyController.text=clsqty.toStringAsFixed(2);
    productSaleData[tapIndex]["end_qty"] = UT.Flt(clsqty);

    var amt = UT.Flt(productSaleData[tapIndex]["diff_qty"]) * UT.Flt(productSaleData[tapIndex]["rate"]);
    productSaleData[tapIndex]["amount"] = UT.Flt(amt);

  }


  saveData(ctx) async {
    int tapIndex = int.parse(UT.m['selectedPumpIndex'].toString());
    productSaleData[tapIndex]["rate"] = double.parse(rateController.text.toString());
    productSaleData[tapIndex]['amount'] = productSaleData[tapIndex]["diff_qty"]*productSaleData[tapIndex]["rate"];
    productSaleData[tapIndex]['pump_hold']=UT.ClientAcno;
    setState(() {});
    Navigator.pop(ctx);
    var data = [];
    data.add(productSaleData[tapIndex]);
    var _url = UT.APIURL! +
        "api/PostData/Post?tblname=pmbd" +
        UT.curyear! +
        UT.shop_no!;
    _url += "&Unique=SRNO,NO";
    var result = await UT.save2Db(_url, data);
    if(result=="ok"){
      closingQtyController.clear();
      saleQtyController.clear();
      rateController.clear();
      DialogBuilder(context).hideOpenDialog();
    }else{
      closingQtyController.clear();
      saleQtyController.clear();
      rateController.clear();
      DialogBuilder(context).hideOpenDialog();
    }

  }
}
class ProductModel {
  String? srno;
  String? no;
  String? date;
  String? shift;
  String? pumpNo;
  String? itemCode;
  dynamic? stMeter;
  dynamic? endMeter;
  dynamic? diffMeter;
  dynamic? retMeter;
  dynamic? stQty;
  dynamic? endQty;
  dynamic? retQty;
  dynamic? diffQty;
  dynamic? rate;
  double? trnRate;
  dynamic? amount;
  String? userid;
  String? edate;
  String? etime;
  dynamic? recdQty;
  String? billNo;
  String? pumpHold;
  String? petroItem;
  String? oilItem;
  dynamic? petroPer;
  dynamic? oilPer;
  dynamic? itmIgst;
  dynamic? itmCgst;
  dynamic? itmSgst;
  dynamic? itmgstrt;
  dynamic? transQty;
  String? pumpName;
  String? counter;
  dynamic? vouSale;
  String? lastchange;
  String? changedby;
  String? guid;
  String? isexport;
  String? creaonby;
  String? isdeleted;
  dynamic? crslQty;
  dynamic? crslRate;
  dynamic? crslAmt;

  ProductModel(
      {this.srno,
        this.no,
        this.date,
        this.shift,
        this.pumpNo,
        this.itemCode,
        this.stMeter,
        this.endMeter,
        this.diffMeter,
        this.retMeter,
        this.stQty,
        this.endQty,
        this.retQty,
        this.diffQty,
        this.rate,
        this.trnRate,
        this.amount,
        this.userid,
        this.edate,
        this.etime,
        this.recdQty,
        this.billNo,
        this.pumpHold,
        this.petroItem,
        this.oilItem,
        this.petroPer,
        this.oilPer,
        this.itmIgst,
        this.itmCgst,
        this.itmSgst,
        this.itmgstrt,
        this.transQty,
        this.pumpName,
        this.counter,
        this.vouSale,
        this.lastchange,
        this.changedby,
        this.guid,
        this.isexport,
        this.creaonby,
        this.isdeleted,
        this.crslQty,
        this.crslRate,
        this.crslAmt});

  ProductModel.fromJson(Map<String, dynamic> json) {
    srno = json['srno'];
    no = json['no'];
    date = json['date'];
    shift = json['shift'];
    pumpNo = json['pump_no'];
    itemCode = json['item_code'];
    stMeter = json['st_meter'];
    endMeter = json['end_meter'];
    diffMeter = json['diff_meter'];
    retMeter = json['ret_meter'];
    stQty = json['st_qty'];
    endQty = json['end_qty'];
    retQty = json['ret_qty'];
    diffQty = json['diff_qty'];
    rate = json['rate'];
    trnRate = json['trn_rate'];
    amount = json['amount'];
    userid = json['userid_'];
    edate = json['edate'];
    etime = json['etime'];
    recdQty = json['recd_qty'];
    billNo = json['bill_no'];
    pumpHold = json['pump_hold'];
    petroItem = json['petro_item'];
    oilItem = json['oil_item'];
    petroPer = json['petro_per'];
    oilPer = json['oil_per'];
    itmIgst = json['itm_igst'];
    itmCgst = json['itm_cgst'];
    itmSgst = json['itm_sgst'];
    itmgstrt = json['itmgstrt'];
    transQty = json['trans_qty'];
    pumpName = json['pump_name'];
    counter = json['counter'];
    vouSale = json['vou_sale'];
    lastchange = json['lastchange'];
    changedby = json['changedby'];
    guid = json['guid'];
    isexport = json['isexport'];
    creaonby = json['creaonby'];
    isdeleted = json['isdeleted'];
    crslQty = json['crsl_qty'];
    crslRate = json['crsl_rate'];
    crslAmt = json['crsl_amt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srno'] = this.srno;
    data['no'] = this.no;
    data['date'] = this.date;
    data['shift'] = this.shift;
    data['pump_no'] = this.pumpNo;
    data['item_code'] = this.itemCode;
    data['st_meter'] = this.stMeter;
    data['end_meter'] = this.endMeter;
    data['diff_meter'] = this.diffMeter;
    data['ret_meter'] = this.retMeter;
    data['st_qty'] = this.stQty;
    data['end_qty'] = this.endQty;
    data['ret_qty'] = this.retQty;
    data['diff_qty'] = this.diffQty;
    data['rate'] = this.rate;
    data['trn_rate'] = this.trnRate;
    data['amount'] = this.amount;
    data['userid_'] = this.userid;
    data['edate'] = this.edate;
    data['etime'] = this.etime;
    data['recd_qty'] = this.recdQty;
    data['bill_no'] = this.billNo;
    data['pump_hold'] = this.pumpHold;
    data['petro_item'] = this.petroItem;
    data['oil_item'] = this.oilItem;
    data['petro_per'] = this.petroPer;
    data['oil_per'] = this.oilPer;
    data['itm_igst'] = this.itmIgst;
    data['itm_cgst'] = this.itmCgst;
    data['itm_sgst'] = this.itmSgst;
    data['itmgstrt'] = this.itmgstrt;
    data['trans_qty'] = this.transQty;
    data['pump_name'] = this.pumpName;
    data['counter'] = this.counter;
    data['vou_sale'] = this.vouSale;
    data['lastchange'] = this.lastchange;
    data['changedby'] = this.changedby;
    data['guid'] = this.guid;
    data['isexport'] = this.isexport;
    data['creaonby'] = this.creaonby;
    data['isdeleted'] = this.isdeleted;
    data['crsl_qty'] = this.crslQty;
    data['crsl_rate'] = this.crslRate;
    data['crsl_amt'] = this.crslAmt;
    return data;
  }
}
