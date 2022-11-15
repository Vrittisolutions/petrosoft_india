import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_name.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'expense_receipt_deposit.dart';
class AddRectExpDeposit extends StatefulWidget {
  final String title;
  const AddRectExpDeposit({Key? key, required this.title}) : super(key: key);

  @override
  _AddRectExpDepositState createState() => _AddRectExpDepositState();
}

class _AddRectExpDepositState extends State<AddRectExpDeposit> {
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
  final GlobalKey<FormFieldState> amountFormFieldKey = GlobalKey<FormFieldState>();
  dynamic accountList;
  dynamic _accountName;
  dynamic _pumpName;
  dynamic pumpNo;
  dynamic bankList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sRNOController.text=UT.m["slipNoOld"];


  }
  @override
  void dispose() {
    amountController.dispose();
    discountController.dispose();
    balanceController.dispose();
    sRNOController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorsForApp.appThemePetroOwner,
        titleSpacing: 0.0,
        title: Text(widget.title=="Receipt"?"Receipt":widget.title=="Expense"?"Expense":widget.title=="Deposit"?"Bank deposit":""),
      ),
      body:bodyUI(),
      bottomNavigationBar: saveButton(),
    );
  }
  Widget saveButton(){
    return CommonButtonForAllApp(
      onPressed: () async {
      DialogBuilder(context).showLoadingIndicator('');

      print("save click-->${UT.m["Selected_ACCNO"]}");
      saveData();
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
              labelText: "No", labelStyle: StyleForApp.text_style_normal_14_black
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
              getAccountNameList();

             // getBalance(UT.m["Selected_ACCNO"]);
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
                          child: Text(UT.dateMonthYearFormat(UT.m['saledate'].toString())),
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
  getPumpList() async {
   /* pumplist = GetURLDt(APIURL + "/api/PumpLste/GetData?shop=" +
        Firm("Shop") + "&Where=isdeleted<>'Y' and "
        "(clos_date>='" + yymmdd($("#date").val()) +"' or reset_date = clos_date)"
        "  order by pump_seq , pump_no");*/
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
    //%28 means (,%29 means ),%20 for space,%27 for single quote '
//bankmast = GetURLDt(APIURL + "/api/AccountMaster/GetAcMast?curyear=" + Setup('curyear') +

// "&shop=" + Firm("Shop") + "&Where=(left(acno,3)='" + AC("bankprefix") + "' and len(acno)!=3)
// or left(acno,3)='" + AC("cashprefix") + "'");
      List cardList=[];


  // print("encode--->$encode");
     /* var _url = UT.APIURL! +
          "api/AccountMaster/GetAcMast?curyear="+UT.curyear!+
          "&shop=" +
          UT.shop_no! +
          "&Where=left%28acno,3%29=%27" + UT.AC("bankprefix") +
          "%27%20and%20len%28acno%29!=3%29%20or%20left%28acno,3%29=%27"
          + UT.AC("cashprefix") +"%27";
*/

       var _url = UT.APIURL! +
          "api/AccountMaster/GetAcMast?curyear="+UT.curyear!+
          "&shop=" +
          UT.shop_no! +
          "&Where=len%28acno%29 >3%20and%20acno!=%27" + UT.AC("bankprefix") +
           "%27%20and%20left%28acno,3%29!=%27" + UT.AC("cashprefix") + "%27";
      print("ACNAME URL-->$_url");
       var data = await UT.apiDt(_url);
      print("ACNAME data-->$data");
      cardList=data;
      var result = await showSearch<String>(
        context: context,
        delegate: CustomDelegate(commonList:cardList,ListType: ""),
      );
      setState(() => _accountName = result);
      print("ac name onTap-->${UT.m["Selected_ACCNO"]}");
      getBalance(UT.m["Selected_ACCNO"]);


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
    DialogBuilder(context).hideOpenDialog();
    return data;
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
              if(double.parse(value!)<=0.00){
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
  saveData() async {
    DateTime? selectedDate = DateTime.now();

    if(widget.title=="Receipt"){
      var receiptData=  Map();
      receiptData["srno"]=sRNOController.text;
      receiptData["exp_rect"]="Receipt";
      receiptData["exp_srno"]=exp_srno.toString().padLeft(3,"0");
      receiptData["exp_date"]=UT.dateConverter(selectedDate);
      receiptData["exp_acno"]=UT.m["Selected_ACCNO"];
      receiptData["narr"]= narrationController.text;
      receiptData["exp_amt"]=amountController.text;
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ExpenseReceiptBankDeposit(title: widget.title,)));
      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
    }else if(widget.title=="Expense"){
      var receiptData=  Map();
      receiptData["srno"]=sRNOController.text;
      receiptData["exp_rect"]="Expense";
      receiptData["exp_srno"]=exp_srno.toString().padLeft(3,"0");
      receiptData["exp_date"]=UT.dateConverter(selectedDate);
      receiptData["exp_acno"]=UT.m["Selected_ACCNO"];
      receiptData["narr"]= narrationController.text;
      receiptData["exp_amt"]=amountController.text;
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ExpenseReceiptBankDeposit(title: widget.title,)));
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
      receiptData["exp_date"]=UT.dateConverter(selectedDate);
      receiptData["exp_acno"]=UT.m["Selected_ACCNO"];
      receiptData["narr"]= narrationController.text;
      receiptData["exp_amt"]=amountController.text;
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ExpenseReceiptBankDeposit(title: widget.title,)));
      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Something went wrong');
      }
    }

  }


}
