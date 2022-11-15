import 'dart:convert';
import 'package:petrosoft_india/AdatsoftOwner/AppTheame/asset_files.dart';
import 'package:petrosoft_india/AdatsoftOwner/AppTheame/textFileds.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'Model/customer_model.dart';

class SaleBillEntry extends StatefulWidget {
  const SaleBillEntry({Key? key}) : super(key: key);

  @override
  State<SaleBillEntry> createState() => _SaleBillEntryState();
}
var oldent = false;
var Cust;
var bill_no;
var oldbill_no;
var maxno;
var slhd;
var slbd;
var inwd = [];
var prodct;
var oldqty;
var Supp;
var custAcno = '';
var item;
var bsec;
var oldbsec;
var selectedAcno;
var custvalid=true;


class _SaleBillEntryState extends State<SaleBillEntry> with TickerProviderStateMixin {

  String ?formatDate;
  TextEditingController txtControllerBillNo =  TextEditingController();
  TextEditingController txtControllerCustomer =  TextEditingController();
  TextEditingController txtControllerDelivery =  TextEditingController();
  TextEditingController txtControllerBrand =  TextEditingController();
  TextEditingController txtControllerLotNo =  TextEditingController();
  TextEditingController txtControllerCommodity =  TextEditingController();
  TextEditingController txtControllerBags =  TextEditingController();
  TextEditingController txtControllerAvgWT =  TextEditingController(text: "0.00");
  TextEditingController txtControllerWeight =  TextEditingController(text: "0.00");
  TextEditingController txtControllerRate =  TextEditingController(text: "0.00");
  TextEditingController txtControllerDiff =  TextEditingController(text: "0.00");
  TextEditingController txtControllerAmount =  TextEditingController(text: "0.00");
  TextEditingController txtControllerRemark =  TextEditingController();
  TextEditingController txtBalanceAmt =  TextEditingController();
  TextEditingController hamali =  TextEditingController(text: '0.00');
  TextEditingController tot_exp=TextEditingController(text: "0.00");
  String selectedCustomer='';
  final List<AddItem> _entriesList=[];
  List<CustomerModel> customerList=[];


  var itemCode;

  TextEditingController tot_amt=TextEditingController(text: "0.00");

  TextEditingController sale_amt=TextEditingController(text: "0.00");

  var market_fee;

  var maint_fee;

  var packing;

  var bill_trans;

  TextEditingController comm=TextEditingController(text: "0.00");
  TextEditingController commisson=TextEditingController(text: "0.00");

  var diff_amt;

  var bl_qty;

  var bl_wt;

  var bl_comrate;

  var recd_amt;

  var bankname;

  var cashrecd;
  double charge=0.00;
  dynamic api;

  var tcs_amt;
  bool showLoader=false;
  var disc_amt;
  @override
  void initState() {
    super.initState();
    DateTime currentDate = DateTime.now();
    formatDate = DateFormat("dd-MM-yyyy").format(currentDate);
    api=getData();

  }

