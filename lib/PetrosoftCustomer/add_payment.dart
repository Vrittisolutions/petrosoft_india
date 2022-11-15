import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/payment.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key? key}) : super(key: key);

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final nameController=TextEditingController();
  final narrationController=TextEditingController();
  final checkNoController=TextEditingController();
  final amountController=TextEditingController(text: "0.00");
  final bankNameController=TextEditingController();
  String? maxNo,_currentSelectedValue;
  bool showCheckNoUI=true;
  String chequeLabel="Cheque No";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMaxNo();
  }
  @override
  void dispose() {
    nameController.dispose();
    narrationController.dispose();
    amountController.dispose();
    checkNoController.dispose();
    bankNameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorsForApp.app_theme_color,
      statusBarBrightness: Brightness.dark,
    ));

    return Scaffold(
     backgroundColor: Colors.orange[150],
        appBar: AppBar(
          backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
          title: Text('Payment',),),
     body:bodyUI(),
   );
  }
  Widget bodyUI(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          paymentField(),
          const SizedBox(height: 30),
          saveButton()
        ],
      ),
    );
  }
  Widget paymentField(){
    return  Container(
      height: MediaQuery.of(context).size.height*0.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            dropDown(),
            showCheckNoUI==true? checkNo():Container(),
            bankName(),
            amount(),
            narration(),
          ],
        ),
      ),
    );
  }
  Widget dropDown(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:Container(
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black38
            ),
            borderRadius: const BorderRadius.all(
                Radius.circular(10.0) //                 <--- border radius here
            ),
          ),
          child: DropdownButton<String>(
            underline: Container(),
            isExpanded: true,
            focusColor:Colors.white,
            value: _currentSelectedValue,
            //elevation: 5,
            style: const TextStyle(color: Colors.white),
            iconEnabledColor:UT.PetrosoftCustomerDarkColor,
            items: <String>[
              'Cheque',
              'RTGS',
              'Transfer',
              'Cash'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text("   "+value,style: const TextStyle(fontSize:16,color: Colors.black),),
              );
            }).toList(),
            hint: Text(
              "   Select mode",
              style: StyleForApp.text_style_normal_14_black
            ),
            onChanged: (value) {
              setState(() {
                _currentSelectedValue = value!;
                if(_currentSelectedValue=="cash"){
                  showCheckNoUI=false;
                  bankNameController.text="By cash";
                }else{

                  if(_currentSelectedValue=="RTGS"||_currentSelectedValue=="Transfer"){
                    chequeLabel="UTR No";
                  }else if(_currentSelectedValue=="cheque"){
                    chequeLabel="Cheque No";
                  }
                  showCheckNoUI=true;
                  bankNameController.clear();
                }
              });
            },
          ),
        ));
  }
  Widget checkNo(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 45,
          child: TextFormField(
            controller: checkNoController   ,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              //hintText: chequeLabel, hintStyle: StyleForApp.text_style_normal_14_black,
              labelText: chequeLabel,
                labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget bankName(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 45,
          // width: 220,
          child: TextFormField(
            controller: bankNameController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              //hintText: "Bank Name", hintStyle: StyleForApp.text_style_normal_14_black,
              labelText: "Bank Name",
                labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget amount(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 45,
          child: TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              //hintText: "Amount", hintStyle: StyleForApp.text_style_normal_14_black,
              labelText: "Amount",
                labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget narration(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 45,
          child: TextFormField(
            controller: narrationController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              //hintText: "Narration", hintStyle: StyleForApp.text_style_normal_14_black,
              labelText: "Narration",
                labelStyle: StyleForApp.text_style_normal_14_black
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
         // width: 180,
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
  saveData() async {
    var paymentData= new Map();
    getMaxNo();
    paymentData["srno"]=maxNo.toString().padLeft(5,'0');
    paymentData["date"]=UT.m['saledate'];
    paymentData["acno"]=UT.ClientAcno;
    paymentData["amount"]=amountController.text;
    paymentData["narration"]=narrationController.text;
    paymentData["mode"]=_currentSelectedValue;
    paymentData["chqno"]=checkNoController.text;
    paymentData["bank"]=bankNameController.text;
    paymentData["isdeleted"]="N";
    paymentData["isapproved"]="N";

    List paymentList=[];
    paymentList.add(paymentData);
    var _url1 = UT.APIURL! +
        "api/PostData/Post?tblname=mob_rect" +
        UT.curyear! +
        UT.shop_no!;
    _url1 += "&Unique=srno";
    var result1 = await UT.save2Db(_url1, paymentList);
    if(result1=="ok"){
      Fluttertoast.showToast(msg: 'saved successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Payment()));
    }else{
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }
  getMaxNo()async{
  var _url = UT.APIURL! +
      "api/getPetroCustData/GetMaxRectSrno?year=" +
      UT.curyear! +
      "&shop="+UT.shop_no.toString();
  var data = await UT.apiStr(_url);
  maxNo=data;
  setState(() {});
  }
}

