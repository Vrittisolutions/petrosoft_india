import 'dart:convert';

import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/card_sale.dart';
import 'package:petrosoft_india/PetrosoftOperator/card_sale.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_name.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCardSale extends StatefulWidget {
  final String mode;
  final Map selectedRow;
  const AddCardSale({Key? key, required this.mode, required this.selectedRow}) : super(key: key);

  @override
  _AddCardSaleState createState() => _AddCardSaleState();
}

class _AddCardSaleState extends State<AddCardSale> {
  final amountController=TextEditingController(text: "0.00");
  final batchNoController=TextEditingController();
  String? batchNo;
  String? bsrno;
  String _currentSelectedValue='';
  String? dsrno,dsr_date,pump_hold,isdeleted;
  List cardList=[];
  List cashierList=[];
  dynamic cashierName;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.mode=="Edit") {
      callCardAPI();
      print(widget.selectedRow);
      UT.m["Selected_ACCNO"]=widget.selectedRow['acno'];
      dsrno=widget.selectedRow['dsr_no'];
      bsrno=widget.selectedRow['bsrno'];
      dsr_date=widget.selectedRow['dsr_date'];
      batchNoController.text=widget.selectedRow['bat_no'].toStringAsFixed(2);
      amountController.text=widget.selectedRow['bamount'].toStringAsFixed(2);
      _currentSelectedValue=widget.selectedRow['mode'];
      isdeleted=widget.selectedRow['isdeleted'];
    }else{
      callCardAPI();
      _currentSelectedValue="Receivable";
    }

  }
  callCardAPI() async {
    await getCardList();
  }
  @override
  void dispose() {
    amountController.dispose();
    batchNoController.dispose();
    super.dispose();
  }
  dynamic _cardName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue[50],
      appBar: AppBar(title: const Text('Card Sale',), backgroundColor: ColorsForApp.appThemeColor),
      body:bodyUI(),
      bottomNavigationBar: saveButton(),
    );
  }
  Widget bodyUI(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const SizedBox(height: 20,),
            cardName(),
            batchNoUI(),
            amount(),
            dropdownUI(),
          ],
        ),
      ),
    );
  }
  Widget cardName(){
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child:InkWell(
          onTap: ()async{
            // _vehicleNo=null;
            //UT.m["Selected_veh_no"]='';
            var result = await showSearch<String>(
              context: context,
              delegate: CustomDelegate(commonList:cardList,ListType: ""),
            );
            getBatchNo();
            getBsrNo();
            setState(() => _cardName = result);

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
                child: Text(_cardName!=null&&_cardName!=''?_cardName:"Select Card", style: StyleForApp.text_style_normal_14_black,),
              )
          ),
        ));
  }
  Widget batchNoUI(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 45,
          // width: 220,
          child: TextFormField(
            controller: batchNoController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                labelText: "Batch No", labelStyle: StyleForApp.text_style_normal_14_black
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
                labelText: "Amount", labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),

        ));
  }
  Widget dropdownUI(){
    return  Padding(padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
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
            iconEnabledColor:UT.ownerAppColor,
            items: <String>[
              'Receivable',
              'Payable'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(" "+value,style: const TextStyle(color: Colors.black),),
              );
            }).toList(),
            hint: Text(
              "  Select mode",
              style: StyleForApp.text_style_normal_14_black,
            ),
            onChanged: (value) {
              setState(() {
                _currentSelectedValue = value!;
              });
            },
          ),
        ));
  }
  Widget pumpNameUI(){
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child:InkWell(
          onTap: () async {
            var result = await showSearch<String>(
              context: context,
              delegate: CustomDelegate(commonList:cashierList,ListType: "cashierList"),
            );
            setState(() => cashierName = result);
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
                child: Text(cashierName!=null&&cashierName!=''?cashierName:"Select Cashier", style: StyleForApp.text_style_normal_14_black,),
              )
          ),
        ));
  }
  Widget saveButton(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: CommonButtonForAllApp(onPressed: (){
        if(bsrno!=null){
          if(amountController.text!=0){
            DialogBuilder(context).showLoadingIndicator('');
            if(widget.mode=="Edit"){
              postEditedData();
            }else{
              postData();
            }

          }else{
            Fluttertoast.showToast(msg: "amount must be greater than 0");
          }
        }else{
          Fluttertoast.showToast(msg: "bsrno empty");
        }
      }, title: 'Save',backgroundColor: ColorsForApp.app_theme_color_owner),
    );
  }

  getBatchNo()async{
    var _url = UT.APIURL! +
        "api/PumpTrnE/GetMaxBatchNo?year4batchno=" +
        UT.curyear! +
        "&shop4batno="+UT.shop_no.toString()+"&acno=" +UT.m["Selected_ACCNO"];
    var data = await UT.apiStr(_url);
    batchNo=data;
    batchNoController.text=batchNo.toString().replaceAll(".00", " ");
    setState(() {});
  }
  getBsrNo()async{
    var _url = UT.APIURL! +
        "api/getPetroData/GetMaxBathNo?year4batno=" +
        UT.curyear! +
        "&shop4batno="+UT.shop_no.toString()+"&dsrno=" +UT.m["dSrNo"];
    var data = await UT.apiStr(_url);
    bsrno=data;
    setState(() {});
  }
  postData() async {
  //  DateTime? selectedDate = DateTime.now();
    var cardSaleData= Map();
    cardSaleData["dsr_no"]=UT.m["dSrNo"];
    cardSaleData["bsrno"]=bsrno;
    cardSaleData["dsr_date"]=UT.m['saledate'];
    cardSaleData["acno"]=UT.m["Selected_ACCNO"];
    cardSaleData["bat_no"]= batchNoController.text;
    cardSaleData["mode"]=_currentSelectedValue;
    cardSaleData["bamount"]=amountController.text;
    cardSaleData["pump_hold"]=UT.ClientAcno;
    cardSaleData["isdeleted"]="N";
    List crhdDataList=[];
    crhdDataList.add(cardSaleData);
    print(crhdDataList);
    var _url = UT.APIURL! +
        "api/PostData/Post?tblname=bath" +
        UT.curyear! +
        UT.shop_no!;
    _url += "&Unique=dsr_no,bsrno";
    var result = await UT.save2Db(_url, crhdDataList);
    if(result=="ok"){
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: 'card sale saved successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CardSale()));
    }else{
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }
  postEditedData() async {
    var cardSaleData= Map();
    cardSaleData["dsr_no"]=dsrno;
    cardSaleData["bsrno"]=bsrno;
    cardSaleData["dsr_date"]=UT.yearMonthDateFormat(dsr_date!);
    cardSaleData["acno"]=UT.m["Selected_ACCNO"];
    cardSaleData["bat_no"]= batchNoController.text;
    cardSaleData["mode"]=_currentSelectedValue;
    cardSaleData["bamount"]=amountController.text;
    cardSaleData["pump_hold"]=UT.ClientAcno;
    cardSaleData["isdeleted"]=isdeleted;
    List crhdDataList=[];
    crhdDataList.add(cardSaleData);
    print("Edited data-->$crhdDataList");
    print(crhdDataList);
    var _url = UT.APIURL! +
        "api/PostData/Post?tblname=bath" +
        UT.curyear! +
        UT.shop_no!;
    _url += "&Unique=dsr_no,bsrno";
    var result = await UT.save2Db(_url, crhdDataList);
    if(result=="ok"){
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: 'card sale saved successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CardSale()));
    }else{
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  getCardList() async {

    var _url = UT.APIURL! +
        "api/AccountMaster/GetAcMast?curyear="+UT.curyear!+
        "&shop=" +
        UT.shop_no! +
        "&Where=acno%20like%20'" + UT.AC("swapmcac") + "%%27%20and%20acno!=%27" + UT.AC("swapmcac") + "'";
    cardList = await UT.apiDt(_url);
    if(widget.mode=="Edit"){
      for(int i=0;i<cardList.length;i++){
        _cardName = UT.GetRow(cardList, "acno", widget.selectedRow['acno'].trim(),'name');
        //print("cardNN-->$_cardName");
      }
    }
    setState(() {

    });
  }
}

