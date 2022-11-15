import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_name.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/custome_downloader.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/report_list.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class GeneralLedgerReport extends StatefulWidget {
  const GeneralLedgerReport({Key? key}) : super(key: key);

  @override
  _GeneralLedgerReportState createState() => _GeneralLedgerReportState();
}

class _GeneralLedgerReportState extends State<GeneralLedgerReport> {
  DateTime? selectedFromDate = DateTime.now();
  DateTime? selectedToDate = DateTime.now();
  String? formattedFromDate;
  String? formattedToDate;
  dynamic accountList;
  dynamic accountName;
  @override
  void initState() {
    super.initState();
    formattedFromDate = UT.displayDateConverter(selectedFromDate);
    formattedToDate = UT.displayDateConverter(selectedToDate);
    getAccountList();
  }
  getAccountList() async {
    //   //%28 means (,%29 means ),%20 for space,%27 for single quote '
    //"/api/AccountMaster/GetAcMast?curyear=" + Setup('curyear') + "&shop=" + Firm("Shop") + "&Where=len(acno) >3 and acno!='" + AC("cashprefix") + "' and left(acno,3)!='" + AC("bankprefix") + "' and left(acno,3)!='" + AC("BankccAc") + "'"
    var _url = UT.APIURL! +
        "api/AccountMaster/GetAcMast?curyear=" +
        UT.curyear!+
        "&shop="+
        UT.shop_no!+"&Where=len%28acno%29 >3%20and%20acno!=%27" + UT.AC("cashprefix") + "%27%20and%20left%28acno,3%29!=%27" + UT.AC("bankprefix") + "%27%20and%20left%28acno,3%29!=%27" + UT.AC("BankccAc") + "%27";
    var data = await UT.apiDt(_url);
    accountList=data;
    return accountList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        backgroundColor:ColorsForApp.app_theme_color_owner,
        titleSpacing: 0.0,

        title: const Text("General Ledger"),
      ),
      //appBar: AppBar(title: const Text('General Ledger',), backgroundColor: ColorsForApp.app_theme_color_owner),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child:Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 1.0,
                spreadRadius: 1.0, //extend the shadow
                offset: const Offset(
                  3.0, // Move to right 10  horizontally
                  3.0, // Move to bottom 5 Vertically
                ),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            children: [
              bankNameUI(),
              Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 10.0,bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("From Date ",style: StyleForApp.text_style_bold_14_black),
                    Container(
                      height: 40,width: 150,
                      decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1.0, color: Colors.black12),
                            left: BorderSide(width: 1.0, color: Colors.black12),
                            right: BorderSide(width: 1.0, color: Colors.black12),
                            bottom: BorderSide(width: 1.0, color: Colors.black12),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Text(
                                  formattedFromDate!,
                                  textAlign: TextAlign.center,
                                  style: StyleForApp.text_style_normal_14_black
                              ),
                              onTap: (){
                                selectFromDate(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 10.0,bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("To Date ", style: StyleForApp.text_style_bold_14_black,),
                    Container(
                      height: 40,width: 150,
                      decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 1.0, color: Colors.black12),
                            left: BorderSide(width: 1.0, color: Colors.black12),
                            right: BorderSide(width: 1.0, color: Colors.black12),
                            bottom: BorderSide(width: 1.0, color: Colors.black12),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Text(
                                  formattedToDate!,
                                  textAlign: TextAlign.center,
                                  style: StyleForApp.text_style_normal_14_black
                              ),
                              onTap: (){
                                 selectToDate(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonButtonForAllApp(onPressed: (){
      //"/api/GeneralLdpr?shop=" + Firm("shop") + "&date1=" + yymmdd($("#date1").val()) + "&date2=" + yymmdd($("#date2").val()) + "&acno=" + $("#accname").val() + "&getPrint=true"
        var _url = UT.APIURL! +
            "api/GeneralLdpr?cyr="+UT.curyear!+"&shop=" +
            UT.shop_no.toString()+
            "&date1="+"${UT.dateConverter(selectedFromDate)}"+"&date2="+"${UT.dateConverter(selectedToDate)}"+"&acno="+UT.m["Selected_ACCNO"]+"&getPrint=true";




        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DownloadFile(url:_url, child: Container(),)));
      }, title: "Download", backgroundColor: ColorsForApp.app_theme_color_owner),

    );
  }
  Widget bankNameUI(){
    return  Padding(
          padding: const EdgeInsets.all(8.0),
          child:InkWell(
            onTap: ()async{
              var result = await showSearch<String>(
                context: context,
                delegate: CustomDelegate(commonList:accountList,ListType: "accountList"),
              );
              setState(() => accountName = result);
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
                  child: Text(accountName!=null&&accountName!=''?accountName:"Select Account"),
                )
            ),
          ));
  }
  Future<void> selectFromDate(BuildContext context) async {
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
  Future<void> selectToDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedToDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)))!;
    if (picked != selectedToDate) {
      setState(() {
        selectedToDate = picked;
        formattedToDate = UT.displayDateConverter(selectedToDate);

      });
    }
  }
}