 getData() async {
  await getMaxBillNo();
  await  getCustomerList();
  await  getItemList();
  return true;
 }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title:  const Text('Sale Bill Entry',
          style: TextStyle(fontSize: 15,color: Colors.black),),
        actions: [
          Center(child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(formatDate.toString(),
              style: StyleForApp.text_style_normal_14_black,
            ),
          )),
          IconButton(
            icon: Icon(Icons.check_circle,color: ColorsForApp.appThemeColorAdatOwner,),
            onPressed: (){
              DialogBuilder(context).showLoadingIndicator('');
              print("On save-->$slhd");
              SaveBill();

            },
          )

        ],
      ),
      body: FutureBuilder(
        future: api,
        builder:(context,snapshot){
          if(snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // AdatTextField.textFieldWithBorder(null, "Bill No.", txtControllerBillNo,TextInputType.number,false,100),
                      Focus(
                        onFocusChange: (hasFocus){
                          print('2:  $hasFocus');
                          if(hasFocus==false){
                            if(txtControllerBillNo.text.isNotEmpty) {
                              showLoader=true;
                              DialogBuilder(context).showLoadingIndicator('');
                              BillNo(txtControllerBillNo.text);


                            }
                          }
                        },
                        child: Container(
                          height: 40, width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            //color: Colors.grey.shade100,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: TextFormField(
                            controller: txtControllerBillNo,
                            textInputAction: TextInputAction.done,
                            autofocus: false,
                            // maxLength: 10,
                            keyboardType: TextInputType.number,
                            validator: (input) {
                              if (input == " " || input!.isEmpty) {
                                return "Field  is required";
                              }
                              return null;
                            },
                            onFieldSubmitted: (term) {
                              if(term.isNotEmpty){
                                showLoader=true;
                                DialogBuilder(context).showLoadingIndicator('');
                                BillNo(txtControllerBillNo.text);
                              }

                            },
                            decoration: InputDecoration(
                              // prefixIcon: Icon(icon, color: ColorsForApp.light_gray_color,),
                                counterText: "",
                                iconColor: ColorsForApp.light_gray_color,
                                isDense: true,
                                contentPadding: EdgeInsets.all(8),

                                //fillColor:Colors.grey.shade300,
                                //border: OutlineInputBorder(),
                                labelText: "Bill No",
                                labelStyle: TextStyle(fontSize: 13.0,
                                    color: ColorConverter.hexToColor("#838383")),
                                border: InputBorder.none
                            ),
                            minLines: 1,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      customerSelection(),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  deliveryAndBalance(),
                  const SizedBox(height: 10,),
                  slbdListView(),
                  const SizedBox(height: 10,),

                ],
              ),
            ),
          );
        }else{
          return Center(
            child: SizedBox(
              height: size.height * 0.3,
              width: size.width,
              child: Center(child: Image.asset(AssetFiles.loading))
            ),
          );
        }
  }
      ),

      bottomNavigationBar: bottomUI(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, //specify the location of the FAB
      floatingActionButton: FloatingActionButton(
        mini: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))
        ),
        backgroundColor: Colors.indigo,
        onPressed: () {
          txtControllerBrand.clear();
          txtControllerLotNo.clear();
          txtControllerCommodity.clear();
          txtControllerBags.clear();
          txtControllerAvgWT.clear();
          txtControllerWeight.clear();
          txtControllerRate.clear();
          txtControllerDiff.clear();
          txtControllerAmount.clear();
          txtControllerRemark.clear();
          AddLot(context);
        },
        tooltip: "Centre FAB",
        child: const Center(child:  Icon(Icons.add)),
        elevation: 4.0,
      ),
     // bottomNavigationBar: bottomUI(),
    );
  }
  Widget deliveryAndBalance(){
    return Row(
      children: [
        AdatTextField.textFieldWithBorder(null, "Delivery", txtControllerDelivery,TextInputType.number,true,200),
        const SizedBox(width: 5,),
        Expanded(child:  AdatTextField.textFieldWithBorder(null, "Balance", txtBalanceAmt,TextInputType.number,true,100),)

      ],
    );
  }

  Widget customerSelection(){

    return  Expanded(
     child:  Container(
       height: 40,
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(10.0),
         // color: Colors.grey.shade100,
         border: Border.all(color: Colors.grey.shade400),
       ),
       child:Autocomplete<CustomerModel>(
          initialValue:TextEditingValue(text: selectedCustomer) ,
         optionsBuilder: (TextEditingValue value) {

           // When the field is empty
           if (value.text.isEmpty) {
             return [];
           }

           // The logic to find out which ones should appear
           return customerList
               .where((customer) => customer.name!.toLowerCase()
               .startsWith(value.text.toLowerCase())
           )
               .toList();
         },
         fieldViewBuilder: (
             BuildContext context,
             TextEditingController controller,
             FocusNode fieldFocusNode,
             VoidCallback onFieldSubmitted
             ) {
           return TextField(
             controller: controller,
             focusNode: fieldFocusNode,
             decoration: InputDecoration(
               // prefixIcon: Icon(icon, color: ColorsForApp.light_gray_color,),
                 counterText: "",
                 iconColor: ColorsForApp.light_gray_color,
                 isDense: true,
                 contentPadding: EdgeInsets.all(8),

                 fillColor:Colors.grey.shade300,
                 //border: OutlineInputBorder(),
                 labelText: selectedCustomer!=''?selectedCustomer:"Select Customer",
                 labelStyle: TextStyle(fontSize: 13.0, color: ColorConverter.hexToColor("#838383")),
                 border: InputBorder.none
             ),
             style: const TextStyle(fontWeight: FontWeight.bold),
           );
         },
         displayStringForOption: (CustomerModel option) => option.name!,
         onSelected: (value) {
           setState(() {
             selectedCustomer = value.name!;
             txtControllerCustomer.text=value.name!;
             custAcno=value.acno!;
             balance();
           });
         },
       ),

     ),
    );
  }

  Widget slbdListView() {
    if (slbd != null) {
      return ListView.builder(
          itemCount: slbd.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {


            if (slbd != null && slbd[index]['bill_no']!="") {
              double avgwt = 0;
              if(double.parse(slbd[index]['bill_qty'].toString())!=0){
                avgwt = UT.Flt(slbd[index]['bill_gr']) / UT.Flt(slbd[index]['bill_qty']);
              }
              var itemName = UT.GetRow(item, "item_code", slbd[0]['item_code'].trim(),'item_desc');
              return InkWell(
                onTap: (){
                  editEntryDialog(context,slbd[index],index);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 0.0, right: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          shape: BoxShape.rectangle,
                          borderRadius: new BorderRadius.circular(10.0),

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                   // color: Colors.red,
                                      width: 60,
                                      child: Text(slbd[index]['brand'], maxLines: 2,textAlign: TextAlign.left,
                                          style: StyleForApp.text_style_normal_12_black)
                                  ),

                                  Container(
                                     // color: Colors.yellow,
                                      width: 60,
                                      child: Text(slbd[index]['pcsperbox'], maxLines: 2,textAlign: TextAlign.left,
                                        style: StyleForApp.text_style_normal_12_black,)
                                  ),
                                  Container(
                                      width: 110,
                                     // color: Colors.blue,
                                      child: Text(itemName, maxLines: 2,textAlign: TextAlign.left,
                                        style: StyleForApp.text_style_normal_12_black,)
                                  ),
                                  Expanded(
                                      //width: 30,
                                    //  color: Colors.orange,
                                      child: Text(double.parse(slbd[index]['bill_qty'].toString()).round().toString(),
                                        maxLines: 2,
                                        textAlign: TextAlign.right,
                                        style: StyleForApp.text_style_normal_12_black,)
                                  ),

                                ],
                              ),
                              const SizedBox(height: 5,),
                              Row(
                              //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                     // color: Colors.purple,
                                      width: 60,
                                      child: Text(
                                        avgwt.toStringAsFixed(2), maxLines: 2,textAlign: TextAlign.left,
                                        style: StyleForApp.text_style_normal_12_black,)
                                  ),
                                  Container(
                                     // color: Colors.pink,
                                      width: 60,
                                      child: Text(
                                        UT.convertIntoDouble(slbd[index]['bill_gr'].toString()).toString(), maxLines: 2,
                                        textAlign: TextAlign.left,   style: StyleForApp.text_style_normal_12_black,)
                                  ),
                                  Container(
                                      width: 80,
                                    //  color: Colors.grey,
                                      child: Text(slbd[index]['bill_rate'].toString(), maxLines: 2,
                                          textAlign: TextAlign.left, style: StyleForApp.text_style_normal_12_black)
                                  ),
                                  Container(
                                      width: 30,
                                     // color: Colors.lightGreen,
                                      child: Text(UT.convertIntoDouble(slbd[index]['ptrt_diff'])
                                          .toString(), maxLines: 2,textAlign: TextAlign.left,
                                          style: StyleForApp.text_style_normal_12_black)
                                  ),
                                  Container(
                                     width: 80,
                                     // color: Colors.indigo,
                                      child: Text("\u{20B9} "+UT.convertIntoDouble(slbd[index]['line_amt'])
                                          .toString(), maxLines: 2,textAlign: TextAlign.right,
                                          style: TextStyle(color: Colors.indigo,fontSize: 12,fontWeight: FontWeight.w600))
                                  ),

                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 30, width: 25,  alignment: Alignment.center,
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                _deleteDialog(context,slbd[index]['bill_srno'],index);
                              },
                              icon: const Icon(
                                Icons.delete, color: Colors.red,size: 19,),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Row(
                  children: <Widget>[
                    Expanded(
                        child: Divider()
                    ),

                    Text("Add New Entry",style: StyleForApp.text_style_bold_13_blue,),

                    Expanded(
                        child: Divider()
                    ),
                  ]
              );
            }
          });
    }else {
      return Row(
          children: <Widget>[
            Expanded(
                child: Divider()
            ),

            Text("OR"),

            Expanded(
                child: Divider()
            ),
          ]
      );
    }
  }

  addEntryDialog(BuildContext context,String newBillNo){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text('Enter Details', style: StyleForApp.text_style_bold_14_black,),
                 IconButton(onPressed: (){
                   Navigator.pop(context);
                 }, icon: Icon(Icons.clear))
               ],
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      onTap: () async {
                      var selectedBrandData=  await brandSelectionDialog(context);
                      print("selectedBrandData-->$selectedBrandData");
                      if(selectedBrandData!=""||selectedBrandData!=null){
                        txtControllerCommodity.text = UT.GetRow(item, "item_code", selectedBrandData['item_code'].trim(),'item_desc');
                        txtControllerBrand.text=selectedBrandData['brand'];
                        txtControllerLotNo.text=selectedBrandData['pcsperbox'];
                        txtControllerBags.text=(UT.Flt(selectedBrandData['recd_pack'] - selectedBrandData['sold_qty']).abs().round()).toString();
                        Valid_Brand(newBillNo,txtControllerBrand.text);
                        Valid_pcsperbox(newBillNo,txtControllerLotNo.text);
                        Valid_bill_qty(newBillNo,txtControllerBags.text);
                        txtControllerDiff.text="0.00";
                       /* txtControllerDiff.text="0.00";
                        txtControllerAvgWT.text="0.00";
                        txtControllerRate.text="0.00";
                        txtControllerAmount.text="0.00";*/
                        itemCode=selectedBrandData['item_code'];
                      }

                      },
                      controller: txtControllerBrand,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Brand",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerLotNo,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Lot No.",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerCommodity,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      enabled: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Commodity",
                          labelStyle: StyleForApp.text_style_normal_14_black,
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerBags,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Bags",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                      onChanged: (value){
                        if(value.isNotEmpty){
                          double bags=double.parse(txtControllerBags.text);
                          double enterdValue=double.parse(value);
                          if(enterdValue>bags){
                           Fluttertoast.showToast(msg: "Bags not allow grater that balance Qty");
                          }else{
                            double bags=double.parse(value);
                            if(bags!=0){
                              // $('#avg' + sr).val((Flt(slbd[i]["bill_gr"]) / Flt(slbd[i]["bill_qty"])).toFixed(2));
                              double avgWt=UT.Flt(txtControllerWeight.text)/bags;
                              txtControllerAvgWT.text=avgWt.toStringAsFixed(2);
                            }
                          }

                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerAvgWT,
                      textInputAction: TextInputAction.next,
                      readOnly: true,
                      enabled: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Avg Wt",
                          labelStyle: StyleForApp.text_style_normal_14_black,
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerWeight,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Weight",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                      onChanged: (value){
                        if(value.isNotEmpty){
                          Valid_bill_gr(newBillNo, value);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerRate,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Rate",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                      onChanged: (value){
                        if(value.isNotEmpty){
                          Valid_bill_rate(newBillNo, value);
                        }
                        },
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerDiff,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Diff",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                      onChanged: (value){
                        if(value.isNotEmpty){
                          Valid_diff(newBillNo,value);
                        }
                        },
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerAmount,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      enabled: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Amount",
                          labelStyle: StyleForApp.text_style_normal_14_black,
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerRemark,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Remark",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: ColorsForApp.app_theme_color_light_drawer,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            textStyle: StyleForApp.text_style_normal_14_black),
                        child: const Text('Cancel',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        onPressed: () {

                          txtControllerBrand.clear();
                          txtControllerLotNo.clear();
                          txtControllerCommodity.clear();
                          txtControllerBags.clear();
                          txtControllerAvgWT.clear();
                          txtControllerWeight.clear();
                          txtControllerRate.clear();
                          txtControllerDiff.clear();
                          txtControllerAmount.clear();
                          txtControllerRemark.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 5,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary:ColorsForApp.appThemeColorPetroCustomer,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            textStyle: const TextStyle(
                                color:Colors.white ,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        child: Text('Add',
                            style: StyleForApp.text_style_normal_14_white),
                        onPressed: () {

                          if(txtControllerBrand.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter brand ");
                          }else if(txtControllerLotNo.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter lot ");
                          }else if(txtControllerCommodity.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter commodity ");
                          }else if(txtControllerBags.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter bags ");
                          }else if(txtControllerWeight.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter weight ");
                          }else if(txtControllerRate.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter rate ");
                          }else{
                          //  editDeta();
                            UpdateLot(newBillNo);

                          }
                          },
                      ),
                    ],
                  ),
                )
              ]
          );
        });
  }
  editEntryDialog(BuildContext context,var editRow,int index){
    var newBillNo=editRow['bill_srno'];
    txtControllerBrand.text=editRow['brand'];
    txtControllerLotNo.text=editRow['pcsperbox'];
    txtControllerBags.text=editRow['bill_qty'];
    txtControllerWeight.text=editRow['bill_gr'];
    txtControllerRate.text=editRow['bill_rate'].toString();
    txtControllerDiff.text=editRow['ptrt_diff'].toString();
    txtControllerAmount.text=editRow['line_amt'].toString();
    itemCode=editRow['item_code'];

    txtControllerCommodity.text = UT.GetRow(item, "item_code", editRow['item_code'].trim(),'item_desc');
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Update Details', style: StyleForApp.text_style_bold_14_black,),
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.clear))
                ],
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      onTap: () async {
                        var selectedBrandData=  await brandSelectionDialog(context);
                        print("selectedBrandData-->$selectedBrandData");
                        if(selectedBrandData!=""||selectedBrandData!=null){
                          txtControllerCommodity.text = UT.GetRow(item, "item_code", selectedBrandData['item_code'].trim(),'item_desc');
                          txtControllerBrand.text=selectedBrandData['brand'];
                          txtControllerLotNo.text=selectedBrandData['pcsperbox'];
                          txtControllerBags.text=(UT.Flt(selectedBrandData['recd_pack'] - selectedBrandData['sold_qty']).abs().round()).toString();
                          Valid_Brand(newBillNo,txtControllerBrand.text);
                          Valid_pcsperbox(newBillNo,txtControllerLotNo.text);
                          Valid_bill_qty(newBillNo,txtControllerBags.text);

                          /* txtControllerDiff.text="0.00";
                        txtControllerAvgWT.text="0.00";
                        txtControllerRate.text="0.00";
                        txtControllerAmount.text="0.00";*/
                          itemCode=selectedBrandData['item_code'];
                        }

                      },
                      controller: txtControllerBrand,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      readOnly: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Brand",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerLotNo,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Lot No.",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerCommodity,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        labelText: "Commodity",
                        labelStyle: StyleForApp.text_style_normal_14_black,
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerBags,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Bags",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                      onChanged: (value){
                        if(value.isNotEmpty){
                          double bags=double.parse(txtControllerBags.text);
                          double enterdValue=double.parse(value);
                          if(enterdValue>bags){
                            Fluttertoast.showToast(msg: "Bags not allow grater that balance Qty");
                          }else{
                            double bags=double.parse(value);
                            if(bags!=0){
                              // $('#avg' + sr).val((Flt(slbd[i]["bill_gr"]) / Flt(slbd[i]["bill_qty"])).toFixed(2));
                              double avgWt=UT.Flt(txtControllerWeight.text)/bags;
                              txtControllerAvgWT.text=avgWt.toStringAsFixed(2);
                            }
                          }

                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerAvgWT,
                      textInputAction: TextInputAction.next,
                      readOnly: true,
                      enabled: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        labelText: "Avg Wt",
                        labelStyle: StyleForApp.text_style_normal_14_black,
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerWeight,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Weight",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                      onChanged: (value){
                        if(value.isNotEmpty){
                          Valid_bill_gr(newBillNo, value);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerRate,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Rate",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                      onChanged: (value){
                        if(value.isNotEmpty){
                          Valid_bill_rate(newBillNo, value);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerDiff,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Diff",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                      onChanged: (value){
                        if(value.isNotEmpty){
                          Valid_diff(newBillNo,value);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerAmount,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      readOnly: true,
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        labelText: "Amount",
                        labelStyle: StyleForApp.text_style_normal_14_black,
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerRemark,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Remark",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: ColorsForApp.app_theme_color_light_drawer,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            textStyle: StyleForApp.text_style_normal_14_black),
                        child: const Text('Cancel',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        onPressed: () {

                          txtControllerBrand.clear();
                          txtControllerLotNo.clear();
                          txtControllerCommodity.clear();
                          txtControllerBags.clear();
                          txtControllerAvgWT.clear();
                          txtControllerWeight.clear();
                          txtControllerRate.clear();
                          txtControllerDiff.clear();
                          txtControllerAmount.clear();
                          txtControllerRemark.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 5,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary:ColorsForApp.appThemeColorPetroCustomer,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            textStyle: const TextStyle(
                                color:Colors.white ,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        child: Text('Update',
                            style: StyleForApp.text_style_normal_14_white),
                        onPressed: () {

                          if(txtControllerBrand.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter brand ");
                          }else if(txtControllerLotNo.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter lot ");
                          }else if(txtControllerCommodity.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter commodity ");
                          }else if(txtControllerBags.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter bags ");
                          }else if(txtControllerWeight.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter weight ");
                          }else if(txtControllerRate.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter rate ");
                          }else{
                            //  editDeta();
                            setState(() {
                              slbd[index]["bill_no"] = txtControllerBillNo.text;
                              slbd[index]["bsection"] = slhd[0]['bsection'];
                              slbd[index]["cust_code"] = slhd[0]['cust_code'];
                              slbd[index]["bill_date"] = UT.dateConverter(DateTime.now());
                              slbd[index]["item_code"] = itemCode;
                              slbd[index]["pcsperbox"] = txtControllerLotNo.text;
                              slbd[index]["brand"] = txtControllerBrand.text;
                              slbd[index]["bill_qty"] = txtControllerBags.text;
                              slbd[index]["bill_gr"] = txtControllerWeight.text;
                              slbd[index]["bill_wt"] = 0;
                              slbd[index]["bill_avg"] = 0;
                              slbd[index]["bill_loose"] = 0;
                              slbd[index]["bill_pack"] = 0;
                              slbd[index]["pack_rate"] = 0;
                              slbd[index]["bill_rate"] = txtControllerRate.text;
                              slbd[index]["line_amt"] = txtControllerAmount.text;
                              slbd[index]["ptrt_diff"] = txtControllerDiff.text;
                              slbd[index]["inw_no"] = '';
                              slbd[index]["inw_srno"] = '';
                              slbd[index]["inw_item"] = '';
                              slbd[index]["isdeleted"] = 'N';
                              slbd[index]["isRowAdded"] = true;
                              Navigator.pop(context);
                            });

                          }
                        },
                      ),
                    ],
                  ),
                )
              ]
          );
        });
  }

  Future _deleteDialog(context,String srNo, int index) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context)
        {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              insetPadding: const EdgeInsets.all(8),
              elevation: 10,
              titlePadding: const EdgeInsets.all(0.0),
              title: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                      child: GestureDetector(
                        onTap: () {
                        Navigator.pop(context);
                        },
                        child: Container(
                          alignment: FractionalOffset.topRight,
                          child: const Icon(Icons.clear, color: Colors.red,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        children: const [
                          Icon(Icons.error_outline, color:Colors.red,size: 48,),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Are you sure you want to delete?",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          /*   Text(
                        "Your Subscription Plan Expiered",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.center,
                      ),*/
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              contentPadding: EdgeInsets.all(8),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary:ColorsForApp.light_gray_color,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        textStyle: const TextStyle(
                            color:Colors.white ,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    child:   Text('No',
                        style: StyleForApp.text_style_normal_14_white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary:ColorsForApp.appThemeColorPetroCustomer,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        textStyle: const TextStyle(
                            color:Colors.white ,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    child:   Text('Yes',
                        style: StyleForApp.text_style_normal_14_white),
                    onPressed: () {

                      setState(() {
                        DeleteSLBDrow(context,srNo,index);
                      });
                    },
                  ),

                ],
              )

          );
        });
  }
  Widget bottomUI(){
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
      child: SizedBox(
        height: 100,
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 35,
                    width: 110,
                    child: TextField(
                        controller: hamali,
                    readOnly: true,
                        style:const TextStyle(fontSize: 13) ,
                    decoration: InputDecoration(
                      labelText: "Hamali",
                      labelStyle: TextStyle(fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    )
                    ),
                  ),
                  SizedBox(
                    height: 35,width: 110,
                    child: TextField(
                        controller: comm,
                        readOnly: true,
                        style:const TextStyle(fontSize: 13) ,
                        decoration: InputDecoration(
                          labelText: "Comm.%",
                          labelStyle: TextStyle(fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 35,width: 110,
                    child: TextField(
                        controller: commisson,
                        readOnly: true,
                        style:const TextStyle(fontSize: 13) ,
                        decoration: InputDecoration(
                          labelText: "Commission",
                          labelStyle: const TextStyle(fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 35,width: 110,
                    child: TextField(
                        controller: sale_amt,
                        readOnly: true,
                        enabled: false,
                        style:const TextStyle(fontSize: 13) ,
                        decoration: InputDecoration(
                          labelText: "Sale Amt",
                          labelStyle: TextStyle(fontSize:15,color: Colors.blue.shade800,fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                        )
                    ),
                  ),
                  SizedBox(
                    height: 35,width: 110,
                    child: TextField(
                        controller: tot_exp,
                        readOnly: true,
                        enabled: false,
                        style:TextStyle(fontSize: 13) ,
                        decoration: InputDecoration(
                          labelText: "Charges",
                          labelStyle: TextStyle(color: Colors.purple,fontWeight: FontWeight.w600),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 35,width: 110,
                    child: TextField(
                        controller: tot_amt,
                        readOnly: true,
                        enabled: false,
                        style:TextStyle(fontSize: 13) ,
                        decoration: InputDecoration(
                          labelText: "Total Amt",
                          labelStyle: TextStyle(color: Colors.indigo,fontWeight: FontWeight.w600),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        )),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  brandSelectionDialog(BuildContext context){
   return showGeneralDialog(
     context: context,
     barrierDismissible: false,
     barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
     transitionDuration: Duration(milliseconds:800),
     transitionBuilder: (context, animation, secondaryAnimation, child) {
       return FadeTransition(
         opacity: animation,
         child: ScaleTransition(
           scale: animation,
           child: child,
         ),
       );
     },
     pageBuilder: (context, animation, secondaryAnimation) {
       return Scaffold(
         appBar: PreferredSize(
             preferredSize: Size.fromHeight(40.0),
             child: AppBar(
               backgroundColor: Theme.of(context).primaryColor,
               titleSpacing: 0.0,
               elevation: 0,
               actions: [
                 IconButton(onPressed: (){}, icon: Icon(Icons.clear))
               ],
               title: Text("Brand selection",style: StyleForApp.text_style_bold_14_white),)),
         body: SafeArea(
           child: Container(
             width: MediaQuery.of(context).size.width,
             height: MediaQuery.of(context).size.height,
             padding: const EdgeInsets.all(8),
             color: Colors.white,
             child: SingleChildScrollView(
               child: Column(
                 mainAxisSize: MainAxisSize.max,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children:<Widget> [
                   ListView.builder(
                     physics: ScrollPhysics(),
                     itemCount: inwd.length,
                       shrinkWrap: true,
                       itemBuilder: (context,index){
                         var itemName = UT.GetRow(item, "item_code", inwd[0]['item_code'].trim(),'item_desc');
                     return InkWell(
                       onTap: (){
                         var selectedData=inwd[index];
                         Navigator.pop(context,selectedData);
                       },
                       highlightColor: Colors.blue.withOpacity(0.4),
                       splashColor: Colors.green.withOpacity(0.5),
                       child: Container(
                       //  height: 80,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           color: Colors.white
                         ),
                         child: Padding(
                           padding: const EdgeInsets.all(5.0),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Expanded(
                                      // width: 70,
                                       child: Text(UT.dateMonthYearFormat(inwd[index]['inw_date']),
                                           textAlign:TextAlign.left,style: StyleForApp.text_style_bold_13_light_gray)),
                                 // SizedBox(width: 5,),
                                   Expanded(
                                     child: Text(inwd[index]['name'].toString().toLowerCase(),maxLines: 2,
                                         textAlign:TextAlign.left,style: StyleForApp.text_style_normal_13_light_gray),
                                   ),
                                  // SizedBox(width: 5,),
                                   Expanded(
                                     //  width: 70,

                                        child: Text(itemName,textAlign:TextAlign.center,style: StyleForApp.text_style_normal_13_light_gray)),

                                   Expanded(
                                      // width: 30,
                                        child: Container(
                                            child: Text(inwd[index]['inw_qty'].round().toString(),textAlign:TextAlign.right,style: StyleForApp.text_style_normal_13_light_gray),
                                          //color: Colors.indigo,
                                        )
                                   ),
                                  // SizedBox(width: 5,),


                                 ],
                               ),
                               SizedBox(height: 10,),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Expanded(
                                    // width: 70,
                                       child: Text(inwd[index]['brand'],textAlign:TextAlign.left,style: StyleForApp.text_style_normal_13_light_gray)),
                                   Expanded(
                                   //width: 60 ,
                                       child: Text(inwd[index]['pcsperbox'].toString(),textAlign:TextAlign.right,style: StyleForApp.text_style_normal_13_light_gray)),
                                   Expanded(
                                     //  width: 100,
                                       child: Text("\u{20B9}"+(UT.Flt(inwd[index]['recd_pack'] - inwd[index]['sold_qty']).abs().round()).toString(),
                                           textAlign:TextAlign.center,style: TextStyle(fontSize: 13,color: Colors.indigo,fontWeight: FontWeight.w600))),
                                   Expanded(
                                     //  width: 70,
                                       child: Text(inwd[index]['inw_no'],textAlign:TextAlign.right,style: StyleForApp.text_style_normal_13_light_gray)),
                                 ],
                               ),
                               SizedBox(height: 10,),
                               Row(
                                 children: [
                                   Expanded(
                                     // width: 70,
                                       child: Text(inwd[index]['veh_no'],textAlign:TextAlign.left,style: StyleForApp.text_style_normal_13_light_gray)),
                                 ],
                               ),
                               SizedBox(height: 10,),
                               Divider(height: 1,thickness: 1,color: Colors.grey.shade300,)
                             ],
                           ),
                         ),
                       ),
                     );

                   }),

                 ],
               ),
             ),
           ),
         ),
         bottomNavigationBar: Container(
           height: 50,
           child:  Padding(
             padding: const EdgeInsets.all(10.0),
             child: ElevatedButton(
               onPressed: () {
                 Navigator.of(context).pop();
               },
               child: Text("Cancel",
                 style: TextStyle(color: Colors.white),
               ),
             ),
           ),
         ),
       );
     },
   );
  }

  //TODO :method for get Max bill no
  getMaxBillNo()async{
    var _url = UT.APIURL! +
        "api/BillEnt01/GetMaxSrno?curyear=" +
        UT.curyear! +
        "&shop="+UT.shop_no.toString();
    var data = await UT.apiStr(_url);
    slhd=json.decode(data);
    txtControllerBillNo.text=slhd[0]["bill_no"].toString().padLeft(5,'0');
    bsec = slhd[0]["bsection"].toString();
    oldbill_no = txtControllerBillNo.text;
    oldbsec = bsec;
    BillNo(txtControllerBillNo.text);

  }
  getItemList()async{
    var _url = UT.APIURL! +
        "api/ItemMaster?shop=" +
        UT.shop_no.toString() +
        "&Addrow=true";
    var data = await UT.apiStr(_url);
   // print('itemList-->$data');
    item =json.decode(data);
  }
   BillNo(billNo) async {
    billNo = billNo.padLeft(5, "0");

     var slhdUrl = UT.APIURL! +
         "api/BillEnt01/GetSaleHD?year=" +
         UT.curyear! +
         "&shop="+UT.shop_no.toString()+"&Where=isdeleted <>'Y' and bill_no='" + billNo + "' and bsection='" + bsec + "'";

     var data = await UT.apiStr(slhdUrl);
     slhd=json.decode(data);
   //  print("slhd-->$slhd");

     var slbdUrl = UT.APIURL! +
         "api/BillEnt01/GetSaleBD?_year=" +
         UT.curyear! +
         "&shop="+UT.shop_no.toString()+"&Where=isdeleted%20%3C%3E%27Y%27%20and%20bill_no=%27" + billNo + "%27%20and%20bsection=%27" + bsec + "%27";
     var data1 = await UT.apiStr(slbdUrl);
     slbd=json.decode(data1);

     var inwdUrl = UT.APIURL! +
        "api/BillEnt01/GetInwLot?cur_year=" +
        UT.curyear! +
        "&shopno="+UT.shop_no.toString();

    var data2 = await UT.apiStr(inwdUrl);
    inwd=json.decode(data2);
  //  slhd = slhd[0];
    if (slhd[0]['bill_no'].trim() == "") {
      oldent = false;
      slhd[0]['bill_no'] = billNo;
      slhd[0]['bsection'] = bsec;
    }
    else {
      oldent = true;
      UT.ChkDtLoc(slhd[0]['bill_date']).then((value) {
        billNo = oldbill_no;
        bsec = oldbsec;
        return false;
      });

     // UpdtINWD();
    }
    //InwArray = [];
    //AddInwNo2Arr();
    refresh();
   // $("#bankname").val(slhd.bank_acno).trigger('chosen:updated');
  //  return true;
  }
   refresh() async {
    txtControllerBillNo.text=slhd[0]['bill_no'];
    txtControllerDelivery.text=slhd[0]['remark'];
    double totExp= UT.Flt(slhd[0]['tot_amt'] )- UT.Flt(slhd[0]['sale_amt']);
    tot_exp.text=totExp.toStringAsFixed(2);


    custAcno = slhd[0]['cust_code'].trim();
    var custUrl = UT.APIURL! +
        "api/AccountMaster/GetCust?Yr=" +
        UT.curyear! +
        "&Shop="+UT.shop_no.toString()+"&Where=acno='" + custAcno + "'&Addrow=true&Cols=name,acno,city,pager,cat,nocomm,comm_rate,commonbag,ac_type,istcs,tcs_from";
    var res = await UT.apiStr(custUrl);
   // print("Cust-->$res");
    Cust=json.decode(res);
    selectedCustomer = Cust[0]['name'];

    if (Cust[0]['name'] != '') {
      selectedCustomer = Cust[0]['name'];
    }
    else {
      selectedCustomer='';
    }
    refreshExp();

  }
   balance() async {

     var Url = UT.APIURL! +
         "api/AccountMaster/GetAcBal?curyear=" +
         UT.curyear! +
         "&shop="+UT.shop_no.toString()+"&acno="+custAcno;
     var res = await UT.apiStr(Url);
     var bal =json.decode(res);
     var amt=UT.Flt(bal[0]["balance"]);
     txtBalanceAmt.text=amt.toStringAsFixed(2);
    /* if(showLoader==true){
       DialogBuilder(context).hideOpenDialog();
     }*/
  }

   refreshExp() {
     balance();
    hamali.text=slhd[0]['hamali'].toStringAsFixed(2);
    tot_amt.text=slhd[0]['tot_amt'].toStringAsFixed(2);
    sale_amt.text=slhd[0]['sale_amt'].toStringAsFixed(2);
    comm.text=slhd[0]['bl_comrate'].toStringAsFixed(2);
    commisson.text=slhd[0]['comm'].toStringAsFixed(2);
    maint_fee=slhd[0]['maint_fee'].toStringAsFixed(2);
    market_fee=slhd[0]['market_fee'].toStringAsFixed(2);
    packing=slhd[0]['packing'].toStringAsFixed(2);
    bill_trans=slhd[0]['bill_trans'].toStringAsFixed(2);
    diff_amt=slhd[0]['diff_amt'].toStringAsFixed(2);
    bl_qty=slhd[0]['bl_qty'].toStringAsFixed(2);
    bl_wt=slhd[0]['bl_wt'].toStringAsFixed(2);
    bl_comrate=slhd[0]['bl_comrate'].toStringAsFixed(2);
    tcs_amt=slhd[0]['tcs_amt'].toStringAsFixed(2);
    disc_amt=slhd[0]['disc_amt'].toStringAsFixed(2);
    recd_amt=slhd[0]['recd_amt'].toStringAsFixed(2);
    bankname=slhd[0]['bankname'];
    cashrecd=slhd[0]['cashrecd'].toStringAsFixed(2);
    double totExp= UT.Flt(slhd[0]['tot_amt'] )- UT.Flt(slhd[0]['sale_amt']);
    tot_exp.text=totExp.toStringAsFixed(2);
    if(showLoader==true){
      DialogBuilder(context).hideOpenDialog();
    }
     setState(() {

     });
    return true;

  }
   getCustomerList()async{
    // var urlstr = APIURL + "/api/AccountMaster/GetSuppByName?syear=" + Setup('curyear') + "&shop=" + Firm("Shop") + "&like=" + request.term + "&addrow=false&cols=name%2B' '%2Bcity as name ,acno,city";

    var _url = UT.APIURL! +
        "api/AccountMaster/GetCustByName?cYr=" +
        UT.curyear! +
        "&Shop="+UT.shop_no.toString()+
        "&like=" + txtControllerCustomer.text +
        "&Addrow=false&Cols=name,acno,city,pager,cat,nocomm,comm_rate,commonbag,ac_type,istcs,tcs_from";
    var data = await UT.apiStr(_url);
    List  decode=json.decode(data);
    customerList = decode.map((val) =>  CustomerModel.fromJson(val)).toList();

  }


   Valid_diff(String SrNo,String value) {
   // var sr = this.id.substr(4, 5);
    var i = UT.getrowindex(slbd, "bill_srno", SrNo);
    slbd[i]["ptrt_diff"] = UT.Flt(value);
    calcLineAmt(i);
    showamt();
  }

   Valid_bill_rate(String sr,String value) {
    print("bill_srno-->$sr");
    var i = UT.getrowindex(slbd, "bill_srno", sr);
    slbd[i]["bill_rate"] = UT.Flt(value);
    calcLineAmt(i);
  }

   calcLineAmt(i) async {
    // var itmi = getrowindxItm(yymmdd($("#bill_date").val()), slbd[i]["item_code"]);

    var itmi = UT.getrowindxItm(DateTime.now(), itemCode,item);
     var lineamt = UT.Flt(slbd[i]["bill_gr"]) * UT.Flt(slbd[i]["bill_rate"]) / UT.Flt(item[itmi]["ratefactor"]);
   // var lineamt = UT.Flt(txtControllerWeight.text)* UT.Flt(txtControllerRate.text) / UT.Flt(item[itmi]["ratefactor"]);
    txtControllerAmount.text=lineamt.toStringAsFixed(2);
    slbd[i]["line_amt"] = lineamt;
     editDeta();

  }

   Valid_bill_gr(String sr,String value) {
   // var sr = this.id.substr(2, 5);
    var i = UT.getrowindex(slbd, "bill_srno", sr);
    slbd[i]["bill_gr"] = UT.Flt(value);
    slbd[i]["bill_wt"] = UT.Flt(value);

    if (UT.Flt(slbd[i]["bill_qty"]) != 0) {
      var avg=(UT.Flt(slbd[i]["bill_gr"]) / UT.Flt(slbd[i]["bill_qty"])).toStringAsFixed(2);
      txtControllerAvgWT.text=avg;
    }
    calcLineAmt(i);
  }

   Valid_bill_qty(String sr,String value) {

   // var sr = this.id.substr(3, 5);
    var i = UT.getrowindex(slbd, "bill_srno", sr);
    var oldQty = slbd[i]["bill_qty"];
    slbd[i]["bill_qty"] = UT.Flt(value);

    if (UT.Flt(slbd[i]["bill_qty"]) != 0) {
      var avg=(UT.Flt(slbd[i]["bill_gr"]) / UT.Flt(slbd[i]["bill_qty"])).toStringAsFixed(2);
      txtControllerAvgWT.text=avg;
    }

   /* if (UT.Setup("inwmemo") == "Yes") {
      var ii = UT.getrowindex(inwd, "inw_no,inw_srno,inw_item", slbd[i]["inw_no"] + ',' + slbd[i]["inw_srno"] + ',' + slbd[i]["inw_item"]);
      inwd[ii]["sold_qty"] = UT.Flt(inwd[ii]["sold_qty"]) - UT.Flt(oldQty);
      inwd[ii]["cur_pack"] = UT.Flt(inwd[ii]["recd_pack"]) - UT.Flt(inwd[ii]["sold_qty"]);

      if ((UT.Flt(inwd[ii]["recd_pack"]) - UT.Flt(inwd[ii]["sold_qty"])) < UT.Flt(value)) {
        //alert('Qty more than balance ' + (Flt(inwd[ii]["recd_pack"]) - Flt(inwd[ii]["sold_qty"])) + ' bags.');
        //$('#qty' + sr).val(Flt(inwd[ii]["recd_pack"]) - Flt(inwd[ii]["sold_qty"]));
        slbd[i]["bill_qty"] = UT.Flt(UT.Flt(inwd[ii]["recd_pack"]) - UT.Flt(inwd[ii]["sold_qty"]));


      }
      else {
       // $('#brand' + sr).prop('disabled', true);
        //$('#pcsper' + sr).prop('disabled', true);
        //$('#qty' + sr).prop('disabled', true);
      }
      inwd[ii]["sold_qty"] = UT.Flt(inwd[ii]["sold_qty"]) + UT.Flt(slbd[i]["bill_qty"]);
      inwd[ii]["cur_pack"] = UT.Flt(inwd[ii]["recd_pack"]) - UT.Flt(inwd[ii]["sold_qty"]);
    }*/
  }

   Valid_pcsperbox(String sr,String value) {
    //var sr = this.id.substr(6, 5);
    var i = UT.getrowindex(slbd, "bill_srno", sr);
    slbd[i]["pcsperbox"] = value;
  }

   Valid_Brand(String sr,String value) {
    if (UT.Setup('inwmemo') == 'Yes') {
    //  $('#inwlot').show();
      //var sr = this.id.substr(5, 5);
       print("bill_srno-->$sr");
      var i = UT.getrowindex(slbd, "bill_srno", sr);
       print("bill_srno-->$i");
      if (slbd[i]["inw_no"] != '' && slbd[i]["inw_srno"] != '' && slbd[i]["inw_item"] != '') {
        var oldQty = slbd[i]["bill_qty"];
        var ii = UT.getrowindex(inwd, "inw_no,inw_srno,inw_item", slbd[i]["inw_no"] + ',' + slbd[i]["inw_srno"] + ',' + slbd[i]["inw_item"]);
        if (ii >= 0) {
          inwd[ii]["sold_qty"] = UT.Flt(inwd[ii]["sold_qty"]) - UT.Flt(oldQty);
          inwd[ii]["cur_pack"] = UT.Flt(inwd[ii]["recd_pack"]) - UT.Flt(inwd[ii]["sold_qty"]);

          slbd[i]["bill_qty"] = 0;
          slbd[i]["brand"] = '';
          slbd[i]["pcsperbox"] = '';
          slbd[i]["item_code"] = '0';
          slbd[i]["inw_no"] = '';
          slbd[i]["inw_srno"] = '';
          slbd[i]["inw_item"] = '';
          txtControllerBrand.clear();
          txtControllerLotNo.clear();
          txtControllerBags.clear();
        }
      }
     // UpdtInwLotTbl(sr);
    }
    else {

      var i = UT.getrowindex(slbd, "bill_srno", sr);
      slbd[i]["brand"] = value;
    }
  }

   ValidItemDesc(String sr,String value) {
  //  var sr = this.id.substr(4, 5);
    var i = UT.getrowindex(slbd, "bill_srno", sr);
    slbd[i]["item_code"] = itemCode;
  }


   Amt() async {

    if (UT.Flt(slhd[0]['bl_comrate'] ) != 0) {
      slhd[0]['comm'] = UT.Flt(slhd[0]['sale_amt']) / 100 * UT.Flt(slhd[0]['bl_comrate']);
    }

    var custi = UT.getrowindex(Cust, "acno", custAcno);
    var acType = '';
    var istcs = '';
    var tcsfrom = '';
    if (custi >= 0) {
      acType = Cust[custi]['ac_type'];
      istcs = Cust[custi]['istcs'];
      tcsfrom = Cust[custi]['tcs_from'];
    }
    if (tcsfrom != '' ) {
      var prdexpmst ;
      //prdexpmst = GetDt('PrdExpMast', "isdeleted<>'Y' and '" + yymmdd($("#bill_date").val()) + "'>= from_dt and '" + yymmdd($("#bill_date").val()) + "'<= to_date", false, '', 'tcs_rate');
     // prdexpmst = GetURLDt(APIURL + "api/TDS_TCSEnt/Get?where=isdeleted<>'Y' and '" + yymmdd($("#bill_date").val()) + "'>= from_dt and '" + yymmdd($("#bill_date").val()) + "'<= to_date&addrow=false");

      var Url = UT.APIURL! +
          "api/TDS_TCSEnt/Get?where=isdeleted%3C%3E%27Y%27%20and%20" +UT.yearMonthDateFormat(slhd[0]['bill_date'])+"%3E=from_dt%20and%20"+UT.yearMonthDateFormat(slhd[0]['bill_date'])+"%3C=%20to_date&addrow=false";
          UT.curyear! +
          "&shop="+UT.shop_no.toString()+"&acno="+custAcno;
      print("$Url");
     var res = await UT.apiStr(Url);
      prdexpmst=json.decode(res);
      print("prdexpmst-->$prdexpmst");

      if (prdexpmst.length!=0) {
        var tcsrate = UT.Flt(prdexpmst[0]['tcs_rate']);
        if (istcs == 'Yes') {
          slhd[0]['tcs_amt'] = UT.Flt(slhd[0]['sale_amt']) / 100 * tcsrate;
        }
        else {
          slhd[0]['tcs_amt'] = 0;
        }
      }
    }
    else {
      slhd[0]['tcs_amt'] = 0;
    }
   print("bill comm-->${slhd[0]['bill_Comm']}");
    if(slhd[0]['bill_Comm']==null){
      slhd[0]['bill_Comm']=0;
    }
    slhd[0]['tot_amt'] = UT.Flt(slhd[0]['sale_amt']) + UT.Flt(slhd[0]['market_fee']) + UT.Flt(slhd[0]['maint_fee']) + UT.Flt(slhd[0]['packing'])
        + UT.Flt(slhd[0]['advance']) + UT.Flt(slhd[0]['hamali']) + UT.Flt(slhd[0]['bill_trans']) + UT.Flt(slhd[0]['leivy']) +
        UT.Flt(slhd[0]['tolai']) + UT.Flt(slhd[0]['bharai']) + UT.Flt(slhd[0]['mapai']) + UT.Flt(slhd[0]['oth_exp']) + UT.Flt(slhd[0]['comm']) +
        UT.Flt(slhd[0]['bill_phone']) + slhd[0]['bill_Comm'] + UT.Flt(slhd[0]['cvat_amt']) + UT.Flt(slhd[0]['p_adv']) +
        UT.Flt(slhd[0]['sutali']) + UT.Flt(slhd[0]['bill_hamal']) + UT.Flt(slhd[0]['tcs_amt']) - UT.Flt(slhd[0]['disc_amt']) ;
    if (UT.Setup("amtround") == "Yes") {
      var tot1 = UT.Flt(slhd[0]['tot_amt']).round();
      slhd[0]['round_off'] = tot1 - UT.Flt(slhd[0]['tot_amt']);
      slhd[0]['tot_amt'] = UT.Flt(slhd[0]['sale_amt']) + UT.Flt(slhd[0]['market_fee']) + UT.Flt(slhd[0]['maint_fee']) + UT.Flt(slhd[0]['packing']) +
          UT.Flt(slhd[0]['advance']) + UT.Flt(slhd[0]['hamali']) + UT.Flt(slhd[0]['bill_trans']) + UT.Flt(slhd[0]['leivy']) +
          UT.Flt(slhd[0]['tolai']) + UT.Flt(slhd[0]['bharai']) + UT.Flt(slhd[0]['mapai']) + UT.Flt(slhd[0]['oth_exp']) + UT.Flt(slhd[0]['comm']) +
          UT.Flt(slhd[0]['bill_phone']) + UT.Flt(slhd[0]['bill_Comm']) + UT.Flt(slhd[0]['cvat_amt']) + UT.Flt(slhd[0]['p_adv']) +
          UT.Flt(slhd[0]['sutali']) + UT.Flt(slhd[0]['bill_hamal']) + UT.Flt(slhd[0]['round_off']) + UT.Flt(slhd[0]['tcs_amt']) -
          UT.Flt(slhd[0]['disc_amt']) ;
    }


    if (acType == 'Cash' && slhd.chlnlock != 'Yes') {
      slhd[0]['recd_amt'] = slhd[0]['tot_amt'];
    }

    refreshExp();
  }

   editDeta() {

    if (slhd[0]['chlnlock'] == "Yes") {
      Amt();
      return true;
    }

    var mCat;
    var custi = UT.getrowindex(Cust, "acno", custAcno);

    switch (slhd[0]['bl_type']) {
      case "F_bl":
        mCat = Cust[custi]["cat"].trim();
        break;

      case "F_bl":
        mCat = "A";
        break;

      default:
        mCat = Cust[custi]["cat"].trim();
        break;
    }
    var mNocomm = Cust[custi]["nocomm"];
    var mCOMMRATE = Cust[custi]["comm_rate"];
    var mCommOnBag = Cust[custi]["commonbag"];

    if (mCOMMRATE == 'undefined') {
      mCOMMRATE = 0;
    }
    if (mCommOnBag == 'undefined' || mCommOnBag == '') {
      mCommOnBag = "No";
    }

    num mSaleAmt = 0.0;
    var mMarketFee = 0.0;
    var mMaintFee = 0.0;
    var mHamali = 0.0;
    var mTolai = 0.0;
    var mBharai = 0.0;
    var mMapai = 0.0;

    var mBillTrans = 0.0;
    var mPackCalcSt = true ;
    var mBLQty = 0.0;
    var mBLWt = 0.0;
    var mLEIVY = 0.0;
    var mAgntAmt = 0.0;
    var mCvatAmt = 0.0;
    var mXvatonamt = 0.0;
    var mComm = 0.0;
    var MDIFFAMT = 0;
    var mPacking = 0.0;

    for (var i = 0; i < slbd.length; i++)
    {
      if (slbd[i]["isdeleted"] == 'Y') {
        continue;
      }
     // var itmi = UT.getrowindxItm(slbd[i]["bill_date"],slbd[i]["item_code"].trim(),item);

      var itmi = UT.getrowindxItm(DateTime.now(),itemCode.trim(),item);
      print("itmi-->$itmi");
      var mItemCode = slbd[i]["item_code"].trim();
      var mQty = UT.Flt(slbd[i]["bill_qty"]);
      if (UT.Flt(slbd[i]["bill_loose"]) > 0) {
        mQty = mQty + 1;
      }

      var mWeight2 = UT.Flt(slbd[i]["bill_gr"]);
      var mBillTrans = slbd[i]["bill_trans"];
      if (mWeight2 == 0 || item[itmi]["loos_sale"].trim() == "Yes") {
        mWeight2 = UT.Flt(slbd[i]["bill_wt"]);
      }
      var mRate = slbd[i]["bill_rate"];
      var mWeight = mWeight2;

      mSaleAmt = mSaleAmt + UT.Flt(slbd[i]["line_amt"]);
      var xlineAmt = 0.0;
      if (UT.Setup("AutoComRt") == 'No') {
       xlineAmt = UT.Flt(slbd[i]["line_amt"]);
      // print('doubleAmt-->$doubleAmt');
     //  xline_Amt=int.parse(slbd[i]["line_amt"].toString());

      }
      else {
        xlineAmt = UT.Flt(slbd[i]["line_amt"]) + UT.Flt(slbd[i]["line_amt"]) * UT.Flt(item[itmi]["custcommpe"]) / 100;
        //xline_Amt=int.parse(doubleAmt.toString());
      }

      if (mCOMMRATE != 0) {
        if (mCommOnBag.trim() == "Yes") {
          mComm = UT.Flt(mComm) + UT.Flt(mQty) * UT.Flt(mCOMMRATE);
        }
        else {
          mComm = UT.Flt(mComm) + (UT.Flt(slbd[i]["line_amt"]) * UT.Flt(mCOMMRATE) / 100);
        }
      }
      else {
        mComm = UT.Flt(mComm) + (UT.Flt(slbd[i]["line_amt"]) * UT.Flt(item[itmi]["custcommpe"]) / 100);
      }
      mMarketFee = UT.Flt(mMarketFee) + xlineAmt * UT.Flt(item[itmi]["sesrate"]) / 100;
      mMaintFee = UT.Flt(mMaintFee) + xlineAmt * UT.Flt(item[itmi]["maintrate"]) / 100;

      var mRatefactor = UT.Flt(item[itmi]["ratefactor"]);
      print("billwt-->${slbd[i]["bill_wt"]}");
      MDIFFAMT = (UT.Flt(MDIFFAMT) + (UT.Flt(slbd[i]["bill_wt"])  * UT.Flt(slbd[i]["ptrt_diff"]) / UT.Flt(mRatefactor))).round();


      var hamaliper = UT.Flt(item[itmi]["hamaliper"].toString());
      var hamalion = item[itmi]["hamalion"].toString().trim();
      var hamrate = UT.Flt(item[itmi]["hamalirate"].toString());
      var chamrate = UT.Flt(item[itmi]["chamalirat"].toString());
      var FHamaliFor = 0.0;
      var CHamaliFor = 0.0;
      if (hamaliper > 0.0) {
        switch (hamalion) {
          case "Qty":
            FHamaliFor = UT.Flt(slbd[i]["bill_qty"]) / hamaliper * hamrate;
            CHamaliFor = UT.Flt(slbd[i]["bill_qty"]) / hamaliper * chamrate;
            break;

          case "Weight":
            FHamaliFor = UT.Flt(slbd[i]["bill_gr"]) / hamaliper * hamrate;
            CHamaliFor = UT.Flt(slbd[i]["bill_gr"]) / hamaliper * chamrate;
            break;
        }
      }

      var tolaiper = UT.Flt(item[itmi]["tolaiper"].toString());
      var tolaion = item[itmi]["tolaion"].toString().trim();
      var tolrate = UT.Flt(item[itmi]["tolairate"].toString());
      var ctolrate = UT.Flt(item[itmi]["ctolairate"].toString());
      var FTolaiForm = 0.0;
      var CTolaiForm = 0.0;
      if (tolaiper > 0) {
        switch (tolaion) {
          case "Qty":
            FTolaiForm = UT.Flt(slbd[i]["bill_qty"]) / tolaiper * tolrate;
            CTolaiForm = UT.Flt(slbd[i]["bill_qty"]) / tolaiper * ctolrate;
            break;

          case "Weight":
            FTolaiForm = UT.Flt(slbd[i]["bill_gr"]) / tolaiper * tolrate;
            CTolaiForm = UT.Flt(slbd[i]["bill_gr"]) / tolaiper * ctolrate;
            break;
        }
      }

      var bharaiper = UT.Flt(item[itmi]["bharaiper"].toString());
      var bharaion = item[itmi]["bharaion"].toString().trim();
      var bharrate = UT.Flt(item[itmi]["bharairate"].toString());
      var cbharrate = UT.Flt(item[itmi]["cbharairat"].toString());
      var FBharaiFor = 0.0;
      var CBharaiFor = 0.0;
      if (bharaiper > 0) {
        switch (bharaion) {
          case "Qty":
            FBharaiFor = UT.Flt(slbd[i]["bill_qty"]) / bharaiper * bharrate;
            CBharaiFor = UT.Flt(slbd[i]["bill_qty"]) / bharaiper * cbharrate;
            break;

          case "Weight":
            FBharaiFor = UT.Flt(slbd[i]["bill_gr"]) / bharaiper * bharrate;
            CBharaiFor = UT.Flt(slbd[i]["bill_gr"]) / bharaiper * cbharrate;
            break;
        }
      }

      var mapaiper = UT.Flt(item[itmi]["mapaiper"].toString());
      var mapaion = item[itmi]["mapaion"].toString().trim();
      var maprate = UT.Flt(item[itmi]["mapairate"].toString());
      var cmaprate = UT.Flt(item[itmi]["cmapairate"].toString());
      var FMapaiForm = 0.0;
      var CMapaiForm = 0.0;
      if (mapaiper > 0) {
        switch (mapaion) {
          case "Qty":
            FMapaiForm = UT.Flt(slbd[i]["bill_qty"]) / mapaiper * maprate;
            CMapaiForm = UT.Flt(slbd[i]["bill_qty"]) / mapaiper * cmaprate;
            break;

          case "Weight":
            FMapaiForm = UT.Flt(slbd[i]["bill_gr"]) / mapaiper * maprate;
            CMapaiForm = UT.Flt(slbd[i]["bill_gr"]) / mapaiper * cmaprate;
            break;
        }
      }

      var vigatper = UT.Flt(item[itmi]["vigatper"].toString());
      var vigaton = item[itmi]["vigaton"].toString().trim();
      var vigatrate = UT.Flt(item[itmi]["vigatrate"].toString());
      var FVigatForm = 0.0;
      if (vigatper > 0) {
        switch (vigaton) {
          case "Qty":
            FVigatForm = UT.Flt(slbd[i]["bill_qty"]) / vigatper * vigatrate;
            break;

          case "Weight":
            FVigatForm = UT.Flt(slbd[i]["bill_gr"]) / vigatper * vigatrate;
            break;
        }
      }

      mHamali = UT.Flt(mHamali) + UT.Flt(CHamaliFor);
      mTolai = UT.Flt(mTolai) + UT.Flt(CTolaiForm);
      mBharai = UT.Flt(mBharai) + UT.Flt(CBharaiFor);
      mMapai = UT.Flt(mMapai) + UT.Flt(CMapaiForm);

      if (UT.Flt(item[itmi]["cvat"]) > 0) {
        mXvatonamt = UT.Flt(slbd[i]["line_amt"]) + (UT.Flt(slbd[i]["line_amt"]) * UT.Flt(item[itmi]["sesrate"]) / 100) + (UT.Flt(slbd[i]["line_amt"]) * UT.Flt(item[itmi]["maintrate"]) / 100) + UT.Flt(CHamaliFor) + UT.Flt(CTolaiForm) + UT.Flt(CBharaiFor) + UT.Flt(CMapaiForm);
        mCvatAmt = UT.Flt(mCvatAmt) + mXvatonamt * UT.Flt(CMapaiForm) / 100;
      }

      if (UT.Setup("leivyon") == "Patti" && UT.Setup("leivyto") == "B") {
        mLEIVY = UT.Flt(mLEIVY) + (UT.Flt(FHamaliFor) + UT.Flt(FTolaiForm) + UT.Flt(FBharaiFor) + UT.Flt(FMapaiForm) + UT.Flt(FVigatForm)) * UT.Flt(item[itmi]["blleivy"]) / 100;
      }
      else {
        mLEIVY = 0.0;
      }

      if (UT.Flt(item[itmi]["packchrg_b"]) != 0) {
        if (mPackCalcSt) {
          mPacking = 0.0;
          mPackCalcSt = false;
        }
        mPacking = UT.Flt(mPacking) + UT.Flt(mQty) * UT.Flt(item[itmi]["packchrg_b"]);
      }
      mBLQty = UT.Flt(mBLQty) + UT.Flt(mQty);
      mBLWt = UT.Flt(mBLWt) + UT.Flt(mWeight2);
    }

    if (UT.Setup("ptexprnd") != "No") {
      mMarketFee = (UT.Flt(mMarketFee) * 20).round() / 20;
      mMaintFee = (UT.Flt(mMaintFee) * 20).round() / 20;
      mLEIVY = (UT.Flt(mLEIVY) * 20).round() / 20;
      mComm = (UT.Flt(mComm) * 20).round() / 20;
    }
    if (mCat == "A") {
      mMarketFee = 0.0;
      mMaintFee = 0.0;
      mLEIVY = 0.0;
      mComm = 0.0;
      mBharai = 0.0;
    }

    if (mNocomm) {
      mComm = 0.0;
    }
    slhd[0]['sale_amt'] = mSaleAmt;
    slhd[0]['market_fee'] = mMarketFee;
    slhd[0]['maint_fee'] = mMaintFee;
    slhd[0]['packing'] = mPacking;
    slhd[0]['hamali'] = mHamali;
    slhd[0]['bill_trans'] = mBillTrans;
    slhd[0]['leivy'] = mLEIVY;
    slhd[0]['tolai'] = mTolai;
    slhd[0]['bharai'] = mBharai;
    slhd[0]['mapai'] = mMapai;
    slhd[0]['comm'] = mComm;
    slhd[0]['diff_amt'] = MDIFFAMT;
    slhd[0]['bl_qty'] = mBLQty;
    slhd[0]['bl_wt'] = mBLWt;
    slhd[0]['cvat_amt'] = mCvatAmt;
    print("editData-->$slhd");
    Amt();

  }
   showamt() {

    if (slhd[0]['cashrecd'] > 0) {
      return;
    }
    else {
      if (slhd[0]['cust_code'] == UT.AC("cashsaleac") && !oldent) {
        cashrecd=slhd[0]['tot_amt'];
      }
    }
  }
  //Todo:add new lot
  AddLot(BuildContext context) {
   //Todo:For get new bill_srno first add one blank row into slbd
    var newrow = {};
    print("on click add slbd-->${slbd.length}");
    if (slbd.length == 0||slbd.length == 1 && slbd[0]["bill_srno"].trim() == "") {
        newrow["bill_srno"] = "00001";
      }
      else {
       // var billSrno = double.parse(slbd[slbd.length - 1]["bill_srno"]) + 1;
       var splitBillNo=slbd[slbd.length - 1]["bill_srno"].toString().split(".");
       var billSrno = int.parse(splitBillNo[0].toString()) + 1;
        newrow["bill_srno"] = billSrno.toString().padLeft(5, "0");
        print("new bill srno-->${newrow["bill_srno"]}");
      }
      newrow["bill_no"] = slhd[0]['bill_no'];
      newrow["bsection"] = slhd[0]['bsection'];
      newrow["cust_code"] = slhd[0]['cust_code'];
      newrow["bill_date"] = UT.dateConverter(DateTime.now());
      newrow["item_code"] = '0';
      newrow["pcsperbox"] = '';
      newrow["brand"] = '';
      newrow["bill_qty"] = 0;
      newrow["bill_gr"] = 0;
      newrow["bill_wt"] = 0;
      newrow["bill_avg"] = 0;
      newrow["bill_loose"] = 0;
      newrow["bill_pack"] = 0;
      newrow["pack_rate"] = 0;
      newrow["bill_rate"] = 0;
      newrow["line_amt"] = 0;
      newrow["ptrt_diff"] = 0;
      newrow["inw_no"] = '';
      newrow["inw_srno"] = '';
      newrow["inw_item"] = '';
      newrow["isdeleted"] = 'N';
      newrow["isRowAdded"] = true;
      if (slbd[slbd.length - 1]["bill_srno"].trim() == "") {
        slbd[slbd.length - 1] = newrow;
        // row_indx = 0;
      }
      else {

        slbd.add(newrow);

      }

      addEntryDialog(context,newrow["bill_srno"]);


  }
  UpdateLot(String bill_srno){
    setState(() {
      print(slbd[0]["bill_no"]);
      print("IN update-->$bill_srno");

      var index=UT.getrowindex(slbd, "bill_srno", bill_srno);
      print("IN update-index->$index");
      slbd[index]["bill_no"] = slbd[0]["bill_no"];
      slbd[index]["bsection"] = slhd[0]['bsection'];
      slbd[index]["cust_code"] = slhd[0]['cust_code'];
      slbd[index]["bill_date"] = UT.dateConverter(DateTime.now());
      slbd[index]["item_code"] = itemCode;
      slbd[index]["pcsperbox"] = txtControllerLotNo.text;
      slbd[index]["brand"] = txtControllerBrand.text;
      slbd[index]["bill_qty"] = txtControllerBags.text;
      slbd[index]["bill_gr"] = txtControllerWeight.text;
      slbd[index]["bill_wt"] = 0;
      slbd[index]["bill_avg"] = 0;
      slbd[index]["bill_loose"] = 0;
      slbd[index]["bill_pack"] = 0;
      slbd[index]["pack_rate"] = 0;
      slbd[index]["bill_rate"] = txtControllerRate.text;
      slbd[index]["line_amt"] = txtControllerAmount.text;
      slbd[index]["ptrt_diff"] = txtControllerDiff.text;
      slbd[index]["inw_no"] = '';
      slbd[index]["inw_srno"] = '';
      slbd[index]["inw_item"] = '';
      slbd[index]["isdeleted"] = 'N';
      slbd[index]["isRowAdded"] = true;
      print(slbd);
      Navigator.pop(context);
    });
  }
  DeleteSLBDrow(BuildContext context,srno,int index) {
    var i = UT.getrowindex(slbd, "bill_srno", srno);
    slbd[i]["isdeleted"] = "Y";

    if (slbd[i]["inw_no"] != '' && slbd[i]["inw_srno"] != '' && slbd[i]["inw_item"] != '') {
      var oldQty = slbd[i]["bill_qty"];
      var ii = UT.getrowindex(inwd, "inw_no,inw_srno,inw_item", slbd[i]["inw_no"] + ',' + slbd[i]["inw_srno"] + ',' + slbd[i]["inw_item"]);
      if (ii >= 0) {
        inwd[ii]["sold_qty"] = UT.Flt(inwd[ii]["sold_qty"]) - UT.Flt(oldQty);
        inwd[ii]["cur_pack"] = UT.Flt(inwd[ii]["recd_pack"]) - UT.Flt(inwd[ii]["sold_qty"]);

      }
    }
    slbd.remove(slbd[index]);
    editDeta();
    Fluttertoast.showToast(msg: "Delete successfully!!");
    Navigator.pop(context);
  }



   SaveDT() async {

    var inwDeta = [];
   // AddDate2Arr(slhd.bill_date);
    var data = [];
    data.add(slhd);
    var url = UT.APIURL! +
        "api/LedgPost?year=" +
        UT.curyear.toString()+
        "&EntryType=BILLPOST&Shop="+UT.shop_no!+"&Condition=bill_no=" + txtControllerBillNo.text +
        "and bsection=${slhd[0]['bsection']}&isdelete=true";

    var getData = await UT.apiStr(url);
    print("url-LedgPost1->$getData");

    var _url1 = UT.APIURL! +
        "api/PostData/Post?tblname=slhd" +
        UT.curyear!+ UT.shop_no!;
    _url1 += "&Unique=bsection,bill_no";
    print("SALEHD-_url2->$_url1");
    print("SALEHD-data>$slhd");
    var res = await UT.save2Db(_url1, slhd);
    print("SALEHD-res->$res");

    var _url2 = UT.APIURL! +
        "api/PostData/Post?tblname=slbd" +
        UT.curyear!+ UT.shop_no!;
    _url2 += "&Unique=bsection,bill_no,bill_srno";
    print("SALEBD-_url2->$_url2");
    print("SALEBD-data>$slbd");
    var res1 = await UT.save2Db(_url2, slbd);
    print("SALEBD-res->$res1");

    var url3 = UT.APIURL! +
        "api/LedgPost?year=" +
        UT.curyear.toString()+
        "&EntryType=BILLPOST&Shop="+UT.shop_no!+"&Condition=bill_no=" + txtControllerBillNo.text +
        "and bsection=${slhd[0]['bsection']}";

    var getData1 = await UT.apiStr(url3);
    print("url-LedgPost2->$getData1");
    if (res == "ok" && res1 == "ok") {
      if (inwDeta.length > 0) {

       /* var _url2 = UT.APIURL! +
            "api/PostData/Post?tblname=inwd" +
            UT.curyear!+UT.shop_no!;
        _url1 += "&Unique=inw_no,inw_srno,inw_item";
        var res2 = await UT.save2Db(_url2, inwDeta);*/

      }

      getMaxBillNo();
      return true;
    }
    else {
      return false;
    }
  }

  //TODO:Final save function
   SaveBill() async {

    if (custAcno == '') {
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Customer not selected.");
      return;
    }
    if (tot_amt.text.isEmpty) {
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Not allowed to save Blank entry.");
      return;
    }else{

      slhd[0]['bill_date'] = UT.dateConverter(DateTime.now());
      slhd[0]['cust_code'] = custAcno;
      slhd[0]['acno'] = custAcno;
      slhd[0]['sale_mode'] = "Sale";
      slhd[0]['remark'] = '';
      slhd[0]['chlnlock'] = '';
      slhd[0]['sale_amt'] = sale_amt.text;
      slhd[0]['market_fee'] = market_fee;
      slhd[0]['maint_fee'] = maint_fee;
      slhd[0]['packing'] = packing;
      slhd[0]['hamali'] = hamali.text;
      slhd[0]['bill_trans'] = bill_trans;
      slhd[0]['comm'] = comm.text;
      slhd[0]['diff_amt'] =diff_amt;
      slhd[0]['bl_qty'] = bl_qty;
      slhd[0]['bl_wt'] = bl_wt;
      slhd[0]['bl_comrate'] = bl_comrate;
      slhd[0]['recd_amt'] = recd_amt;
      slhd[0]['bank_acno'] = bankname;

      slhd[0]['cashrecd'] = cashrecd;

      if (slhd[0]['isdeleted'] != "Y") {
        slhd[0]['isdeleted'] = 'N';
      }


      if (!oldent) {
        var url = UT.APIURL! +
            "api/ChkNewSrno?Table=slhd" +
            UT.curyear.toString()+ UT.shop_no.toString()+
            "&Col=bill_no&length=5&SectionCol=bsection&SectionVal="+ slhd[0]['bsection'] + "&ColVal=" + txtControllerBillNo.text;
        print("url-->$url");
        var newBlNo = await UT.apiStr(url);
        print("newBlNo-->$newBlNo");
        slhd[0]['bill_no'] = newBlNo;
        slbd = UT.RepAllCol(slbd, 'bill_no', newBlNo);
      }
      slbd = UT.RepAllCol(slbd, 'bill_date', slhd[0]['bill_date']);
      slbd = UT.RepAllCol(slbd, 'cust_code', slhd[0]['cust_code']);

      var Bill2Print = [];
      //var r = confirm("Do you want to print this bill?");
      //if (r == true) {
      Bill2Print.add(slhd);
      //}
      await SaveDT().then((value){
        if (value==true) {
          DialogBuilder(context).hideOpenDialog();
          Fluttertoast.showToast(msg: "Data saved successfully!");
        }
        else {
          DialogBuilder(context).hideOpenDialog();
          Fluttertoast.showToast(msg: "Problem while data saving!");
        }
      });
    }


  }


}
class AddItem{
  final String brand;
  final String lotNo;
  final String commodity;
  final String bags;
  final String avgWT;
  final String weight;
  final String rate;
  final String difference;
  final String amount;
  final String remark;

  AddItem(
    this.brand,this.lotNo, this.commodity, this.bags, this.avgWT, this.weight,
    this.rate,this.difference,this.amount,this.remark);

}

