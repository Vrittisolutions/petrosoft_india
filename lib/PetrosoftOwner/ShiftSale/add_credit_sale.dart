import 'dart:io';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOperator/capture_images.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/credit_sale_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/PetrosoftOperator/dsr_credit_sale.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_name.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_product.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_vehicle.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class AddCreditSale extends StatefulWidget {
  const AddCreditSale({Key? key}) : super(key: key);

  @override
  _AddCreditSaleState createState() => _AddCreditSaleState();
}

class _AddCreditSaleState extends State<AddCreditSale> {
  dynamic resPdf;
  bool downloading = false;
  var progress = "";
  var path = "No Data";
  dynamic savedPath;
  var platformVersion = "Unknown";
  var _onPressed;
  late Directory externalDir;
  final quantityController=TextEditingController(text: "0.00");
  final rateController=TextEditingController(text: "0.00");
  final amountController=TextEditingController(text: "0.00");
  final totalAmountController=TextEditingController(text: "0.00");
  final serviceChargeController=TextEditingController(text: "0.00");
  final remarkChargeController=TextEditingController();
  final sgstController=TextEditingController(text: "0.00");
  final cgstController=TextEditingController(text: "0.00");
  final slipNoController=TextEditingController();
  final pager=TextEditingController();
  final couponNoController=TextEditingController();
  String? maxNo;
  String? srNo;
  dynamic stringToSendWhatsApp;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UT.m["Selected_item_rate"]='';
    getMaxNo();
    getMaxCouponNo(UT.ClientAcno!).then((value){
      couponNoController.text=value;
    });
  }
  Future<void> downloadFile() async {
    getPdfURl().then((value) async {
      final pdfUrl = "${UT.ReportAPIURL}/reportspdf/"+value+".pdf";
      Dio dio = Dio();
      final status = await Permission.storage.request();
      if (status.isGranted) {
        String dirloc = "";
        if (Platform.isAndroid) {
          dirloc = "/sdcard/download/";
        } else {
          dirloc = (await getApplicationDocumentsDirectory()).path;

        }

        try {
          // FileUtils.mkdir([dirloc]);
          await dio.download(pdfUrl, dirloc + "Invoice" + ".pdf",
              onReceiveProgress: (receivedBytes, totalBytes) {
                print("here 1");
                setState(() {
                  downloading = true;
                  progress = ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
                  print(progress);
                });
                print("here 2");
              });
        } catch (e) {
          print('catch catch catch');
          print(e);
        }

        setState(() {
          downloading = false;
          DialogBuilder(context).hideOpenDialog();

          progress = "Download Completed.";
          // path = dirloc + convertCurrentDateTimeToString() + ".pdf";
          path = dirloc + "Invoice" + ".pdf";
          Navigator.of(context).pop();
        });
        //Navigator.pop(context);
        await Share.shareFiles(
          [path],
          text: "Report",
        );


      } else {
        setState(() {
          progress = "Permission Denied!";
          _onPressed = () {
            downloadFile();
          };
        });
      }
    });


  }
  launchWhatsApp(String mobile,String msg) async {
    final link = WhatsAppUnilink(
      phoneNumber: '+91-$mobile',
      text: msg,
    );
    await launch('$link');
    //  DialogBuilder(context).hideOpenDialog();

  }
  @override
  void dispose() {
    quantityController.dispose();
    rateController.dispose();
    amountController.dispose();
    slipNoController.dispose();
    super.dispose();
  }
  dynamic _customerName;
  dynamic _productName;
  dynamic _vehicleNo;
  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return  const ShiftSaleCreditSale();
    }));
    // return true if the route to be popped
  }
  @override
  Widget build(BuildContext context) {

    if(UT.m["Selected_item_rate"]!=''){
      rateController.text=UT.m["Selected_item_rate"].toString();
    }

    return WillPopScope(
      onWillPop: ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        //backgroundColor: Colors.blue[50],
        appBar: AppBar(title: const Text('Add Credit Sale',), backgroundColor: ColorsForApp.appThemePetroOwner),
        body: bodyUI(),

      ),
    );
  }
  Widget bodyUI(){
    return SingleChildScrollView(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    showMaxNo(),couponUI()
                  ],
                ),
                Row(
                  children: [
                    slipNo(),
                    mobileNo()
                  ],
                ),
                customerName(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    vehicleNo(),
                    SizedBox(
                        height: 45,
                        width: 45,
                        child:IconButton(
                          onPressed: () {
                            UT.SPF!.remove("Vehicle");
                            UT.SPF!.remove("Start");
                            UT.SPF!.remove("End");
                            UT.SPF!.remove("Other1");
                            UT.SPF!.remove("Other2");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CaptureImages("",""),
                              ),
                            );
                          },
                          icon: Icon(Icons.camera_alt,color: ColorsForApp.appThemePetroOwner,),

                        )
                    )
                  ],),
                productName(),
                Row(
                  children: [
                    Expanded(child: quantity()),
                    Expanded(child: rate()),
                    Expanded(child: amount()),

                  ],
                ),
                Row(
                  children: [
                    Expanded(child: serviceCharge()),
                    Expanded(child: CGSTUI()),
                    Expanded(child: sGSTUI()),

                  ],
                ),
                totalAmount(),
                remark(),
                saveButton()
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget couponUI(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 40,
          width: 150,
          child: TextFormField(
            controller: couponNoController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "Coupon No",
              labelText: "Coupon No",
              contentPadding: const EdgeInsets.all(8.0),
            ),
          ),
        ));
  }
  Widget showMaxNo(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:Container(
            height: 40,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorsForApp.app_theme_color_light_operator,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(maxNo!=null?maxNo.toString().padLeft(6,'0'):"",style: TextStyle(color: ColorsForApp.app_theme_color_dark,fontWeight: FontWeight.bold,fontSize: 20),),
            )
        ));
  }
  Widget slipNo(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 40,
          width: 150,
          child: TextFormField(
            controller: slipNoController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "Slip No",
              labelText: "Slip No",
              contentPadding: const EdgeInsets.all(8.0),
            ),
          ),
        ));
  }
  Widget mobileNo(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 40,
          width: 150,
          child: TextFormField(
            controller: pager,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "Mobile No",
              labelText: "Mobile No",
              contentPadding: const EdgeInsets.all(8.0),
            ),
          ),
        ));
  }
  Widget customerName(){
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child:InkWell(
          onTap: ()async{
            _vehicleNo=null;
            UT.m["Selected_veh_no"]='';

            var result = await showSearch<String>(
              context: context,
              delegate: CustomDelegate(commonList:UT.customerList,ListType: ""),
            );
            //  setState(() => _customerName = result);
            setState(() {
              _customerName = result;
              pager.text= UT.m["Selected_pager"];

              if(slipNoController.text.isNotEmpty){

              }else{
                //Todo: if slip no is blank then we get max slip no
                getMaxSlipNo().then((value){
                  slipNoController.text=value;
                });
              }
              if(couponNoController.text.isNotEmpty){

              }else{
                getMaxCouponNo(UT.m["Selected_ACCNO"]).then((value){
                  couponNoController.text=value;
                });
              }


            });
          },
          child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(//DecorationImage
                border: Border.all(
                  color: Colors.black38,
                  // width: 8,
                ), //Border.all
                borderRadius: BorderRadius.circular(10.0),),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(_customerName!=null&&_customerName!=''?_customerName:"Select Customer Name"),
              )
          ),
        ));
  }
  Widget vehicleNo(){
    return  Expanded(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              if(_customerName!=null){
                getVehicleList();
              }else{
                Fluttertoast.showToast(msg: "Please first select customer name");
              }
            },
            child: SizedBox(
              height: 40,
              //width: 200,
              //width: MediaQuery.of(context).size.width*30,
              child: Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(//DecorationImage
                    border: Border.all(
                      color: Colors.black38,
                      // width: 8,
                    ), //Border.all
                    borderRadius: BorderRadius.circular(10.0),),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(_vehicleNo!=null&&_vehicleNo!=''?_vehicleNo:"Select Vehicle No",),
                  )
              ),
            ),
            // child: Text(_vehicleNo!=null&&_vehicleNo!=''?_vehicleNo:"Select Vehicle No"),
          )
      ),
    );
  }
  Widget productName(){
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          if(_customerName!=null){
            getProductList();
          }else{
            Fluttertoast.showToast(msg: "Please first select customer name");
          }
        },
        child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(//DecorationImage
              border: Border.all(
                color: Colors.black38,
                // width: 8,
              ), //Border.all
              borderRadius: BorderRadius.circular(10.0),),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(_productName!=null&&_productName!=''?_productName:"Select product "),
            )
        ),
      ),
    );
  }
  Widget quantity(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 40,
          width: 100,
          child: TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "Quantity",
              labelText: "Quantity",
              contentPadding: const EdgeInsets.all(8.0),
            ),
            onChanged: (value){
              var qty=double.parse(value).toStringAsFixed(2) ;
              var rate=double.parse(rateController.text).toStringAsFixed(2) ;
              double amt=double.parse(qty)*double.parse(rate);
              amountController.text=amt.toStringAsFixed(2);
            },
          ),
        ));
  }
  Widget rate(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 40, width: 100,
          child: TextFormField(
            controller: rateController   ,
            keyboardType: TextInputType.number,
            autofocus: false,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "Rate",
              labelText: "Rate",
              contentPadding: const EdgeInsets.all(8.0),
            ),
            onChanged: (value){
              UT.m["Selected_item_rate"]=value;
              var qty=double.parse(quantityController.text).toStringAsFixed(2) ;
              var rate=double.parse(value).toStringAsFixed(2) ;
              double amt=double.parse(qty.toString())*double.parse(rate.toString());
              amountController.text=amt.toStringAsFixed(2);
            },
          ),
        ));
  }
  Widget amount(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 40, width: 100,
          child: TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            autofocus: false,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "Amount",
              labelText: "Amount",
              contentPadding: const EdgeInsets.all(8.0),
            ),
            onChanged: (value){
              var rate=double.parse(rateController.text).toStringAsFixed(2) ;
              var amt=double.parse(value).toStringAsFixed(2) ;
              if(double.parse(rate.toString())!=0){
                double qty=double.parse(amt.toString())/double.parse(rate.toString());
                quantityController.text=qty.toStringAsFixed(2);
              }
            },
          ),
        ));
  }
  Widget totalAmount(){return Padding(padding: const EdgeInsets.all(8.0),
      child:SizedBox(
        height: 40,
        child: TextFormField(
          controller: totalAmountController,
          keyboardType: TextInputType.number,
          autofocus: false,
          readOnly:  true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.all(8.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            hintText: "Total Amount",
            labelText: "Total Amount",
            labelStyle: TextStyle(
              color: ColorsForApp.app_theme_color_light_operator,
              fontWeight: FontWeight.w600
            )
            //contentPadding: EdgeInsets.all(15.0),
          ),

        ),
      ));}
  Widget serviceCharge(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 40,width: 100,
          child: TextFormField(
            controller: serviceChargeController,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "Service Charge",
              labelText: "Service Charge",
              contentPadding: const EdgeInsets.all(8.0),
            ),
            onChanged: (value){
              var serviceCharge=double.parse(value).toStringAsFixed(2);
              double cgstcal = double.parse(serviceCharge) /100*18/2;
              cgstController.text=cgstcal.toStringAsFixed(2);
              double sgstcal = double.parse(serviceCharge) /100*18/2;
              sgstController.text=sgstcal.toStringAsFixed(2);
              double totalAmt=double.parse(amountController.text)+double.parse(serviceCharge)+double.parse(cgstController.text)+double.parse(sgstController.text);
              totalAmountController.text=totalAmt.toStringAsFixed(2);
            },
          ),
        ));
  }
  Widget remark(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 40,
          child: TextFormField(
            controller: remarkChargeController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              contentPadding: const EdgeInsets.all(8.0),
              hintText: "Remark",
              labelText: "Remark",
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget CGSTUI(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 40,
          width: 100,
          child: TextFormField(
            controller: cgstController,
            keyboardType: TextInputType.number,
            autofocus: false,
            readOnly: true,

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "CGST",
              labelText: "CGST",
              contentPadding: EdgeInsets.all(8.0),
            ),

          ),
        ));
  }
  Widget sGSTUI(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 40,
          width: 100,
          child: TextFormField(
            controller: sgstController,
            keyboardType: TextInputType.number,
            autofocus: false,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              contentPadding: const EdgeInsets.all(8.0),
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "SGST",
              labelText: "SGST",
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Future checkCouponNo() async {
    bool checkStatus;
    var _url = UT.APIURL! +
        "api/CredSale/CheckCouponNo?_curyear="+UT.curyear!+
        "&shop="+ UT.shop_no! +
        "&vouNo=XXX&coupon="+ couponNoController.text;
    var data = await UT.apiStr(_url);
    if(data=="invalid"){
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Coupon is not issued.");
      return checkStatus=false;
    }else if(data=="error"){
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "This coupon is used for another entry.");
      return checkStatus=false;
    }else{
      return checkStatus=true;
    }
  }
  Widget saveButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CommonButtonForAllApp(
            onPressed: () async {
              /* if(_vehicleNo!=null&&_vehicleNo!=''){
                  return showMessage('Select vehicle number');
                } if(_productName!=null&&_vehicleNo!=''){
                  return showMessage('Select product');
                }*/ if(quantityController.text=='0.00'){
                return showMessage('please enter quantity greater than 0');
              }else{
                DialogBuilder(context).showLoadingIndicator('');
                checkCouponNo().then((value){
                  if(value==true){
                    DialogBuilder(context).showLoadingIndicator('');
                    saveData();
                  }
                });
              }

            },
            title: 'Save', backgroundColor: ColorsForApp.appThemePetroOwner,
          ),
        ),
      ],
    );
  }
  showMessage(String msg){
    return Fluttertoast.showToast(msg: msg);
  }
  saveData() async {
    var crhdData=  Map();
    var crslData=  Map();
    checkNewSrNo().then((value) async {
      if(value!=null){
        crhdData["cred_vou"]=value.toString().padLeft(6,'0');
        crhdData["date"]=UT.m['saledate'];
        crhdData["cust_code"]=UT.m["Selected_ACCNO"];
        crhdData["shift"]=UT.m['shift'];
        crhdData["veh_no"]= _vehicleNo;
        crhdData["bamount"]=amountController.text;
        crhdData["btot_amt"]=totalAmountController.text;
        crhdData["sale_memo"]=slipNoController.text;
        crhdData["freight"]=serviceChargeController.text;
        crhdData["addcgsthd"]=cgstController.text;
        crhdData["addsgsthd"]=sgstController.text;
        crhdData["cash_cred"]="Credit";
        crhdData["cashier_cd"]=UT.ClientAcno;
        crhdData["isdeleted"]="N";

        crslData["cred_vou"]=value.toString().padLeft(6,'0');
        crslData["date"]=UT.m['saledate'];
        crslData["cust_code"]=UT.m["Selected_ACCNO"];
        crslData["shift"]=UT.m['shift'];
        crslData["veh_no"]= _vehicleNo;
        crslData["item_code"]=UT.m["Selected_item_code"];
        crslData["qty_sold"]=quantityController.text;
        crslData["rate"]=rateController.text;
        crslData["amount"]=amountController.text;
        crslData["tot_amt"]=amountController.text;
        crslData["sale_memo"]=slipNoController.text;
        crslData["cash_cred"]="Credit";
        crslData["line_no"]="00001";
        crslData["rate1"]=rateController.text;
        crslData["cashier_cd"]=UT.ClientAcno;
        crslData["isdeleted"]="N";
        crslData["srno"]="001";
        crslData["item_note"]=remarkChargeController.text;

        List imageDataList=[];
        for(int i=0;i < UT.imageList.length;i++){
          var imageData= new Map();
          imageData["imageid"]=UT.imageList[i]["imageID"].toString();
          imageData["client_code"]=UT.CustCodeAmt!+UT.curyear!+UT.shop_no!;
          imageData["recordtable"]="crsl"+value.toString().padLeft(6,'0')+"_"+UT.imageList[i]["image_sequenceId"].toString();
          imageDataList.add(imageData);
          var result = UT.saveImages2Server(imageData["imageid"],UT.m["img"+(i+1).toString()]);
        }
        var imageApi_url = UT.APIURL! +
            "api/PostData/Post?tblname=imagedocumenttable";
        imageApi_url += "&Unique=client_code,recordtable&iscommDB=true";
        var response = await UT.save2Db(imageApi_url, imageDataList);
        List crhdDataList=[];
        List crslDataList=[];
        crhdDataList.add(crhdData);
        crslDataList.add(crslData);
        var _url = UT.APIURL! +
            "api/PostData/Post?tblname=crhd" +
            UT.curyear! +
            UT.shop_no!;
        _url += "&Unique=cred_vou";
        var result = await UT.save2Db(_url, crhdDataList);
        var _url1 = UT.APIURL! +
            "api/PostData/Post?tblname=crsl" +
            UT.curyear! +
            UT.shop_no!;
        _url1 += "&Unique=cred_vou,srno,line_no";
        var result1 = await UT.save2Db(_url1, crslDataList);
        UT.apiStr(UT.APIURL!+"/api/LedgPost?EntryType=CREDITSALE&Shop=" + UT.shop_no.toString() + "&Condition=cred_vou='" + crhdData["cred_vou"] + "'");
        if(result=="ok" && result1=="ok"){
          DialogBuilder(context).hideOpenDialog();
          double totalGst=double.parse(cgstController.text)+double.parse(sgstController.text);//double.parse(amountController.text)toStringAsFixed
          stringToSendWhatsApp="Invoice Alert !\nInvoice No. :${value.toString().padLeft(6,'0')}\nInvoice Date :${UT.dateMonthYearFormat(UT.m['saledate'])}\n"
              "Product Name : ${_productName}\nQty :${quantityController.text}\nRate :${double.parse(rateController.text).toStringAsFixed(2)}\nAmount : ${double.parse(amountController.text).toStringAsFixed(2)}\n"
              "Service Charge :${double.parse(serviceChargeController.text).toStringAsFixed(2)}\nGST 18% :${totalGst.toStringAsFixed(2)}\nTotal Amt. : ${double.parse(totalAmountController.text).toStringAsFixed(2)}\n\n\n"
              "From,\n${UT.firm_name}";
          return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(titleTextStyle: TextStyle(fontWeight:FontWeight.bold,fontSize:17,color: UT.PetroOperatorAppColor),
              title: const Text("Alert"),
              content: const Text("You want to send Invoice on WhatsApp ?"),
              actions: <Widget>[
                ButtonBar(
                  buttonMinWidth: 100,
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(

                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DsrCreditSale()));
                          // Navigator.pop(context);
                        }
                    ),
                    ElevatedButton(

                      child: const Text("Send"),

                      onPressed: () async {
                        DialogBuilder(context).showLoadingIndicator('');
                        await launchWhatsApp(pager.text,stringToSendWhatsApp);
                        Future.delayed(const Duration(seconds: 1), () {
                          setState(() {

                          });

                        });
                        downloadFile();
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreditSale()));
        }
      }else{
        Fluttertoast.showToast(msg: '$value');
      }
    });
  }
  getVehicleList() async {
    UT.m["ValueToSearch"]="VehicleList";
    List vehicleList=[];
    var _url = UT.APIURL! +
        "api/VehLste/GetData?shop=" +
        UT.shop_no! +
        "&Where=cust_code='"+UT.m["Selected_ACCNO"]!+
        "'&Addrow=false&cols=cust_code,veh_no";
    var data = await UT.apiDt(_url);
    vehicleList=data;
    var result = await showSearch<String>(
      context: context,
      delegate: VehicleCustomDelegate(vehicleList:vehicleList),
    );
    setState(() => _vehicleNo = result);
  }
  getProductList() async {
    List productList=[];
    var _url = UT.APIURL! +
        "api/ItemEnt9P/getItemWithRate?firmNo=" +
        UT.shop_no! +
        "&date="+ UT.m['saledate'].toString();
    print("_url-->$_url");
    var data = await UT.apiDt(_url);

    print("data-->$data");
    productList=data;

    var result = await showSearch<String>(
      context: context,
      delegate: ProductCustomDelegate(vehicleList:productList),
    );
    setState(() => _productName = result);
  }
  Future getMaxSlipNo()async{
    var _url = UT.APIURL! +
        "api/CredSale/getMax?year4max=" +
        UT.curyear! +
        "&shop4max="+UT.shop_no.toString()+"&col=sale_memo&cust_code=${UT.m["Selected_ACCNO"]}";
    var data = await UT.apiStr(_url);
    if(data==""||data==null){
      return data;
    }else{
      double d=double.parse(data);
      int gg = d.toInt() + 1;
      return gg.toString();
    }
  }
  Future getMaxCouponNo(String cust_code)async{
    var _url = UT.APIURL! +
        "api/CredSale/getMax?year4max=" +
        UT.curyear! +
        "&shop4max="+UT.shop_no.toString()+"&col=coupon_no&cust_code=$cust_code";
    var data = await UT.apiStr(_url);
    if(data==""||data==null){
      return data;
    }else{
      double d=double.parse(data);
      int gg = d.toInt() + 1;
      return gg.toString();
    }

  }
  getMaxNo()async{
    var _url = UT.APIURL! +
        "api/CredSale/GetMaxSrno?curyear=" +
        UT.curyear! +
        "&shop="+UT.shop_no.toString();
    var data = await UT.apiStr(_url);
    maxNo=data;
    setState(() {});
  }

  Future getPdfURl()async{
    var _url = UT.APIURL! +
        "api/CredSalePrint?shop=" +
        UT.shop_no.toString()+
        "&credvou="+srNo.toString().padLeft(6,'0');
    var data = await UT.apiStr(_url);
    return data;
  }
  Future checkNewSrNo()async{
    var _url = UT.APIURL! +
        "api/ChkNewSrno?Table=crhd" +
        UT.curyear! +UT.shop_no.toString()+
        "&Col=cred_vou&length=6";
    var data = await UT.apiStr(_url);
    srNo=data;
    return data;
  }

}



