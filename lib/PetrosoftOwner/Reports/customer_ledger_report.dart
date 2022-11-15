import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/custome_downloader.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/report_list.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CustomerLedgerReport extends StatefulWidget {
  final String accNo,title;
  var color;
   CustomerLedgerReport({Key? key, required this.accNo,required this.title,required this.color}) : super(key: key);
  @override
  _CustomerLedgerReportState createState() => _CustomerLedgerReportState();
}

class _CustomerLedgerReportState extends State<CustomerLedgerReport> {
  DateTime? selectedFromDate = DateTime.now();
  DateTime? selectedToDate = DateTime.now();

  String? formattedFromDate;
  String? formattedToDate;
  @override
  void initState() {
    super.initState();
    //UT.yearStartDate

    formattedFromDate = UT.displayDateConverter(selectedFromDate);
    //formattedFromDate = UT.dateMonthYearFormat(UT.yearStartDate!);

    formattedToDate = UT.displayDateConverter(selectedToDate);
    //ormattedToDate = UT.dateMonthYearFormat(UT.yearEndDate!);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        backgroundColor: widget.color,
        iconTheme: const IconThemeData(color: Colors.white),
        title:   CommonAppBarText(title: widget.title,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
                    Text("From Date ",style: TextStyle(fontWeight: FontWeight.bold,color: UT.ownerAppColor,fontSize: 16),),
                    Container(
                      height: 40,width: 100,
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
                                  style: const TextStyle(color: Color(0xFF000000))
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
                    Text("To Date ",style: TextStyle(fontWeight: FontWeight.bold,color: UT.ownerAppColor,fontSize: 16),),
                    Container(
                      height: 40,width: 100,
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
                                  style: const TextStyle(color: Color(0xFF000000))
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
        // "/api/Custldpr?shop=" + Firm("shop") + "&FromDt1=" + yymmdd($("#date1").val()) + "&Todt1=" + yymmdd($("#date2").val()) + "&FromDt2=" + yymmdd($("#date1").val()) + "&Todt2=" + yymmdd($("#date2").val()) + "&acc_no=" + selectedAcno + "&getPrint=true"
         var _url = UT.APIURL! +
            "api/Custldpr?_year="+UT.curyear!+"&shop=" +
            UT.shop_no.toString()+
            "&FromDt1="+"${UT.dateConverter(selectedFromDate!)}"+"&Todt1="+"${UT.dateConverter(selectedToDate!)}"+"&FromDt2="+"${UT.dateConverter(selectedFromDate)}"+"&Todt2="+"${UT.dateConverter(selectedToDate)}"+"&acc_no="+widget.accNo+"&getPrint=true";

         Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context) =>
                     DownloadFile(url:_url, child: Container(),)));
      }, title: "Download", backgroundColor: widget.color),

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
