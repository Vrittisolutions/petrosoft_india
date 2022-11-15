import 'dart:io';
import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/report_list.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'custome_downloader.dart';


class OwnerShiftSaleReport extends StatefulWidget {
  const OwnerShiftSaleReport({Key? key}) : super(key: key);

  @override
  _OwnerShiftSaleReportState createState() => _OwnerShiftSaleReportState();
}

class _OwnerShiftSaleReportState extends State<OwnerShiftSaleReport> {
  DateTime? currentDate = DateTime.now();
  String? formattedCurrentDate;
  dynamic resPdf;
  dynamic progress = "";
  dynamic path = "No Data";
  dynamic savedPath;
  dynamic platformVersion = "Unknown";
  dynamic _saleShift = "I";
  var selectedProduct = "No";
  bool downloading = false;
  late Directory externalDir;

  @override
  void initState() {
    super.initState();
    formattedCurrentDate = UT.displayDateConverter(currentDate);
  }
  List<DropdownMenuItem<String>> items = [
    const DropdownMenuItem(
      child: Text("I"),
      value: "I",
    ),
    const  DropdownMenuItem(
      child: Text("II"),
      value: "II",
    ),
    const DropdownMenuItem(
      child: Text("III"),
      value: "III",
    ),
    const DropdownMenuItem(
      child: Text("IV"),
      value: "IV",
    ),
    const DropdownMenuItem(
      child: Text("V"),
      value: "V",
    ),
  ];
  List<DropdownMenuItem<String>> product = [
    const DropdownMenuItem(
      child: Text("Yes"),
      value: "Yes",
    ),
    const DropdownMenuItem(
      child: Text("No"),
      value: "No",
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: UT.BACKGROUND_COLOR,
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
        title:  Text("Shift Sale Report",style: PetroSoftTextStyle.style17White,),
      ),
      //appBar: AppBar(title: const Text('Shift Sale Report',), backgroundColor: ColorsForApp.app_theme_color_owner),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Container(
                  color: ColorConverter.hexToColor("#D9D9D9").withOpacity(0.3),
                  height: 165,
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children:  [
                        const SizedBox(height: 20,),
                        Text("Date  ",style: PetroSoftTextStyle.style15Black,),
                        const  SizedBox(height: 30,),
                        Text("Shift  ",style: PetroSoftTextStyle.style15Black,),
                        const  SizedBox(height: 30,),
                        Text("All Product  ",style: PetroSoftTextStyle.style15Black,),
                        //Divider(color: ColorsForApp.light_gray_color,),

                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0),
                child: Container(
                  //color: ColorConverter.hexToColor("#D9D9D9").withOpacity(0.3),
                  height: 165,
                  width: 180,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all( 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                child: Text(
                                    formattedCurrentDate!,
                                    textAlign: TextAlign.center,
                                    style: StyleForApp.text_style_normal_14_black),
                                onTap: (){
                                  selectFromdate(context);
                                },
                              ),
                              const SizedBox(width: 10,),
                              Image.asset(PetroSoftAssetFiles.calender,color:ColorsForApp.light_gray_color,height: 20,width: 20,),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 10,),
                        Divider(color: ColorsForApp.light_gray_color,),
                        //  const SizedBox(height: 10,),
                        Container(
                            height: 40,
                            //width: 150,
                            padding: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              border: Border(
                                // top: BorderSide(width: 1.0, color: Colors.black12),
                                // left: BorderSide(width: 1.0, color: Colors.black12),
                                // right: BorderSide(width: 1.0, color: Colors.black12),
                                bottom: BorderSide(width: 1.0, color: Colors.black12),
                              ),

                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton(
                                isExpanded: true,
                                items: items,
                                underline: Container(),
                                hint: const Text("Select Shift"),
                                value: _saleShift,
                                onChanged: (val) async {
                                  _saleShift = val.toString();
                                  setState(() {});
                                },
                              ),
                            )),
                        const SizedBox(height: 5,),
                        Container(
                            height: 40,
                            //width: 150,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(8.0),
                              // border: Border.all(color: Colors.black12),
                              border: Border(
                                // top: BorderSide(width: 1.0, color: Colors.black12),
                                // left: BorderSide(width: 1.0, color: Colors.black12),
                                // right: BorderSide(width: 1.0, color: Colors.black12),
                                bottom: BorderSide(width: 1.0, color: Colors.black12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButton(
                                isExpanded: true,
                                items: product,
                                underline: Container(),
                                hint: const Text("Select Product"),
                                value: selectedProduct,
                                onChanged: (val) async {
                                  selectedProduct = val.toString();
                                  setState(() {});
                                },
                              ),
                            )),
                        //Divider(color: ColorsForApp.light_gray_color,),
                      ],
                    ),
                  ),
                ),
              ),


            ],
          ),
        ],
      ),
      bottomNavigationBar: CommonButtonForAllApp(
          onPressed: (){
        var _url = UT.APIURL! +
            "api/Dsrrep2?year="+UT.curyear!+"&shop=" +
            UT.shop_no.toString()+
            "&date="+"${UT.dateConverter(currentDate)}"+"&shift="+"$_saleShift"+"&allprodct="+selectedProduct;
        print("url-->$_url");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DownloadFile(url:_url, child: Container(),)));
       // DownloadFile(url:_url, child: Container(),);
      }, title: "Download", backgroundColor: ColorsForApp.app_theme_color_owner),

    );
  }

  Future<void> selectFromdate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: currentDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101)))!;
    if (picked != currentDate) {
      setState(() {
        currentDate = picked;
        formattedCurrentDate = UT.displayDateConverter(currentDate);
      });
    }
  }
}
