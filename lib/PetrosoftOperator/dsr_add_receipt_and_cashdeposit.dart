import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/PetrosoftOperator/dsr_receipt_expense_bank.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_name.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddReceiptCashDeposite extends StatefulWidget {
  final String title;
  final String mode;
  final Map selectedRow;
  const AddReceiptCashDeposite({Key? key, required this.title, required this.mode, required this.selectedRow}) : super(key: key);

  @override
  _AddReceiptCashDepositeState createState() => _AddReceiptCashDepositeState();
}

class _AddReceiptCashDepositeState extends State<AddReceiptCashDeposite> {
  final amountController=TextEditingController(text: "0.00");
  final narrationController=TextEditingController();
  String? exp_srno;
  var exp_rect,exp_date,exp_acno,isdeleted,cashier_cd;

  var srno;

  var cardList=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAccountNameList();
    if(widget.mode=="Edit"&&widget.title=="Receipt"){
      print("Receipt Data-->${widget.selectedRow}");
         _cardName=widget.selectedRow['name'];
          amountController.text=widget.selectedRow['exp_amt'].toStringAsFixed(2);
          narrationController.text=widget.selectedRow['narr'];
        exp_rect=widget.selectedRow['exp_rect'];
      UT.m["Selected_ACCNO"]=widget.selectedRow['exp_acno'];
      exp_srno=widget.selectedRow['exp_srno'];
      srno=widget.selectedRow['srno'];



    }else if(widget.mode=="Edit"&&widget.title=="Expense"){
      print("Expense Data-->${widget.selectedRow}");
      _cardName=widget.selectedRow['name'];
      amountController.text=widget.selectedRow['exp_amt'].toStringAsFixed(2);
      narrationController.text=widget.selectedRow['narr'];
      exp_rect=widget.selectedRow['exp_rect'];
      UT.m["Selected_ACCNO"]=widget.selectedRow['exp_acno'];
      exp_srno=widget.selectedRow['exp_srno'];
      srno=widget.selectedRow['srno'];

    }
    else if(widget.mode=="Edit"&&widget.title=="Deposit"){
      print("Deposit Data-->${widget.selectedRow}");
      _cardName=widget.selectedRow['name'];
      amountController.text=widget.selectedRow['exp_amt'].toStringAsFixed(2);
      narrationController.text=widget.selectedRow['narr'];
      exp_rect=widget.selectedRow['exp_rect'];
      UT.m["Selected_ACCNO"]=widget.selectedRow['exp_acno'];
      exp_srno=widget.selectedRow['exp_srno'];
      srno=widget.selectedRow['srno'];

    }
  }
  @override
  void dispose() {
    narrationController.dispose();
    amountController.dispose();
    super.dispose();
  }
  var _cardName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    // backgroundColor: Colors.blue[50],
      appBar: AppBar(title:  Text(widget.title,style: PetroSoftTextStyle.style17White,),titleSpacing: 0.0, backgroundColor: ColorsForApp.appThemeColor),
     body: bodyUI(),
      bottomNavigationBar: saveButton(),
   );
  }
  Widget bodyUI(){
    return SingleChildScrollView(
      child: Column(
        children: [
        const SizedBox(height: 20,),
          SizedBox(
          //  height: MediaQuery.of(context).size.height*0.4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    //  const SizedBox(height: 20,),
                      receiptFields(),
                      //const SizedBox(height: 20,),
                    ],
                  )
                ),
              ),
          ),

          ),
      ]
      ),
    );

  }
  Widget receiptFields(){
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            cardName(),
            amount(),
            narration(),
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
            var result = await showSearch<String>(
              context: context,
              delegate: CustomDelegate(commonList:cardList,ListType: ""),
            );
            setState(() => _cardName = result);
            getExpSRNO();

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
                child: Text(_cardName!=null&&_cardName!=''?_cardName:"Select Account name"),
              )
          ),
        ));
  }
  Widget amount(){
    return Padding(padding: const EdgeInsets.all(8.0),
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

  Widget saveButton(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: CommonButtonForAllApp(onPressed: (){
        if(amountController.text!=0||amountController.text.isNotEmpty){
          DialogBuilder(context).showLoadingIndicator('');
          if(widget.title=="Receipt"&&widget.mode=="Edit"){
            saveEditedData();
          }else  if(widget.title=="Expense"&&widget.mode=="Edit"){
            saveEditedData();
          }else  if(widget.title=="Deposit"&&widget.mode=="Edit"){
            saveEditedData();
          }else{
            saveData();
          }
        }else{
          Fluttertoast.showToast(msg: "amount must be greater than 0");
        }
      }, title: 'Save',backgroundColor: ColorsForApp.appThemeColor, ),
    );

  }
  getExpSRNO()async{
    if(widget.title=="Receipt"){
      var _url = UT.APIURL! +
          "api/getPetroData/GetMaxOTREid?shopno=" +
          UT.shop_no! +
          "&curyear="+UT.curyear.toString()+"&dsrno=" +UT.m["dSrNo"]+"&exprect="+widget.title;
      var data = await UT.apiStr(_url);
      exp_srno=data;
      setState(() {});
    }else if(widget.title=="Deposit"){
      var _url = UT.APIURL! +
          "api/getPetroData/GetMaxOTREid?shopno=" +
          UT.shop_no! +
          "&curyear="+UT.curyear.toString()+"&dsrno=" +UT.m["dSrNo"]+"&exprect="+"Deposit";
      var data = await UT.apiStr(_url);
      exp_srno=data;
      setState(() {});
    }else{
      var _url = UT.APIURL! +
          "api/getPetroData/GetMaxOTREid?shopno=" +
          UT.shop_no! +
          "&curyear="+UT.curyear.toString()+"&dsrno=" +UT.m["dSrNo"]+"&exprect="+"Expense";
      var data = await UT.apiStr(_url);
      exp_srno=data;
      setState(() {});
    }
  }
  saveData() async {

   if(widget.title=="Receipt"){
     print("ADD Title-->${widget.title}");
     var recepitData=  Map();
     recepitData["srno"]=UT.m["dSrNo"];
     recepitData["exp_rect"]="Receipt";
     recepitData["exp_srno"]=exp_srno.toString().padLeft(3,"0");
     recepitData["exp_date"]=UT.m['saledate'];
     recepitData["exp_acno"]=UT.m["Selected_ACCNO"];
     recepitData["narr"]= narrationController.text;
     recepitData["exp_amt"]=amountController.text;
     recepitData["pump_no"]=UT.m["PUMP_NO"];
     recepitData["cashier_cd"]=UT.ClientAcno;
     recepitData["isdeleted"]="N";
     List receiptList=[];
     receiptList.add(recepitData);
     var _url = UT.APIURL! +
         "api/PostData/Post?tblname=otre" +
         UT.curyear! +
         UT.shop_no!;
     _url += "&Unique=srno,exp_srno";
     var Result = await UT.save2Db(_url, receiptList);
     if(Result=="ok"){
       DialogBuilder(context).hideOpenDialog();
       Fluttertoast.showToast(msg: 'Receipt  saved successfully');
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DsrReceiptCashDeposit(title: widget.title,)));
     }else{
       DialogBuilder(context).hideOpenDialog();
       Fluttertoast.showToast(msg: 'Something went wrong please try again sometime!!');
     }
   }
   else if(widget.title=="Deposit"){
     print("ADD Title-->${widget.title}");
     var recepitData=  Map();
     recepitData["srno"]=UT.m["dSrNo"];
     recepitData["exp_rect"]="Deposit";
     recepitData["exp_srno"]=exp_srno.toString().padLeft(3,"0");
     recepitData["exp_date"]=UT.m['saledate'];
     recepitData["exp_acno"]=UT.m["Selected_ACCNO"];
     recepitData["narr"]= narrationController.text;
     recepitData["exp_amt"]=amountController.text;
     recepitData["cashier_cd"]=UT.ClientAcno;
     recepitData["pump_no"]=UT.m["PUMP_NO"];
     recepitData["isdeleted"]="N";
     List cashDepositList=[];
     cashDepositList.add(recepitData);
     print("cashDepositList-->$cashDepositList");
     var _url = UT.APIURL! +
         "api/PostData/Post?tblname=otre" +
         UT.curyear! +
         UT.shop_no!;
     _url += "&Unique=srno,exp_srno,exp_rect";
     var Result = await UT.save2Db(_url, cashDepositList);
     print("Deposit RES-->$Result");
     if(Result=="ok"){
       DialogBuilder(context).hideOpenDialog();
       Fluttertoast.showToast(msg: 'Deposit  saved successfully');
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DsrReceiptCashDeposit(title: widget.title,)));
     }else{
       DialogBuilder(context).hideOpenDialog();
       Fluttertoast.showToast(msg: 'Something went wrong please try again sometime!!');
     }
   }
   else if(widget.title=="Expense"){
     print("ADD Title-->${widget.title}");
     var recepitData=  Map();
     recepitData["srno"]=UT.m["dSrNo"];
     recepitData["exp_rect"]="Expense";
     recepitData["exp_srno"]=exp_srno.toString().padLeft(3,"0");
     recepitData["exp_date"]=UT.m['saledate'];
     recepitData["exp_acno"]=UT.m["Selected_ACCNO"];
     recepitData["narr"]= narrationController.text;
     recepitData["exp_amt"]=amountController.text;
     recepitData["cashier_cd"]=UT.ClientAcno;
     recepitData["pump_no"]=UT.m["PUMP_NO"];
     recepitData["isdeleted"]="N";
     List cashDepositList=[];
     cashDepositList.add(recepitData);
     var _url = UT.APIURL! +
         "api/PostData/Post?tblname=otre" +
         UT.curyear! +
         UT.shop_no!;
     _url += "&Unique=srno,exp_srno,exp_rect";
     var Result = await UT.save2Db(_url, cashDepositList);
     if(Result=="ok"){
       DialogBuilder(context).hideOpenDialog();
       Fluttertoast.showToast(msg: 'Deposit  saved successfully');
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DsrReceiptCashDeposit(title: widget.title,)));
     }else{
       DialogBuilder(context).hideOpenDialog();
       Fluttertoast.showToast(msg: 'Something went wrong please try again sometime!!');
     }
   }
  }

  saveEditedData() async {

    if(widget.title=="Receipt" && widget.mode=="Edit"){
      print(" edit Title-->${widget.title}");
      var recepitData=  Map();
      recepitData["srno"]=srno;
      recepitData["exp_rect"]="Receipt";
      recepitData["exp_srno"]=exp_srno.toString().padLeft(3,"0");
      recepitData["exp_date"]=UT.m['saledate'];
      recepitData["exp_acno"]=UT.m["Selected_ACCNO"];
      recepitData["narr"]= narrationController.text;
      recepitData["exp_amt"]=amountController.text;
      recepitData["cashier_cd"]=UT.ClientAcno;
      recepitData["pump_no"]=UT.m["PUMP_NO"];
      recepitData["isdeleted"]="N";
      List receiptList=[];
      receiptList.add(recepitData);
      var _url = UT.APIURL! +
          "api/PostData/Post?tblname=otre" +
          UT.curyear! +
          UT.shop_no!;
      _url += "&Unique=srno,exp_srno,exp_rect";
      var Result = await UT.save2Db(_url, receiptList);
      if(Result=="ok"){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Receipt  saved successfully');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DsrReceiptCashDeposit(title: widget.title,)));
      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Something went wrong please try again sometime!!');
      }
    }
    else if(widget.title=="Deposit"&& widget.mode=="Edit"){
      print(" edit Title-->${widget.title}");
      var recepitData=  Map();
      recepitData["srno"]=srno;
      recepitData["exp_rect"]="Deposit";
      recepitData["exp_srno"]=exp_srno.toString().padLeft(3,"0");
      recepitData["exp_date"]=UT.m['saledate'];
      recepitData["exp_acno"]=UT.m["Selected_ACCNO"];
      recepitData["narr"]= narrationController.text;
      recepitData["exp_amt"]=amountController.text;
      recepitData["cashier_cd"]=UT.ClientAcno;
      recepitData["pump_no"]=UT.m["PUMP_NO"];
      recepitData["isdeleted"]="N";
      List cashDepositList=[];
      cashDepositList.add(recepitData);
      var _url = UT.APIURL! +
          "api/PostData/Post?tblname=otre" +
          UT.curyear! +
          UT.shop_no!;
      _url += "&Unique=srno,exp_srno,exp_rect";
      var Result = await UT.save2Db(_url, cashDepositList);
      print("CD RES-->$Result");
      if(Result=="ok"){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Deposit  saved successfully');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DsrReceiptCashDeposit(title: widget.title,)));
      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Something went wrong please try again sometime!!');
      }
    }
    else if(widget.title=="Expense"&& widget.mode=="Edit"){
      print(" edit Title-->${widget.title}");
      var recepitData=  Map();
      recepitData["srno"]=srno;
      recepitData["exp_rect"]="Expense";
      recepitData["exp_srno"]=exp_srno.toString().padLeft(3,"0");
      recepitData["exp_date"]=UT.m['saledate'];
      recepitData["exp_acno"]=UT.m["Selected_ACCNO"];
      recepitData["narr"]= narrationController.text;
      recepitData["exp_amt"]=amountController.text;
      recepitData["cashier_cd"]=UT.ClientAcno;
      recepitData["pump_no"]=UT.m["PUMP_NO"];
      recepitData["isdeleted"]="N";
      List cashDepositList=[];
      cashDepositList.add(recepitData);
      var _url = UT.APIURL! +
          "api/PostData/Post?tblname=otre" +
          UT.curyear! +
          UT.shop_no!;
      _url += "&Unique=srno,exp_srno,exp_rect";
      var Result = await UT.save2Db(_url, cashDepositList);
      if(Result=="ok"){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Deposit  saved successfully');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DsrReceiptCashDeposit(title: widget.title,)));
      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: 'Something went wrong please try again sometime!!');
      }
    }
  }





  getAccountNameList() async {
    if(widget.title=="Receipt"){

      var _url = UT.APIURL! +
          "api/AccountMaster/GetAcMast?curyear="+UT.curyear!+
          "&shop=" +
          UT.shop_no! +
          "&Where=len%28acno%29 >3%20and%20acno!=%27" + UT.AC("cashprefix") +
          "%27%20and%20left%28acno,3%29!=%27" + UT.AC("bankprefix") +
          "%27%20and%20left%28acno,3%29!=%27" + UT.AC("BankccAc") + "%27";
      cardList = await UT.apiDt(_url);


    }else if(widget.title=="Deposit"||widget.mode=="Edit"){

        var _url = UT.APIURL! +
            "api/AccountMaster/GetAcMast?curyear="+UT.curyear!+
            "&shop=" + UT.shop_no! +
            "&Where=(left(acno,3)='" + UT.AC("bankprefix") + "'and len(acno)>3) or left(acno,3)='" + UT.AC("cashprefix") + "'or (left(acno,3)='" + UT.AC("bankccac") + "' and len(acno)>3)";

        print("ACNAME URL-->$_url");
        cardList = await UT.apiDt(_url);


    }else{
      //%28 means (,%29 means ),%20 for space,%27 for single quote '

      var _url = UT.APIURL! +
          "api/AccountMaster/GetAcMast?curyear="+UT.curyear!+
          "&shop=" +
          UT.shop_no! +
          "&Where=left%28acno,3%29!=%27" + UT.AC("cashprefix")
          + "%27%20and%20%28left%28acno,3%29!=%27" + UT.AC("bankprefix")
          + "%27%20and%20len%28acno%29!=3%29%20or%20%28left%28acno,3%29!=%27" +
          UT.AC("BankccAc") + "%27%20and%20len%28acno%29!=3%29";
      cardList = await UT.apiDt(_url);


    }

  }
}

