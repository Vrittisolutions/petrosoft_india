import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/sales_order.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_product.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_vehicle.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddSaleOrders extends StatefulWidget {
  const AddSaleOrders({Key? key}) : super(key: key);

  @override
  _AddSaleOrdersState createState() => _AddSaleOrdersState();
}
class _AddSaleOrdersState extends State<AddSaleOrders> {
  final quantityController=TextEditingController(text: "0.00");
  final rateController=TextEditingController(text: "0.00");
  final amountController=TextEditingController(text: "0.00");
  final slipNoController=TextEditingController();
  final couponNoController=TextEditingController();
  String? maxNo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UT.m["Selected_item_rate"]='';
    getMaxNo();
  }
  @override
  void dispose() {
    quantityController.dispose();
    rateController.dispose();
    amountController.dispose();
    slipNoController.dispose();
    super.dispose();
  }
  dynamic _productName;
  dynamic _vehicleNo;
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorsForApp.app_theme_color,
      statusBarBrightness: Brightness.dark,
    ));

    if(UT.m["Selected_item_rate"]!=''){
      rateController.text=UT.m["Selected_item_rate"].toString();
    }

   return Scaffold(
     appBar: AppBar(
       backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
       title: Text('Sales Order',),),
     body: SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(15.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             const SizedBox(height: 20,),
             couponUI(),
             slipUI(),
             vehicleUI(),
                productNameUI(),
                quantityUI(),
                rateUI(),
                amountUI(),
             const SizedBox(height: 35,),
            saveButton()
           ],
         ),
       ),
     ),

   );
  }
  Widget vehicleUI(){
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          getVehicleList();
        },
        child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(//DecorationImage
              border: Border.all(
                color: Colors.black38,
                // width: 8,
              ), //Border.all
              borderRadius: BorderRadius.circular(10.0),),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(_vehicleNo!=null&&_vehicleNo!=''?_vehicleNo:"Select Vehicle No"),
            )
        ),
      ),
    );
  }
  Widget productNameUI(){
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          getProductList();
        },
        child: Container(
            height: 50,
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
  Widget quantityUI(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 50,
          child: TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "Quantity", labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
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
  Widget rateUI(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 50,
          child: TextFormField(
            readOnly: true,
            controller: rateController   ,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "Rate", labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
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
  Widget amountUI(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 50,
          child: TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "Amount", labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
            validator: (value){
              if(value!.isEmpty||value==""){
                return "Amount should be greater than 0";
              }else{
                return value;
              }
            },
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
  Widget couponUI(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 50,
          // width: 220,
          child: TextFormField(
            controller: couponNoController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "Coupon No", labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget slipUI(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 50,
          // width: 220,
          child: TextFormField(
            controller: slipNoController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "Slip No", labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget saveButton(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0,right:16.0),
              child:CommonButtonForAllApp(
                onPressed: (){
                  saveData();
                },
                title: "Save",
                backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
              )
          ),
        ),
      ],
    );
  }
  Future checkCouponNo() async {
    bool checkStatus;
    var _url = UT.APIURL! +
        "api/CredSale/CheckCouponNo?_curyear="+UT.curyear!+
        "&shop="+ UT.shop_no! +
        "&vouNo=XXX&coupon="+ couponNoController.text;
    var data = await UT.apiStr(_url);
    if(data=="invalid"){
      Fluttertoast.showToast(msg: "Coupon is not issued.");
      return checkStatus=false;
    }else if(data=="error"){
      Fluttertoast.showToast(msg: "This coupon is used for another entry.");
      return checkStatus=false;
    }else{
      return checkStatus=true;
    }
  }
  saveData() async {
    var crhdData= Map();
    var crslData= Map();
   if(couponNoController.text==""||couponNoController.text==null){
      crhdData["coupon_no"]=0;
      crslData["coupon_no"]=0;
      crhdData["cred_vou"]=maxNo.toString().padLeft(6,'0');
      crhdData["date"]=UT.m['saledate'];
      crhdData["cust_code"]=UT.ClientAcno;
      crhdData["veh_no"]= _vehicleNo;
      crhdData["bamount"]=amountController.text;
      crhdData["btot_amt"]=amountController.text;
      crhdData["sale_memo"]=slipNoController.text;
      crhdData["cash_cred"]="Credit";
      crhdData["cashier_cd"]="";
      crhdData["isdeleted"]="N";
      crhdData["isapproved"]="N";
      crslData["cred_vou"]=maxNo.toString().padLeft(6,'0');
      crslData["date"]=UT.m['saledate'];
      crslData["cust_code"]=UT.ClientAcno;
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
      crslData["cashier_cd"]="";
      crslData["isdeleted"]="N";
      crslData["isapproved"]="N";
      crslData["srno"]="001";

    }
    else{
      crhdData["cred_vou"]=maxNo.toString().padLeft(6,'0');
      crhdData["date"]=UT.m['saledate'];
      crhdData["cust_code"]=UT.ClientAcno;
      crhdData["veh_no"]= _vehicleNo;
      crhdData["bamount"]=amountController.text;
      crhdData["btot_amt"]=amountController.text;
      crhdData["sale_memo"]=slipNoController.text;
      crhdData["cash_cred"]="Credit";
      crhdData["cashier_cd"]="";
      crhdData["isdeleted"]="N";
      crhdData["isapproved"]="N";
      crhdData["coupon_no"]=couponNoController.text;

      crslData["cred_vou"]=maxNo.toString().padLeft(6,'0');
      crslData["date"]=UT.m['saledate'];
      crslData["cust_code"]=UT.ClientAcno;
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
      crslData["cashier_cd"]="";
      crslData["isdeleted"]="N";
      crslData["isapproved"]="N";
      crslData["srno"]="001";
      crslData["coupon_no"]=couponNoController.text;
    }

    List crhdDataList=[];
    List crslDataList=[];
    crhdDataList.add(crhdData);
    crslDataList.add(crslData);
    var _url = UT.APIURL! +
        "api/PostData/Post?tblname=mob_crhd" +
        UT.curyear! +
        UT.shop_no!;
    _url += "&Unique=cred_vou";

    var result = await UT.save2Db(_url, crhdDataList);

    var _url1 = UT.APIURL! +
        "api/PostData/Post?tblname=mob_crsl" +
        UT.curyear! +
        UT.shop_no!;
    _url1 += "&Unique=cred_vou,srno,line_no";

    var result1 = await UT.save2Db(_url1, crslDataList);
    if(result=="ok" && result1=="ok"){
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: 'credit sale saved successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SalesOrders()));
    }
  }
  getVehicleList() async {
    UT.m["ValueToSearch"]="VehicleList";
     List vehicleList=[];
    var _url = UT.APIURL! +
        "api/VehLste/GetData?shop=" +
        UT.shop_no! +
        "&Where=cust_code='"+UT.ClientAcno!+"'"
        "&Addrow=false&cols=cust_code,veh_no";
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
    var data = await UT.apiDt(_url);
    productList=data;
    var result = await showSearch<String>(
      context: context,
      delegate: ProductCustomDelegate(vehicleList:productList),
    );
    setState(() => _productName = result);
  }
  getMaxNo()async{
  var _url = UT.APIURL! +
      "api/getPetroCustData/GetMaxCredVouNo?_curyr=" +
      UT.curyear! +
      "&shopno="+UT.shop_no.toString();
  var data = await UT.apiStr(_url);
  maxNo=data;

  setState(() {});
  }
}

