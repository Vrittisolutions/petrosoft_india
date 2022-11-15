import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/custome_downloader.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/report_list.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
        title: const Text("Opening Purchase Sales Stock"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child:Container(
          height: 115,
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
                                  style: StyleForApp.text_style_normal_14_black),
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
                    Text("To Date ",style: TextStyle(fontWeight: FontWeight.bold,color: UT.ownerAppColor,fontSize: 16),),
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
