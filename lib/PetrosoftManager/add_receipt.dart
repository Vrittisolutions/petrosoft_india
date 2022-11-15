import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/receipt_entry.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_name.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class AddNewReceipt extends StatefulWidget {
  final String mode;
  final Map selectedRow;
  final String SrNo;
   AddNewReceipt({Key? key, required this.SrNo,required this.mode,required this.selectedRow}) : super(key: key);

  @override
  _AddNewReceiptState createState() => _AddNewReceiptState();
}

class _AddNewReceiptState extends State<AddNewReceipt> {
  final amountController=TextEditingController(text: "0.00");
  final balanceController=TextEditingController(text: "0.00");
  final srNoController=TextEditingController();
  final narrationController=TextEditingController();
  final checkNoController=TextEditingController();
  final bankNameController=TextEditingController();
  final GlobalKey<FormState> _formKey =  GlobalKey();
  final GlobalKey<FormFieldState> amountFormFieldKey = GlobalKey<FormFieldState>();
  String? maxNo,_currentSelectedValue;
  bool showCheckNoUI=true;
  dynamic _customerName,_bankName;
  dynamic bankList;
  DateTime? selectedFromDate = DateTime.now();
  String? formattedFromDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBankList();
    if(widget.mode=="Edit"){
      print('mode selectedRow --->${widget.selectedRow}');
      srNoController.text=widget.selectedRow['srno'].toString();
      _customerName=widget.selectedRow['name'].toString();
      amountController.text=widget.selectedRow['amount'].toStringAsFixed(2);
      _bankName=widget.selectedRow['bank'].toString();
      _currentSelectedValue=widget.selectedRow['mode'].toString();
      if(_currentSelectedValue=="cash"){
        showCheckNoUI=false;
      }
      checkNoController.text=widget.selectedRow['chqno'].toString();
      narrationController.text=widget.selectedRow['narration'].toString();
      formattedFromDate=widget.selectedRow['date'].toString();
    }else{
      formattedFromDate = UT.displayDateConverter(selectedFromDate);
      srNoController.text=widget.SrNo;
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    balanceController.dispose();
    srNoController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Receipt Entry',), backgroundColor: ColorsForApp.app_theme_color_owner),
     body:bodyUI(),
      bottomNavigationBar: saveButton(),
   );
  }
  Widget bodyUI(){
    return SingleChildScrollView(
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          paymentField(),
        ],
      ),
    );
  }
  Widget srNoUI(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 45,
          width: 150,
          child: TextFormField(
            controller: srNoController,
            keyboardType: TextInputType.text,
            autofocus: false,
            readOnly: true,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "SrNo", labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget customerName(){
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child:InkWell(
          onTap: ()async{
            var result = await showSearch<String>(
              context: context,
              delegate: CustomDelegate(commonList:UT.customerList,ListType:"CustomerList"),
            );
            setState(() => _customerName = result);
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
                child: Text(_customerName!=null&&_customerName!=''?_customerName:"Select Customer Name", style: StyleForApp.text_style_normal_14_black,),
              )
          ),
        ));
  }
  Widget paymentField(){
    return  Container(
     // height: MediaQuery.of(context).size.height*0.6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key:_formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  srNoUI(),
                  InkWell(
                    onTap: (){
                      selectDate(context);
                    },

                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Container(
                            height: 45,
                            width: 150,
                            decoration: BoxDecoration(//DecorationImage
                              border: Border.all(
                                color: Colors.black38,
                                // width: 8,
                              ), //Border.all
                              borderRadius: BorderRadius.circular(10.0),),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(UT.dateMonthYearFormat(formattedFromDate!)),
                            )
                        )),
                  )
                ],
              ),
              customerName(),
              amount(),
              bankName(),
              dropDown(),
              showCheckNoUI==true? checkNo():Container(),
              narration(),
            ],
          ),
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
              'cheque',
              'RTGS',
              'Transfer',
              'cash'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text("   "+value,style: TextStyle(color: Colors.black),),
              );
            }).toList(),
            hint:Text(
              "   Select mode",
              style:StyleForApp.text_style_normal_14_black
            ),
            onChanged: (value) {
              setState(() {
                _currentSelectedValue = value!;
                if(_currentSelectedValue=="cash"){
                  showCheckNoUI=false;
                  bankNameController.text="By cash";
                }else{
                  showCheckNoUI=true;
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
              labelText: "Cheque No",  labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget bankName(){
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child:InkWell(
          onTap: ()async{
            var result = await showSearch<String>(
              context: context,
              delegate: CustomDelegate(commonList:bankList,ListType: "BankList"),
            );
            setState(() => _bankName = result);
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
                child: Text(_bankName!=null&&_bankName!=''?_bankName:"Select Bank Name", style: StyleForApp.text_style_normal_14_black,),
              )
          ),
        ));
  }
  Widget amount(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 45,
          child: TextFormField(
            controller: amountController,
            key: amountFormFieldKey,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "Amount",  labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
            validator: (value){
              if(double.parse(value.toString())<=0.00){
                return "amount must be greater than 0";
              }
              return null;

            },
            onFieldSubmitted: (term) {
              amountFormFieldKey.currentState!.validate();
            },
            onChanged: (term) {
              amountFormFieldKey.currentState!.validate();
            },
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
              labelText: "Narration",  labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
 Widget balanceUI(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 45,
          // width: 220,
          child: TextFormField(
            controller: balanceController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "Balance",  labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
 }

  getBankList() async {
  //  getBankList(string shop2getBank)
    var _url = UT.APIURL! +
        "api/AccountMaster/getBankList?yr=${UT.curyear}&shop2getBank=" +
        UT.shop_no!;
    var data = await UT.apiDt(_url);
    print(data);
   bankList=data;
   print("bankList-->$bankList");
    return bankList;
  }
 Widget saveButton(){
    return CommonButtonForAllApp(onPressed: () async {
     if(_customerName==null||_customerName==''){
        Fluttertoast.showToast(msg: "Select customer name");
      }else{
       if(widget.mode=="Edit"){
         saveEditedData();
       }else {
         if (_formKey.currentState!.validate()) {
           DialogBuilder(context).showLoadingIndicator('');
           print("ADD-->${UT.m["Selected_ACCNO"]}");
           saveData();
         }
       }

    }
      }, title: 'Save',backgroundColor: ColorsForApp.app_theme_color_owner);
 }
 saveData() async {
    var receiptData=  Map();
    checkNewSrNo().then((value) async {
      if(value!=null){
        print(UT.m["Selected_bankno"]);
        receiptData["srno"]="${srNoController.text}";
        receiptData["date"]="${UT.dateConverter(selectedFromDate)}";
        receiptData["byname"]=_customerName;
        receiptData["acno"]=UT.m["Selected_ACCNO"];
        receiptData["amount"]=amountController.text;
        receiptData["narration"]=narrationController.text;
        receiptData["mode"]=_currentSelectedValue;
        receiptData["chqno"]=checkNoController.text;
        receiptData["bankno"]=UT.m["Selected_bankno"];
        receiptData["bank"]=_bankName;
        receiptData["isdeleted"]="N";

        List receiptList=[];
        receiptList.add(receiptData);
        print("receiptList-->$receiptList");
        var _url1 = UT.APIURL! +
            "api/PostData/Post?tblname=rect" +
            UT.curyear! +
            UT.shop_no!;
        _url1 += "&Unique=srno";
        print("_url-->$_url1");
        var Result1 = await UT.save2Db(_url1, receiptList);
        print("Result1-->$Result1");
        if(Result1=="ok"){
          DialogBuilder(context).hideOpenDialog();
          Fluttertoast.showToast(msg: 'saved successfully');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManagerReceiptEntry()));
        }else{
          DialogBuilder(context).hideOpenDialog();
          Fluttertoast.showToast(msg: 'Something went wrong');
        }
      }
    });
  }

  saveEditedData() async {
    var receiptData=  Map();
    checkNewSrNo().then((value) async {
      if(value!=null){
        print(UT.m["Selected_bankno"]);
        receiptData["srno"]="${srNoController.text}";
        receiptData["date"]=formattedFromDate;
        receiptData["byname"]=_customerName;
        receiptData["acno"]=widget.selectedRow['acno'].toString();
        receiptData["amount"]=amountController.text;
        receiptData["narration"]=narrationController.text;
        receiptData["mode"]=_currentSelectedValue;
        receiptData["chqno"]=checkNoController.text;
        receiptData["bankno"]=widget.selectedRow['bankno'].toString();
        receiptData["bank"]=_bankName;
        receiptData["isdeleted"]=widget.selectedRow['isdeleted'].toString();

        List receiptList=[];
        receiptList.add(receiptData);
        print("receiptList edit -->$receiptList");
        var _url1 = UT.APIURL! +
            "api/PostData/Post?tblname=rect" +
            UT.curyear! +
            UT.shop_no!;
        _url1 += "&Unique=srno";
        print("_url-->$_url1");
        var Result1 = await UT.save2Db(_url1, receiptList);
        print("Result1 of edit -->$Result1");
        if(Result1=="ok"){
          DialogBuilder(context).hideOpenDialog();
          Fluttertoast.showToast(msg: 'saved successfully');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManagerReceiptEntry()));
        }else{
          DialogBuilder(context).hideOpenDialog();
          Fluttertoast.showToast(msg: 'Something went wrong');
        }
      }
    });
  }


  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedFromDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)))!;
    if (picked != selectedFromDate) {
      setState(() {
        selectedFromDate = picked;
        formattedFromDate = UT.displayDateConverter(selectedFromDate);
      });
    }
  }
  Future checkNewSrNo()async{
    var _url = UT.APIURL! +
        "api/ChkNewSrno?Table=rect" +
        UT.shop_no.toString()+
        "&Col=srno&length=5&AddByOne=true";
    var data = await UT.apiStr(_url);
    return data;
  }


}

