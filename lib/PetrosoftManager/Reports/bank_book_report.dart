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
                    builder: (context) => const ManagerReportList()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title:  Text("Bank Book",style: PetroSoftTextStyle.style17White),
      ),
     // appBar: AppBar(title: const Text('Bank Book',), backgroundColor: ColorsForApp.app_theme_color_owner),
      body:
      Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  color: ColorConverter.hexToColor("#D9D9D9").withOpacity(0.3),
                  width: 150,
                  height: 150,
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Text('Select Bank',style: PetroSoftTextStyle.style15Black),
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
                    height: 150,
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        bankNameUI(),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GestureDetector(
                            onTap: (){
                              selectFromdate(context);
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
    return  InkWell(
      onTap: ()async{
        var result = await showSearch<String>(
          context: context,
          delegate: CustomDelegate(commonList:bankList,ListType: ""),
        );
        setState(() => bankName = result);
      },
      child: Container(
          //height: 45,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(//DecorationImage
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black12),
            ),//Border.all
           ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(bankName!=null&&bankName!=''?bankName:"Select Bank"),
              ),
              Icon(Icons.arrow_drop_down)
            ],
          )
      ),
    );
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
