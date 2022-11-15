import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_name.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/custome_downloader.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/report_list.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BankBookReport extends StatefulWidget {
  const BankBookReport({Key? key}) : super(key: key);

  @override
  _BankBookReportState createState() => _BankBookReportState();
}

class _BankBookReportState extends State<BankBookReport> {
  DateTime? selectedFromDate = DateTime.now();
  DateTime? selectedToDate = DateTime.now();
  String? formattedFromDate;
  String? formattedToDate;
  dynamic bankList;
  dynamic bankName;
  @override
  void initState() {
    super.initState();
    getBankList();
    formattedFromDate = UT.displayDateConverter(selectedFromDate);
    formattedToDate = UT.displayDateConverter(selectedToDate);
  }
  getBankList() async {
    var _url = UT.APIURL! +
        "api/AccountMaster/getBankList?yr=${UT.curyear}&shop2getBank=" +
        UT.shop_no!;
    var data = await UT.apiDt(_url);
    bankList=data;
    return bankList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        backgroundColor: ColorsForApp.app_theme_color_owner,
        titleSpacing: 0.0,
        leading: IconButton(
          highlightColor: Colors.white,
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReportListPage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Bank Book"),
      ),
     // appBar: AppBar(title: const Text('Bank Book',), backgroundColor: ColorsForApp.app_theme_color_owner),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
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
                                selectFromdate(context);
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
                    Text("To Date ",style: StyleForApp.text_style_bold_14_black),
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
      bottomNavigationBar: CommonButtonForAllApp(
          onPressed: (){

//"/api/BankBook?shop=" + Firm("shop") + "&FromDt=" + yymmdd($("#date1").val()) + "&Todt=" + yymmdd($("#date2").val()) + "&bytoacc_no=" + selectedAcno + "&getPrint=true"
        var _url = UT.APIURL! +
            "api/BankBook?_yr="+UT.curyear!+"&shop=" +
            UT.shop_no.toString()+
            "&FromDt="+"${UT.dateConverter(selectedFromDate)}"+"&Todt="+"${UT.dateConverter(selectedToDate)}"+"&bytoacc_no=${UT.m["Selected_ACCNO"]}"+"&getPrint=true";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DownloadFile(url:_url, child: Container(),)));
      }, title: "Download", backgroundColor: ColorsForApp.app_theme_color_owner,),

    );
  }
  Widget bankNameUI(){
    return  Padding(
          padding: const EdgeInsets.all(8.0),
          child:InkWell(
            onTap: ()async{
              var result = await showSearch<String>(
                context: context,
                delegate: CustomDelegate(commonList:bankList,ListType: ""),
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
                  child: Text(bankName!=null&&bankName!=''?bankName:"Select Bank"),
                )
            ),
          ));
  }
  Future<void> selectFromdate(BuildContext context) async {
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
