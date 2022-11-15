import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_name.dart';
import 'package:petrosoft_india/PetrosoftManager/Reports/custome_downloader.dart';
import 'package:petrosoft_india/PetrosoftManager/Reports/report_list.dart';
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

        title:  Text("General Ledger",style: PetroSoftTextStyle.style17White),
      ),
      //appBar: AppBar(title: const Text('General Ledger',), backgroundColor: ColorsForApp.app_theme_color_owner),
      body:  Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  color: ColorConverter.hexToColor("#D9D9D9").withOpacity(0.3),
                  width: 150,
                  height: 170,
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Text('Select Account',style: PetroSoftTextStyle.style15Black),
                      const SizedBox(height: 30,),
                      Text('From Date',style: PetroSoftTextStyle.style15Black),
                      const SizedBox(height: 30,),
                      Text('To Date',style: PetroSoftTextStyle.style15Black)
                    ],
                  )
              ),
              Expanded(
                child: SizedBox(
                  // width: 150,
                    height: 170,
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        bankNameUI(),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GestureDetector(
                            onTap: (){
                              selectFromDate(context);
                            },
                            child: Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(width: 1.0, color: Colors.black12),
                                  ),

                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                          formattedFromDate!,
                                          textAlign: TextAlign.center,
                                          style: StyleForApp.text_style_normal_14_black),
                                      const SizedBox(width: 10,),
                                      Image.asset(PetroSoftAssetFiles.calender,color:ColorsForApp.light_gray_color,height: 20,width: 20,),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                        const SizedBox(height: 0,),
                        GestureDetector(
                          onTap: (){
                            selectToDate(context);
                          },
                          child: Container(
                              height: 40,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 1.0, color: Colors.black12),
                                ),

                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                        formattedToDate!,
                                        textAlign: TextAlign.center,
                                        style: StyleForApp.text_style_normal_14_black),
                                    const SizedBox(width: 10,),
                                    Image.asset(PetroSoftAssetFiles.calender,color:ColorsForApp.light_gray_color,height: 20,width: 20,),
                                  ],
                                ),
                              )
                          ),
                        )
                      ],
                    )
                ),
              ),

            ],
          ),

        ],
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
    return  InkWell(
      onTap: ()async{
        var result = await showSearch<String>(
          context: context,
          delegate: CustomDelegate(commonList:accountList,ListType: "accountList"),
        );
        setState(() => accountName = result);
      },
      child: Container(

          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(//DecorationImage
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black12),
            ),//Border.all
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(accountName!=null&&accountName!=''?accountName:"Select Account"),
                ),
              ),
              Icon(Icons.arrow_drop_down)
            ],
          )
      ),
    );
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
