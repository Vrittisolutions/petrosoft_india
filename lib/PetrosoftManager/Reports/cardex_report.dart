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
import 'package:fluttertoast/fluttertoast.dart';


class CardexReport extends StatefulWidget {
  const CardexReport({Key? key}) : super(key: key);

  @override
  _CardexReportState createState() => _CardexReportState();
}

class _CardexReportState extends State<CardexReport> {
  DateTime? selectedFromDate = DateTime.now();
  DateTime? selectedToDate = DateTime.now();
  String? formattedFromDate;
  String? formattedToDate;
  dynamic itemList;
  dynamic descriptionName;
  dynamic selectedSummary="Yes";
  dynamic selectedLocation="Yes";
  @override
  void initState() {
    super.initState();
    getItemList();
    formattedFromDate = UT.displayDateConverter(selectedFromDate);
    formattedToDate = UT.displayDateConverter(selectedToDate);
  }
  dynamic cardexData;
  getData() async {
    print("hii");

    var _url = UT.APIURL! +
        "api/Cardex/Getrpt?yr=" +
        UT.curyear! +
        "&shp=" +
        UT.shop_no! +
        "&dt1=" +
        "${UT.dateConverter(selectedFromDate)}"+"&dt2="+"${UT.dateConverter(selectedToDate)}"+
        "&item_code="+descriptionName+"&item_desc="+UT.m["Selected_ItemCode"]+"&getPrint=true";
    print("$_url");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DownloadFile(url:_url, child: Container(),)));
  }
  getItemList() async {
//  var itmData = GetURLDt(APIURL + "/api/Cardex/GetData?shop=" + Firm("Shop") + "&Where=isdeleted<>'Y' order by item_code");
    var _url = UT.APIURL! +
        "api/Cardex/GetData?shop=${UT.shop_no}&Where=isdeleted<>'Y' order by item_code";
    var data = await UT.apiDt(_url);
    print(_url);
    itemList=data;
    print(itemList);
    return itemList;
  }
  List<DropdownMenuItem<String>> summaryOptions = [
    const DropdownMenuItem(
      child: Text("Yes"),
      value: "Yes",
    ),
    const DropdownMenuItem(
      child: Text("No"),
      value: "No",
    ),

  ];
  List<DropdownMenuItem<String>> locationOptions = [
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
        title: const Text("Cardex Report"),
      ),
     // appBar: AppBar(title: const Text('Bank Book',), backgroundColor: ColorsForApp.app_theme_color_owner),
      body: /*Padding(
        padding: const EdgeInsets.all(15.0),
        child:Container(
         // height: 180,
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
              descriptionUI(),
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
                            items: summaryOptions,
                            underline: Container(),
                           // hint: const Text("S"),
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
              Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 10.0,bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Location  ",style: StyleForApp.text_style_bold_14_black),
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
                            items: locationOptions,
                            underline: Container(),
                            // hint: const Text("S"),
                            value: selectedLocation,
                            onChanged: (val) async {
                              selectedLocation = val.toString();
                              setState(() {});
                            },
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),*/
      Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  color: ColorConverter.hexToColor("#D9D9D9").withOpacity(0.3),
                  width: 150,
                  height: 290,
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Text('Select Description',style: PetroSoftTextStyle.style15Black),
                      const SizedBox(height: 30,),
                      Text('From Date',style: PetroSoftTextStyle.style15Black),
                      const SizedBox(height: 40,),
                      Text('To Date',style: PetroSoftTextStyle.style15Black),
                      const SizedBox(height: 35,),
                      Text('Summary',style: PetroSoftTextStyle.style15Black),
                      const SizedBox(height: 40,),
                      Text('Location',style: PetroSoftTextStyle.style15Black)
                    ],
                  )
              ),
              Expanded(
                child: SizedBox(
                  // width: 150,
                    height: 300,
                    child: Column(
                      children: [
                        const SizedBox(height: 15,),
                        descriptionUI(),
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
                        const SizedBox(height: 10,),
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
                        ),
                        Container(

                            decoration: BoxDecoration(//DecorationImage
                              border: Border(
                                bottom: BorderSide(width: 1.0, color: Colors.black12),
                              ),//Border.all
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: DropdownButton(
                                isExpanded: true,
                                items: summaryOptions,
                                underline: Container(),
                                // hint: const Text("S"),
                                value: selectedSummary,
                                onChanged: (val) async {
                                  selectedSummary = val.toString();
                                  setState(() {});
                                },
                              ),
                            )),
                        Container(

                            decoration: BoxDecoration(//DecorationImage
                              border: Border(
                                bottom: BorderSide(width: 1.0, color: Colors.black12),
                              ),//Border.all
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: DropdownButton(
                                isExpanded: true,
                                items: locationOptions,
                                underline: Container(),
                                // hint: const Text("S"),
                                value: selectedLocation,
                                onChanged: (val) async {
                                  selectedLocation = val.toString();
                                  setState(() {});
                                },
                              ),
                            )),
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
        if(descriptionName==""||descriptionName==null){
          Fluttertoast.showToast(msg: "Please select description");
        }else{
        getData();
        }

      }, title: "Download", backgroundColor: ColorsForApp.app_theme_color_owner,),

    );
  }
  Widget descriptionUI(){
    return  InkWell(
      onTap: ()async{
        var result = await showSearch<String>(
          context: context,
          delegate: CustomDelegate(commonList:itemList,ListType: "itemList"),
        );
        setState(() => descriptionName = result);
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
                  child: Text(descriptionName!=null&&descriptionName!=''?descriptionName:"Select description"),
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
