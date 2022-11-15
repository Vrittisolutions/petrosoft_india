import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/sales_order.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_product.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_vehicle.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddMemoEntry extends StatefulWidget {
  const AddMemoEntry({Key? key}) : super(key: key);

  @override
  _AddMemoEntryState createState() => _AddMemoEntryState();
}
class _AddMemoEntryState extends State<AddMemoEntry> {
  final weightController=TextEditingController(text: "0.00");
  final bagsController=TextEditingController(text: "0.00");
  final totalBagController=TextEditingController(text: "0.00");
  final slipNoController=TextEditingController();
  final vehicleController=TextEditingController();
  final itemNameController=TextEditingController();
  final transporterNameController=TextEditingController();
  String? maxNo;
  String? displayDateFormat;
  DateTime? selectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displayDateFormat=UT.displayDateConverter(selectedDate);

  }
  @override
  void dispose() {
    weightController.dispose();
    bagsController.dispose();
    totalBagController.dispose();
    slipNoController.dispose();
    super.dispose();
  }
  dynamic _productName;
  dynamic _vehicleNo;
  @override
  Widget build(BuildContext context) {
print(UT.m["Selected_item_rate"]);
    if(UT.m["Selected_item_rate"]!=null){
      print("s");
      bagsController.text=UT.m["Selected_item_rate"].toString();
    }else{
      bagsController.text='0.00';
    }

   return Scaffold(
     backgroundColor: Colors.white,
     appBar: AppBar(
        backgroundColor: UT.adatSoftSellerAppColor,
       iconTheme: StyleForApp.iconThemeData,
       title: const CommonAppBarText(title: "Memo Entry"),
       actions: [
         InkWell(
             onTap: () async {
               openDatePicker(context);
             },
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Row(
                 children: [
                   const Icon(
                     Icons.date_range_rounded,
                     color: Colors.white,
                   ),
                   const SizedBox(
                     width: 10,
                   ),
                   Text("$displayDateFormat",style: StyleForApp.text_style_bold_14_white,)
                 ],
               ),
             )),
       ],
     ),
     body: SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(15.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             firmSelectionUI(),
             transporterUI(),
              vehicleUI(),

             Row(
               children: [
                 itemNameUI(),
                 totalBagsUI(),
               ],
             ),
                Row(
                  children: [
                    bagsUI(),
                    weightUI(),
                  ],
                ),
           //  submitButton()
           ],
         ),
       ),
     ),
     bottomNavigationBar: Padding(
       padding: const EdgeInsets.only(bottom: 5.0),
         child: submitButton()),
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
            height: 45,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(//DecorationImage
              border: Border.all(
                color: Colors.black38,
                // width: 8,
              ), //Border.all
              borderRadius: BorderRadius.circular(10.0),),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(_vehicleNo!=null&&_vehicleNo!=''?_vehicleNo:"Select vehicle No ", style: StyleForApp.text_style_normal_14_black,),
            )
        ),
      ),
    );
  }
  Widget itemNameUI(){
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        width: 195,
        child: TextFormField(
          controller: itemNameController,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            hintText: "Item name",
            labelText: "Item Name",
            //contentPadding: EdgeInsets.all(15.0),
          ),
          onChanged: (value){
          },
        ),
      ),
    );
  }
  Widget weightUI(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 50,
          width: 100,
          child: TextFormField(
            controller: weightController,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "Weight",
              labelText: "Weight",
              //contentPadding: EdgeInsets.all(15.0),
            ),
            onChanged: (value){
            },
          ),
        ));
  }
  Widget bagsUI(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 50,
          width: 100,
          child: TextFormField(
            readOnly: true,
            controller: bagsController   ,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "Bags",
              labelText: "Bags",
              //contentPadding: EdgeInsets.all(15.0),
            ),
            onChanged: (value){

            },
          ),
        ));
  }
  Widget totalBagsUI(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 50,
          width: 100,
          child: TextFormField(
            controller: totalBagController,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "Total Bags",
              labelText: "Total Bags",
              //contentPadding: EdgeInsets.all(15.0),
            ),
            validator: (value){

            },
            onChanged: (value){
              var rate=double.parse(bagsController.text).toStringAsFixed(2) ;
              var amt=double.parse(value).toStringAsFixed(2) ;
              if(double.parse(rate.toString())!=0){
                double qty=double.parse(amt.toString())/double.parse(rate.toString());
                weightController.text=qty.toStringAsFixed(2);
              }
            },
          ),
        ));
  }
  Widget transporterUI(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 50,
          // width: 220,
          child: TextFormField(
            controller: transporterNameController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "Transporter Name",
              labelText: "Transporter Name",
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget firmSelectionUI(){
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
              hintText: "Firm Name",
              labelText: "Firm Name",
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget submitButton(){
    return CommonButtonForAllApp(onPressed: (){
      if(_vehicleNo==null||_vehicleNo==""){
        Fluttertoast.showToast(msg: "Please select vehicle");
      }else if(_productName==null||_productName==""){
        Fluttertoast.showToast(msg: "Please select product");
      }if(transporterNameController.text==null||transporterNameController.text==""){

      }else{

      }
    },
   title: 'Save',backgroundColor: UT.adatSoftSellerAppColor,);
  }
  Future checkCouponNo() async {
    bool checkStatus;
    var _url = UT.APIURL! +
        "api/CredSale/CheckCouponNo?_curyear="+UT.curyear!+
        "&shop="+ UT.shop_no! +
        "&vouNo=XXX&coupon="+ transporterNameController.text;
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
   if(transporterNameController.text==""||transporterNameController.text==null){
      crhdData["coupon_no"]=0;
      crslData["coupon_no"]=0;
      crhdData["cred_vou"]=maxNo.toString().padLeft(6,'0');
      crhdData["date"]=UT.m['saledate'];
      crhdData["cust_code"]=UT.ClientAcno;
      crhdData["veh_no"]= _vehicleNo;
      crhdData["bamount"]=totalBagController.text;
      crhdData["btot_amt"]=totalBagController.text;
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
      crslData["qty_sold"]=weightController.text;
      crslData["rate"]=bagsController.text;
      crslData["amount"]=totalBagController.text;
      crslData["tot_amt"]=totalBagController.text;
      crslData["sale_memo"]=slipNoController.text;
      crslData["cash_cred"]="Credit";
      crslData["line_no"]="00001";
      crslData["rate1"]=bagsController.text;
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
      crhdData["bamount"]=totalBagController.text;
      crhdData["btot_amt"]=totalBagController.text;
      crhdData["sale_memo"]=slipNoController.text;
      crhdData["cash_cred"]="Credit";
      crhdData["cashier_cd"]="";
      crhdData["isdeleted"]="N";
      crhdData["isapproved"]="N";
      crhdData["coupon_no"]=transporterNameController.text;

      crslData["cred_vou"]=maxNo.toString().padLeft(6,'0');
      crslData["date"]=UT.m['saledate'];
      crslData["cust_code"]=UT.ClientAcno;
      crslData["veh_no"]= _vehicleNo;
      crslData["item_code"]=UT.m["Selected_item_code"];
      crslData["qty_sold"]=weightController.text;
      crslData["rate"]=bagsController.text;
      crslData["amount"]=totalBagController.text;
      crslData["tot_amt"]=totalBagController.text;
      crslData["sale_memo"]=slipNoController.text;
      crslData["cash_cred"]="Credit";
      crslData["line_no"]="00001";
      crslData["rate1"]=bagsController.text;
      crslData["cashier_cd"]="";
      crslData["isdeleted"]="N";
      crslData["isapproved"]="N";
      crslData["srno"]="001";
      crslData["coupon_no"]=transporterNameController.text;
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
    print("Vehicle list-->$data");
     vehicleList=data;
     if(data.length==0){
       Fluttertoast.showToast(msg: "No data found");
     }else{
       var result = await showSearch<String>(
         context: context,
         delegate: VehicleCustomDelegate(vehicleList:vehicleList),
       );
       setState(() => _vehicleNo = result);
     }

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
  Future<void> openDatePicker(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)))!;
    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        displayDateFormat = UT.displayDateConverter(selectedDate);
      });
    }
  }
}

