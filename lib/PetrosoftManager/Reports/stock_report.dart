import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/Reports/custome_downloader.dart';
import 'package:petrosoft_india/PetrosoftManager/Reports/report_list.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../AppTheme/assets_files.dart';


class OpeningPurchaseSalesStock extends StatefulWidget {
  const OpeningPurchaseSalesStock({Key? key}) : super(key: key);

  @override
  _OpeningPurchaseSalesStockState createState() => _OpeningPurchaseSalesStockState();
}

class _OpeningPurchaseSalesStockState extends State<OpeningPurchaseSalesStock> {
  DateTime? selectedFromDate = DateTime.now();
  DateTime? selectedToDate = DateTime.now();
  String? formattedFromDate;
  String? formattedToDate;
  @override
  void initState() {
    super.initState();
    formattedFromDate = UT.displayDateConverter(selectedFromDate);
    formattedToDate = UT.displayDateConverter(selectedToDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        backgroundColor: ColorsForApp.app_theme_color_owner,
        titleSpacing: 0.0,
        title:  Text("Opening Purchase Sales Stock",style: PetroSoftTextStyle.style17White),
      ),
      body: Column(
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
                      const SizedBox(height: 50,),
                      Text('From Date',style: PetroSoftTextStyle.style15Black),
                      const SizedBox(height: 50,),
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
                        const SizedBox(height: 40,),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
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
                        const SizedBox(height: 15,),
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
        var _url = UT.APIURL! +
            "api/Stkrep4?year="+UT.curyear!+"&shop=" +
            UT.shop_no.toString()+
            "&date1="+"${UT.dateConverter(selectedFromDate)}"+"&date2="+"${UT.dateConverter(selectedToDate)}";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DownloadFile(url:_url, child: Container(),)));
      }, title: "Download", backgroundColor: ColorsForApp.app_theme_color_owner),

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
