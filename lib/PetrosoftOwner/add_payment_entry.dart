
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/payment_entry.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_name.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPaymentEntry extends StatefulWidget {
  final String voucherNo;
    AddPaymentEntry({Key? key, required this.voucherNo}) : super(key: key);
   @override
  _AddPaymentEntryState createState() => _AddPaymentEntryState();
}

class _AddPaymentEntryState extends State<AddPaymentEntry> {
  final amountController=TextEditingController(text: "0");
  final balanceController=TextEditingController(text: "0.00");
  final discountController=TextEditingController(text: "0.00");
  final voucherNoController=TextEditingController();
  final narrationController=TextEditingController();
  final checkNoController=TextEditingController();
  final bankNameController=TextEditingController();
  final chequeController=TextEditingController();
  final GlobalKey<FormState> _formKey =  GlobalKey();
  final GlobalKey<FormFieldState> amountFormFieldKey = GlobalKey<FormFieldState>();
  String? maxNo,_currentSelectedValue="Supplier",_selectedPaymentMode="cheque";
  dynamic supplierList;
  dynamic otherList;
  dynamic _ledgerAccountName;
  dynamic bankName;
  dynamic bankList;
  bool showCheckNoUI=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    voucherNoController.text=widget.voucherNo;
    getSupplierList();
    getBankList();
  }

  @override
  void dispose() {
    amountController.dispose();
    discountController.dispose();
    balanceController.dispose();
    voucherNoController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Payment Entry',), backgroundColor: ColorsForApp.app_theme_color_owner),
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
            controller: voucherNoController,
            keyboardType: TextInputType.text,
            autofocus: false,
            readOnly: true,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              labelText: "VoucherNo", labelStyle: StyleForApp.text_style_normal_14_black
              //contentPadding: EdgeInsets.all(15.0),
            ),
          ),
        ));
  }
  Widget ledgerAccountName(){
    if(_currentSelectedValue=="Customer"){
      return  Padding(
          padding: const EdgeInsets.all(8.0),
          child:InkWell(
            onTap: ()async{
              var result = await showSearch<String>(
                context: context,
                delegate: CustomDelegate(commonList:UT.customerList,ListType: "CustomerList"),
              );
              setState(() => _ledgerAccountName = result);
               DialogBuilder(context).showLoadingIndicator('');
              getBalance(UT.m["Selected_ACCNO"]);
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
                  child: Text(_ledgerAccountName!=null&&_ledgerAccountName!=''?_ledgerAccountName:"Select Ledger Account", style: StyleForApp.text_style_normal_14_black,),
                )
            ),
          ));
    }else if(_currentSelectedValue=="Supplier"){
      return  Padding(
          padding: const EdgeInsets.all(8.0),
          child:InkWell(
            onTap: ()async{
              var result = await showSearch<String>(
                context: context,
                delegate: CustomDelegate(commonList:supplierList,ListType: "CustomerList"),
              );
              setState(() => _ledgerAccountName = result);
               DialogBuilder(context).showLoadingIndicator('');
              getBalance(UT.m["Selected_ACCNO"]);
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
                  child: Text(_ledgerAccountName!=null&&_ledgerAccountName!=''?_ledgerAccountName:"Select Ledger Account", style: StyleForApp.text_style_normal_14_black),
                )
            ),
          ));
    }else if(_currentSelectedValue=="Other"){
      return  Padding(
          padding: const EdgeInsets.all(8.0),
          child:InkWell(
            onTap: ()async{
              var result = await showSearch<String>(
                context: context,
                delegate: CustomDelegate(commonList:otherList,ListType: "CustomerList"),
              );
              setState(() => _ledgerAccountName = result);
               DialogBuilder(context).showLoadingIndicator('');
              getBalance(UT.m["Selected_ACCNO"]);
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
                  child: Text(_ledgerAccountName!=null&&_ledgerAccountName!=''?_ledgerAccountName:"Select Ledger Account", style: StyleForApp.text_style_normal_14_black,),
                )
            ),
          ));
    }return Container();

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                srNoUI(),
                Padding(
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
                          child: Text(UT.dateMonthYearFormat(UT.m['saledate'].toString())),
                        )
                    ))

              ],
            ),

            dropDown(),
            ledgerAccountName(),
            balanceUI(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                amount(),
                discountUI(),
              ],
            ),
            bankNameUI(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                chequeDropDown(),
                chequeUI(),
              ],
            ),
           narration()
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
              'Supplier',
              'Customer',
              'Other',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text("   "+value,style: const TextStyle(color: Colors.black),),
              );
            }).toList(),
            hint: Text(
              "   Select Account type",
             style: StyleForApp.text_style_normal_14_black,
            ),
            onChanged: (value) {
              setState(() {
                _currentSelectedValue = value!;
                if(_currentSelectedValue=="Customer"){
                   DialogBuilder(context).showLoadingIndicator('');
                  getCustomerList();
                }else if(_currentSelectedValue=="Supplier"){
                   DialogBuilder(context).showLoadingIndicator('');
                  getSupplierList();
                }else if(_currentSelectedValue=="Other"){
                   DialogBuilder(context).showLoadingIndicator('');
                  getOtherList();
                }
              });
            },
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
  Widget chequeDropDown(){
    return Padding(padding: const EdgeInsets.all(8.0),
        child:Container(
          height: 45,width: 130,
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
            value: _selectedPaymentMode,
            //elevation: 5,
            style: const TextStyle(color: Colors.white),
            iconEnabledColor:UT.PetrosoftCustomerDarkColor,
            items: <String>[
              'cheque',
              'DD',
              'CBS',
              'RTGS',
              'NEFT',
              'ECS',
              'Transfer',
              'cash'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text("   "+value,style: const TextStyle(color: Colors.black),),
              );
            }).toList(),
            hint: Text(
              "   Select mode",
              style: StyleForApp.text_style_normal_14_black
            ),
            onChanged: (value) {
              setState(() {
                _selectedPaymentMode = value!;
              });
            },
          ),
        ));
  }
  Widget bankNameUI(){
    return  Padding(
        padding: const EdgeInsets.all(8.0),
        child:InkWell(
          onTap: ()async{
            var result = await showSearch<String>(
              context: context,
              delegate: CustomDelegate(commonList:bankList,ListType: "BankList"),
            );
            setState(() => bankName = result);
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
                child: Text(bankName!=null&&bankName!=''?bankName:"Select Bank", style: StyleForApp.text_style_normal_14_black,),
              )
          ),
        ));
  }
  getBankList() async {
    //  getBankList(string shop2getBank)
    var _url = UT.APIURL! +
        "api/AccountMaster/getBankList?yr=${UT.curyear}&shop2getBank=" +
        UT.shop_no!;
    var data = await UT.apiDt(_url);
    bankList=data;
    return bankList;
  }
  getSupplierList() async {
    //GetSupp(string year, string shop,
    var _url = UT.APIURL! +
        "api/AccountMaster/GetSupp?year=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no!;
    var data = await UT.apiDt(_url);
    supplierList=data;
   // DialogBuilder(context).hideOpenDialog();
    return supplierList;
  }
  getOtherList() async {
    // //%28 means (,%29 means ),%20 for space,%27 for single quote ',
    //GetAcMast?curyear=&shop=&Where=len(acno)<>3 and left(acno,3)<>'003' and left(acno,3)<>'004'
    var _url = UT.APIURL! +
        "api/AccountMaster/GetAcMast?curyear=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no!+"&Where=len%28acno%29<>3%20and%20left%28acno,3%29<>%27"+UT.AC("custprefix")+"%27%20and%20left%28acno,3%29<>%27"+UT.AC("suppprefix")+"%27";
    var data = await UT.apiDt(_url);
    otherList=data;
    DialogBuilder(context).hideOpenDialog();
    return otherList;
  }
  getCustomerList() async {
    //GetSupp(string year, string shop,
    var _url = UT.APIURL! +
        "api/AccountMaster/GetCust?Yr=" +
        UT.curyear! +
        "&Shop=" +
        UT.shop_no!;
    var data = await UT.apiDt(_url);
    UT.customerList=data;
    DialogBuilder(context).hideOpenDialog();
    return UT.customerList;
  }
  getBalance(String acno) async {
    //"/api/AccountMaster/GetAcBal?curyear=" + Setup('curyear') + "&shop=" + Firm("Shop") + "&acno=" + acno
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
          height: 45,width: 160,
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
              labelText: "cheque", labelStyle: StyleForApp.text_style_normal_14_black
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


 Widget saveButton(){
    return CommonButtonForAllApp(onPressed: () async {
     if(_ledgerAccountName==null||_ledgerAccountName==''){
        Fluttertoast.showToast(msg: "Select customer name");
      }else{
        if (_formKey.currentState!.validate()) {
            DialogBuilder(context).showLoadingIndicator('');
            print("ADD-->${UT.m["Selected_ACCNO"]}");
          saveData();
        }
    }
      }, title: 'Save',backgroundColor: ColorsForApp.app_theme_color_owner);
 }
 saveData() async {
    var paymentData=  Map();
    checkNewSrNo().then((value) async {
      if(value!=null){
        paymentData["srno"]="${voucherNoController.text}";
        paymentData["date"]=UT.m['saledate'];
        paymentData["byname"]=_ledgerAccountName;
        paymentData["acno"]=UT.m["Selected_ACCNO"];
        paymentData["bytoacno"]=UT.m["Selected_bankno"];
        paymentData["amount"]=amountController.text;
        paymentData["balance"]=balanceController.text;
        paymentData["disc_amt"]=discountController.text;
        paymentData["narr1"]=narrationController.text;
        paymentData["mode"]=_selectedPaymentMode;
        paymentData["chqno"]=checkNoController.text;
        paymentData["isdeleted"]="N";

        List paymentList=[];
        paymentList.add(paymentData);
        print(paymentList);
        var _url1 = UT.APIURL! +
            "api/PostData/Post?tblname=vou" +
            UT.curyear! +
            UT.shop_no!;
        _url1 += "&Unique=srno";
        var Result1 = await UT.save2Db(_url1, paymentList);
        if(Result1=="ok"){
          DialogBuilder(context).hideOpenDialog();
          Fluttertoast.showToast(msg: 'saved successfully');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaymentEntryPage()));
        }else{
          DialogBuilder(context).hideOpenDialog();
          Fluttertoast.showToast(msg: 'Something went wrong');
        }
      }
    });

  }
  Future checkNewSrNo()async{
  // "/api/ChkNewSrno?Table=" + OpenTable("VOU" + Firm("shop")) + "&Col=srno&length=5&AddByOne=true"
    var _url = UT.APIURL! +
        "api/ChkNewSrno?Table=VOU" +
        UT.shop_no.toString()+
        "&Col=srno&length=5&AddByOne=true";
    var data = await UT.apiStr(_url);
    return data;
  }


}

