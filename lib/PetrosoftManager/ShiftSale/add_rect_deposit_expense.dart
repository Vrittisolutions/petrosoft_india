import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_name.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'expense_receipt_deposit.dart';
class ManagerAddRectExpDeposit extends StatefulWidget {
  final String title;
  final String mode;
  final Map selectedRow;
  const ManagerAddRectExpDeposit({Key? key, required this.title, required this.mode, required this.selectedRow}) : super(key: key);

  @override
  _ManagerAddRectExpDepositState createState() => _ManagerAddRectExpDepositState();
}

class _ManagerAddRectExpDepositState extends State<ManagerAddRectExpDeposit> {
  final amountController=TextEditingController(text: "0.00");
  final balanceController=TextEditingController(text: "0.00");
  final discountController=TextEditingController(text: "0.00");
  final sRNOController=TextEditingController();
  final narrationController=TextEditingController();
  final checkNoController=TextEditingController();
  final bankNameController=TextEditingController();
  final chequeController=TextEditingController();
  final GlobalKey<FormState> _formKey =  GlobalKey();
  String? exp_srno;
  var exp_rect,exp_date,exp_acno,isdeleted,cashier_cd;
  final GlobalKey<FormFieldState> amountFormFieldKey = GlobalKey<FormFieldState>();
  dynamic accountList;
  dynamic _accountName;
  dynamic _pumpName;
 // dynamic bankList;
  List bankList=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccountNameList();
    if(widget.mode=="Edit"&&widget.title=="Receipt"){
      print("Receipt Data-->${widget.selectedRow}");
      _accountName=widget.selectedRow['ac_name'];
      sRNOController.text=widget.selectedRow['srno'];
      exp_srno=widget.selectedRow['exp_srno'];
      exp_rect=widget.selectedRow['exp_rect'];
      exp_date=widget.selectedRow['exp_date'];
      exp_acno=widget.selectedRow['exp_acno'];
      narrationController.text=widget.selectedRow['narr'];
      _pumpName=widget.selectedRow['pump_name'];
      UT.m["Selected_pump_no"]=widget.selectedRow['pump_no'];
      amountController.text=widget.selectedRow['exp_amt'].toStringAsFixed(2);

      getBalance(exp_acno);

    }else if(widget.mode=="Edit"&&widget.title=="Expense"){
      print("Expense Data-->${widget.selectedRow}");
      _accountName=widget.selectedRow['ac_name'];
      sRNOController.text=widget.selectedRow['srno'];
      exp_srno=widget.selectedRow['exp_srno'];
      exp_rect=widget.selectedRow['exp_rect'];
      exp_date=widget.selectedRow['exp_date'];
      exp_acno=widget.selectedRow['exp_acno'];
      narrationController.text=widget.selectedRow['narr'];
      _pumpName=widget.selectedRow['pump_name'];
      UT.m["Selected_pump_no"]=widget.selectedRow['pump_no'];
      amountController.text=widget.selectedRow['exp_amt'].toStringAsFixed(2);
      getBalance(exp_acno);
    }else if(widget.mode=="Edit"&&widget.title=="Deposit"){
      print("Deposit Data-->${widget.selectedRow}");
      _accountName=widget.selectedRow['ac_name'];
      sRNOController.text=widget.selectedRow['srno'];
      exp_srno=widget.selectedRow['exp_srno'];
      exp_rect=widget.selectedRow['exp_rect'];
      exp_date=widget.selectedRow['exp_date'];
      exp_acno=widget.selectedRow['exp_acno'];
      narrationController.text=widget.selectedRow['narr'];
      _pumpName=widget.selectedRow['pump_name'];
      UT.m["Selected_pump_no"]=widget.selectedRow['pump_no'];
      amountController.text=widget.selectedRow['exp_amt'].toStringAsFixed(2);
      getBalance(exp_acno);
    }
    else{
      sRNOController.text=UT.m["slipNoOld"];
      exp_date=UT.m['saledate'];
    }



  }
  @override
  void dispose() {
    amountController.dispose();
    discountController.dispose();
   // balanceController.dispose();
    sRNOController.dispose();
    super.dispose();
  }

  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return  ManagerExpReceiptBankDeposit(title: widget.title,);
    }));
    // return true if the route to be popped
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorsForApp.appThemeColor,
          leading: IconButton(
            highlightColor: Colors.white,
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>  ManagerExpReceiptBankDeposit(title: widget.title)));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          titleSpacing: 0.0,
          title: Text(widget.title=="Receipt"?"Receipt":widget.title=="Expense"?"Expense":widget.title=="Deposit"?"Bank deposit":"",style: PetroSoftTextStyle.style17White,),
        ),
        body:bodyUI(),
        bottomNavigationBar: saveButton(),
      ),
    );
  }
  Widget saveButton(){
    return CommonButtonForAllApp(
      onPressed: () async {
      DialogBuilder(context).showLoadingIndicator('');
      if(widget.title=="Receipt"&&widget.mode=="Edit"){
        postEditedData();
      }else  if(widget.title=="Expense"&&widget.mode=="Edit"){
        postEditedData();
      }else  if(widget.title=="Deposit"&&widget.mode=="Edit"){
        postEditedData();
      }else{
        saveData();
      }


     }, title: 'Save', backgroundColor: ColorsForApp.app_theme_color_owner);
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
          width: 90,
          child: TextFormField(
            controller: sRNOController,
            keyboardType: TextInputType.text,
            autofocus: false,
           // readOnly: true,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "SRNo", labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget ledgerAccountName(){
    return  Padding(
          padding: const EdgeInsets.all(8.0),
          child:InkWell(
            onTap: ()async{
              DialogBuilder(context).showLoadingIndicator('');
              getExpSRNO();
              var result = await showSearch<String>(
                context: context,
                delegate: CustomDelegate(commonList:bankList,ListType: ""),
              );
              setState(() => _accountName = result);
              print("ac name onTap-->${UT.m["Selected_ACCNO"]}");
              if(UT.m["Selected_ACCNO"]!=null){
                DialogBuilder(context).hideOpenDialog();
                getBalance(UT.m["Selected_ACCNO"]);
              }else{
                DialogBuilder(context).hideOpenDialog();
              }


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
                  child: Text(_accountName!=null&&_accountName!=''?_accountName:"Select Ledger Account", style: StyleForApp.text_style_normal_14_black,),
                )
            ),
          ));
  }
  Widget paymentField(){
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key:_formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                srNoUI(),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:Container(
                        height: 45,
                        width: 100,
                        decoration: BoxDecoration(//DecorationImage
                          border: Border.all(
                            color: Colors.black38,
                            // width: 8,
                          ), //Border.all
                          borderRadius: BorderRadius.circular(10.0),),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(UT.dateMonthYearFormat(exp_date.toString())),
                        )
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:Container(
                        height: 45,
                        width: 100,
                        decoration: BoxDecoration(//DecorationImage
                          border: Border.all(
                            color: Colors.black38,
                            // width: 8,
                          ), //Border.all
                          borderRadius: BorderRadius.circular(10.0),),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text("Shift:I")),
                    )
                        )


              ],
            ),
            ledgerAccountName(),
            balanceUI(),
            amount(),
            pumpNameUI(),
            narration()
          ],
        ),
      ),
    );
  }

  Widget narration(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 45,
          // width: 220,
          child: TextFormField(
            controller: narrationController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "Narration", labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget pumpNameUI(){
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child:InkWell(
          onTap: (){
            getPumpList();
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
                child: Text(_pumpName!=null&&_pumpName!=''?_pumpName:"Select Pump", style: StyleForApp.text_style_normal_14_black,),
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
              labelText: "Amount", labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
            validator: (value){
              if(value!.isNotEmpty){
                if(double.parse(value)<=0.00){
                  return "amount must be greater than 0";
                }
                return null;
              }


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
  Widget discountUI(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 45,width: 150,
          child: TextFormField(
            controller: discountController,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "Discount", labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),

          ),
        ));
  }
  Widget chequeUI(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 45,width: 180,
          child: TextFormField(
            controller: checkNoController,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "Cheque", labelStyle: StyleForApp.text_style_normal_14_black
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
            readOnly: true,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "Balance", labelStyle: StyleForApp.text_style_normal_14_black

              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        )
    );
  }
  getPumpList() async {
    List pumpList=[];
    var _url = UT.APIURL! +
        "api/PumpLste/GetData?shop="+UT.shop_no!+
        "&Where=isdeleted<>%27Y%27%20and%20%28clos_date>=%27${UT.yearMonthDateFormat(UT.m['saledate'])}%27%20or%20reset_date=clos_date%29%20order by pump_seq , pump_no";
    var data = await UT.apiDt(_url);
    print("pumNameRES-->$data");
    pumpList=data;
    var result = await showSearch<String>(
      context: context,
      delegate: CustomDelegate(commonList:pumpList,ListType: "pumpList"),
    );
    setState(() => _pumpName = result);
  }
  getAccountNameList() async {


 /*   var _url = UT.APIURL! +
        "api/AccountMaster/GetAcMast?curyear="+UT.curyear!+
        "&shop=" +
        UT.shop_no! +
        "&Where=len%28acno%29 >3%20and%20acno!=%27" + UT.AC("bankprefix") +
        "%27%20and%20left%28acno,3%29!=%27" + UT.AC("cashprefix") + "%27";*/

    if(widget.title=="Deposit"||widget.mode=="Edit"){
      var _url = UT.APIURL! +
          "api/AccountMaster/GetAcMast?curyear="+UT.curyear!+
          "&shop=" + UT.shop_no! +
          "&Where=(left(acno,3)='" + UT.AC("bankprefix") + "'and len(acno)>3) or left(acno,3)='" + UT.AC("cashprefix") + "'or (left(acno,3)='" + UT.AC("bankccac") + "' and len(acno)>3)";

      print("ACNAME URL-->$_url");
      var data = await UT.apiDt(_url);
      print("ACNAME data-->$data");
      bankList=data;
    }else{
         var _url = UT.APIURL! +
        "api/AccountMaster/GetAcMast?curyear="+UT.curyear!+
        "&shop=" +
        UT.shop_no! +
        "&Where=len%28acno%29 >3%20and%20acno!=%27" + UT.AC("bankprefix") +
        "%27%20and%20left%28acno,3%29!=%27" + UT.AC("cashprefix") + "%27";

      print("ACNAME URL-->$_url");

      var data = await UT.apiDt(_url);
      print("ACNAME data-->$data");
      bankList=data;

    }
  }


  getBalance(String acno) async {
    var _url = UT.APIURL! +
        "api/AccountMaster/GetAcBal?curyear=" +
        UT.curyear! +
        "&Shop=" +
        UT.shop_no!+"&acno=" + acno;
    var data = await UT.apiDt(_url);
    print(data);
    balanceController.text=data[0]["balance"].toStringAsFixed(2);
   // DialogBuilder(context).hideOpenDialog();
    return data;
  }
  getExpSRNO()async{
    if(widget.title=="Receipt"){
      var _url = UT.APIURL! +
          "api/getPetroData/GetMaxOTREid?shopno=" +
          UT.shop_no! +
          "&curyear="+UT.curyear.toString()+"&dsrno=" +UT.m["slipNoOld"]+"&exprect=Receipt";
      var data = await UT.apiStr(_url);
      exp_srno=data;
      setState(() {});
    }else if(widget.title=="Deposit"){
      var _url = UT.APIURL! +
          "api/getPetroData/GetMaxOTREid?shopno=" +
          UT.shop_no! +
          "&curyear="+UT.curyear.toString()+"&dsrno=" +UT.m["slipNoOld"]+"&exprect=Deposit";
      var data = await UT.apiStr(_url);
      exp_srno=data;
      setState(() {});
    }else if(widget.title=="Expense"){
      var _url = UT.APIURL! +
          "api/getPetroData/GetMaxOTREid?shopno=" +
          UT.shop_no! +
          "&curyear="+UT.curyear.toString()+"&dsrno=" +UT.m["slipNoOld"]+"&exprect=Expense";
      var data = await UT.apiStr(_url);
      exp_srno=data;
      setState(() {});
    }
  }
  postEditedData() async {
    var receiptData=  Map();
    receiptData["srno"]=sRNOController.text;
    receiptData["exp_rect"]=exp_rect;
    receiptData["exp_srno"]=exp_srno.toString().padLeft(3,"0");
    receiptData["exp_date"]=UT.yearMonthDateFormat(exp_date);
    receiptData["exp_acno"]=exp_acno;
    receiptData["narr"]= narrationController.text;
    receiptData["exp_amt"]=amountController.text;
    receiptData["pump_no"]=UT.m["Selected_pump_no"];
    receiptData["pump_name"]=_pumpName;
    receiptData["cashier_cd"]=cashier_cd;
    receiptData["isdeleted"]="N";
    List receiptList=[];
    receiptList.add(receiptData);
    var _url = UT.APIURL! +
        "api/PostData/Post?tblname=otre" +
        UT.curyear! +
        UT.shop_no!;
    _url += "&Unique=srno,exp_srno,exp_rect";
    var result = await UT.save2Db(_url, receiptList);
    if(result=="ok"){
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: 'saved successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManagerExpReceiptBankDeposit(title: widget.title,)));
    }else{
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }


  saveData() async {
    //DateTime? selectedDate = DateTime.now();

    if(widget.title=="Receipt"){
      var receiptData=  Map();
      receiptData["srno"]=sRNOController.text;
      receiptData["exp_rect"]="Receipt";
      receiptData["exp_srno"]=exp_srno.toString().padLeft(3,"0");
      receiptData["exp_date"]=UT.m["saledate"];
      receiptData["exp_acno"]=UT.m["Selected_ACCNO"];
      receiptData["narr"]= narrationController.text;
      receiptData["exp_amt"]=amountController.text;
      receiptData["pump_no"]=UT.m["Selected_pump_no"];
      receiptData["pump_name"]=_pumpName;
      receiptData["cashier_cd"]=UT.ClientAcno;
      receiptData["isdeleted"]="N";
      List receiptList=[];
      receiptList.add(receiptData);
      print("Post OBJ-->$receiptList");
      var _url = UT.APIURL! +
          "api/PostData/Post?tblname=otre" +
          UT.curyear! +
          UT.shop_no!;
      _url += "&Unique=srno,exp_srno,exp_rect";
      var result = await UT.save2Db(_url, receiptList);
      if(result=="ok"){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'saved successfully');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManagerExpReceiptBankDeposit(title: widget.title,)));
      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
    }
    else if(widget.title=="Expense"){
      var receiptData=  Map();
      receiptData["srno"]=sRNOController.text;
      receiptData["exp_rect"]="Expense";
      receiptData["exp_srno"]=exp_srno.toString().padLeft(3,"0");
      receiptData["exp_date"]=UT.m["saledate"];
      receiptData["exp_acno"]=UT.m["Selected_ACCNO"];
      receiptData["narr"]= narrationController.text;
      receiptData["exp_amt"]=amountController.text;
      receiptData["pump_no"]=UT.m["Selected_pump_no"];
      receiptData["pump_name"]=_pumpName;
      receiptData["cashier_cd"]=UT.ClientAcno;
      receiptData["isdeleted"]="N";
      List receiptList=[];
      receiptList.add(receiptData);
      print("receiptList-->$receiptList");
      var _url = UT.APIURL! +
          "api/PostData/Post?tblname=otre" +
          UT.curyear! +
          UT.shop_no!;
      _url += "&Unique=srno,exp_srno,exp_rect";
      var result = await UT.save2Db(_url, receiptList);
      if(result=="ok"){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'saved successfully');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManagerExpReceiptBankDeposit(title: widget.title,)));
      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
    }
    else if(widget.title=="Deposit"){
      var receiptData=  Map();
      receiptData["srno"]=sRNOController.text;
      receiptData["exp_rect"]="Deposit";
      receiptData["exp_srno"]=exp_srno.toString().padLeft(3,"0");
      receiptData["exp_date"]=UT.m["saledate"];
      receiptData["exp_acno"]=UT.m["Selected_ACCNO"];
      receiptData["narr"]= narrationController.text;
      receiptData["exp_amt"]=amountController.text;
      receiptData["pump_no"]=UT.m["Selected_pump_no"];
      receiptData["pump_name"]=_pumpName;
      receiptData["cashier_cd"]=UT.ClientAcno;
      receiptData["isdeleted"]="N";
      List receiptList=[];
      receiptList.add(receiptData);
      var _url = UT.APIURL! +
          "api/PostData/Post?tblname=otre" +
          UT.curyear! +
          UT.shop_no!;
      _url += "&Unique=srno,exp_srno,exp_rect";
      var result = await UT.save2Db(_url, receiptList);
      if(result=="ok"){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'saved successfully');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManagerExpReceiptBankDeposit(title: widget.title,)));
      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
    }

  }



}
