import 'package:petrosoft_india/AdatsoftOwner/search_area.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_name.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/custome_downloader.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/save_card_sale.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


class OutstandingList extends StatefulWidget {
  const OutstandingList({Key? key}) : super(key: key);

  @override
  _OutstandingListState createState() => _OutstandingListState();
}

class _OutstandingListState extends State<OutstandingList> {
  TextEditingController balanceController=TextEditingController(text: "0.00");
  dynamic categoryName = "Supplier";
  var selectedProduct = "No";
  bool downloading = false;
  DateTime? currentDate = DateTime.now();
  DateTime? selectedToDate = DateTime.now();
  String? formattedDebitDate;
  String? formattedCreditDate;
  String? drDate,crDate;
   String? a;
  dynamic areaList;
  String areaName='';
  @override
  void initState() {
    super.initState();
    getAreaList();
    formattedDebitDate = UT.displayDateConverter(currentDate);
    formattedCreditDate = UT.displayDateConverter(selectedToDate);
  }
  List<DropdownMenuItem<String>> category = [
    const DropdownMenuItem(
      child: Text("Supplier"),
      value: "Supplier",
    ),
    const  DropdownMenuItem(
      child: Text("Customer"),
      value: "Customer",
    ),
    const DropdownMenuItem(
      child: Text("Agent"),
      value: "Agent",
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
        backgroundColor: ColorsForApp.appThemeColorAdatOwner,
        titleSpacing: 0.0,iconTheme: const IconThemeData(color: Colors.white),
        title: const CommonAppBarText(title: 'Outstanding List'),
      ),
      //appBar: AppBar(title: const Text('Shift Sale Report',), backgroundColor: ColorsForApp.app_theme_color_owner),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child:Container(
         // height: 175,
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
          child: SingleChildScrollView(
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 10.0,bottom: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Select Category  ",style: StyleForApp.text_style_bold_14_black),
                      Container(
                          height: 40,width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.black12)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: DropdownButton(
                              isExpanded: true,
                              items: category,
                              underline: Container(),
                              hint: const Text("Select Category"),
                              value: categoryName,
                              onChanged: (val) async {
                                categoryName = val.toString();
                                setState(() {});
                              },
                            ),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 10.0,bottom: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Select Area : ",style: StyleForApp.text_style_bold_14_black),
                      areaNameUI(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 10.0,bottom: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Debit Date : ",style: StyleForApp.text_style_bold_14_black),
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
                                    formattedDebitDate!,
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
                      Text("Credit Date : ",style: StyleForApp.text_style_bold_14_black),
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
                                    formattedCreditDate!,
                                    textAlign: TextAlign.center,
                                    style: StyleForApp.text_style_normal_14_black),

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
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 10.0,bottom: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Balance Above  ",style: StyleForApp.text_style_bold_14_black),
                      Container(
                          height: 45,width: 150,
                         /* decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.black12)
                          ),*/
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextField(
                              controller: balanceController,
                              decoration: InputDecoration(
                                  labelText: 'Balance',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide( color: Colors.black12),
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                            ),
                          )),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CommonButtonForAllApp(
          onPressed: () {
       //GetStr(APIURL + "/api/Closblp2?yr=" + Setup("curyear") + "&sh=" +
            // Firm("shop") + "&drdt=" + yymmdd($("#date1").val()) +
            // "&crdt=" + yymmdd($("#date2").val()) + "&cat=" + $("#category").val() +
            // "&sorton=" + $("#sortby").val() + "&area=" + $("#areaname").val() +
            // "&bal=" + $("#balance").val() + "&getPrint=false");

           // if (areaName == null || areaName == "") {
             // Fluttertoast.showToast(msg: "Please select area");
            //} else {
              var _url = UT.APIURL! +
                  "api/Closblp2?yr=" +
                  UT.curyear.toString() + "&sh=" + UT.shop_no! +
                  "&drdt=" + "${UT.dateConverter(currentDate)}" + "&crdt=" +
                  "${UT.dateConverter(selectedToDate!)}" + "&cat=" +
                  "$categoryName" + "&sorton=Area"  +
                  "&area=" + areaName.toString() + "&bal=" + balanceController.text +
                  "&getPrint=false";
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DownloadFile(url: _url, child: Container(),)));
              // DownloadFile(url:_url, child: Container(),);
           // }
          }, title: "View Report", backgroundColor: ColorsForApp.appThemeColorAdatOwner),

    );
  }
  getAreaList() async {
    //  var urlstr = APIURL + "/api/AccountMaster/GetCustByName?cYr=" + Setup('curyear') + "&Shop=" + Firm("Shop") + "&like=" + request.term + "&Addrow=false&Col=name,acno,city";
    var _url = UT.APIURL! + "api/AccountMaster/GetCustByName?cYr=" +
        UT.curyear!+"&shop="+UT.shop_no!+"&like=" + " " + "&Addrow=false&Col=name,acno,city";
    var data = await UT.apiDt(_url);
    print("data-->$data");
    areaList=data;
    return areaList;
  }
  Widget areaNameUI(){
    return  InkWell(
      onTap: ()async{
        var result = await showSearch<String>(
          context: context,
          delegate: AreaCustomDelegate(commonList:areaList),
        );
        setState(() => areaName = result!);
      },
      child: Container(
         height: 40,
          width:150,
          decoration: BoxDecoration(//DecorationImage
            border: Border.all(
              color: Colors.black12,
              // width: 8,
            ), //Border.all
            borderRadius: BorderRadius.circular(8.0),),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(areaName!=null&&areaName!=''?areaName:"Select Area"),
          )
      ),
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
        formattedDebitDate = UT.displayDateConverter(currentDate);


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
        formattedCreditDate = UT.displayDateConverter(selectedToDate);
      });
    }
  }
}
