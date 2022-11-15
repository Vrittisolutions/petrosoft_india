import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOperator/widgets/search_name.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/custome_downloader.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/save_card_sale.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PattiRegister extends StatefulWidget {
  const PattiRegister({Key? key}) : super(key: key);

  @override
  _PattiRegisterState createState() => _PattiRegisterState();
}

class _PattiRegisterState extends State<PattiRegister> {
  TextEditingController balanceController=TextEditingController(text: "0.00");
  dynamic categoryName = "Supplier";
  var selectedSummary = "Yes";
  bool downloading = false;
  DateTime? currentDate = DateTime.now();
  DateTime? selectedToDate = DateTime.now();
  String? formattedFromDate;
  String? formattedToDate;
  String? drDate,crDate;
  String? a;
  dynamic farmerList;
  String farmerName='';
  @override
  void initState() {
    super.initState();
    getAreaList();
    formattedFromDate = UT.displayDateConverter(currentDate);
    formattedToDate = UT.displayDateConverter(selectedToDate);
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
  List<DropdownMenuItem<String>> summaryList = [
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
        title: const CommonAppBarText(title: 'Patti Register'),
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
                      Text("Farmer : ",style: StyleForApp.text_style_bold_14_black),
                      farmerNameUI(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 10.0,bottom: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("From Date : ",style: StyleForApp.text_style_bold_14_black),
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
                      Text("To Date : ",style: StyleForApp.text_style_bold_14_black),
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
                      Text("Summary  ",style: StyleForApp.text_style_bold_14_black),
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
                              items: summaryList,
                              underline: Container(),
                              hint: const Text("Summary"),
                              value: selectedSummary,
                              onChanged: (val) async {
                                selectedSummary = val.toString();
                                setState(() {});
                              },
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 5,)


              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CommonButtonForAllApp(
          onPressed: (){
           print("supp code-->${UT.m["Selected_ACCNO"]}");
           if(UT.m["Selected_ACCNO"]==null){
             UT.m["Selected_ACCNO"]='';
             print("supp code-->${UT.m["Selected_ACCNO"]}");
           }
            var _url = UT.APIURL! +
                "api/PattiNondRpt?shop=" +
                UT.shop_no.toString()+
                "&date1="+"${UT.dateConverter(currentDate)}"+"&date2="+"${UT.dateConverter(selectedToDate!)}"+"&summary="+"$selectedSummary"+"&supp_code="+UT.m["Selected_ACCNO"];
           print("url-->$_url");
           UT.m["Selected_ACCNO"]=null;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DownloadFile(url:_url, child: Container(),)));
            // DownloadFile(url:_url, child: Container(),);
          }, title: "View Report", backgroundColor: ColorsForApp.appThemeColorAdatOwner),

    );
  }
  getAreaList() async {
    var _url = UT.APIURL! + "api/AccountMaster/GetSuppByName?syear=" +
        UT.curyear!+"&shop="+UT.shop_no!+"&like=" + " " + "&addrow=false&cols=name,acno,city,pager,cat,addleivy,pack_chrg,comm_rate,hamal_per,tolai_per,leivy_per,hamal_on,tolai_on,leivy_on";
    var data = await UT.apiDt(_url);
    print("data-->$data");
    farmerList=data;
    return farmerList;
  }
  Widget farmerNameUI(){
    return  InkWell(
      onTap: ()async{
        var result = await showSearch<String>(
          context: context,
          delegate: CustomDelegate(commonList:farmerList, ListType: ''),
        );
        setState(() => farmerName = result!);
      },
      child: Container(
        //width: double.infinity,
         // height: 40,
          width:230,
          decoration: BoxDecoration(//DecorationImage
            border: Border.all(
              color: Colors.black12,
              // width: 8,
            ), //Border.all
            borderRadius: BorderRadius.circular(8.0),),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(farmerName!=''?farmerName:"Select Farmer",maxLines: 2,),
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
        formattedFromDate = UT.displayDateConverter(currentDate);


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
