import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/PetrosoftCustomer/customer_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class ItemRates extends StatefulWidget {
  const ItemRates({Key? key}) : super(key: key);
  @override
  _ItemRatesState createState() => _ItemRatesState();
}

class _ItemRatesState extends State<ItemRates> {
  List itemRatesData=[];
  List petroList=[];
  String? credVou;
  bool isLoading=true;
  dynamic api;
  @override
  void initState() {
    super.initState();
    api=getItemList();
  }

  getItemList() async {
    var _url = UT.APIURL! +
        "api/ItemEnt9P/getItemWithRate?firmNo=" +
        UT.shop_no! +
        "&date="+ UT.m['saledate'].toString();
    var data = await UT.apiDt(_url);
    itemRatesData=data;
    for(int i=0;i<itemRatesData.length;i++){
      if(itemRatesData[i]["item_group"]=="PETRO"){
        var p={
          "item_desc":itemRatesData[i]["item_desc"],
          "pur_unit":itemRatesData[i]["pur_unit"].toString(),
          "pl_rate":itemRatesData[i]["pl_rate"].toString(),
        };
        petroList.add(p);
      }
    }
    return itemRatesData;
  }

  @override
  Widget build(BuildContext context) {


    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorsForApp.app_theme_color,
      statusBarBrightness: Brightness.dark,
    ));

    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
          title: const Text('Item Rate',),
        ),
        body: FutureBuilder(
               future: api,
               builder: (context, snapshot) {
                 if(snapshot.data!=null){
                   return SingleChildScrollView(
                     scrollDirection: Axis.vertical,
                     child: SizedBox(
                       width: double.infinity,
                       child: DataTable(

                         // horizontalMargin: double.maxFinite,
                         headingRowColor: MaterialStateColor
                             .resolveWith(
                                 (states) => ColorsForApp.appThemeColorPetroCustomer),
                         columns: const <DataColumn>[

                           DataColumn(label: Text("Item Name",style: TextStyle(color: Colors.white),)),
                           // DataColumn(label: Text("Unit",style: TextStyle(color: Colors.white),)),
                           DataColumn(label: Text("Rate",textAlign:TextAlign.end,style: TextStyle(color: Colors.white),)),
                         ],
                         rows: List<DataRow>.generate(
                             petroList.length,
                                 (index) => DataRow(
                                 color: MaterialStateProperty.resolveWith<Color>(
                                         (Set<MaterialState> states) {
                                       // Even rows will have a grey color.
                                       if (index % 2 == 0)
                                         return Colors.white.withOpacity(0.3);
                                       const Divider(color: Colors.grey,);
                                       return Colors.white; // Use default value for other states and odd rows.
                                     }),
                                 cells: <DataCell>[
                                   DataCell(Text(petroList[index]["item_desc"])),
                                   // DataCell(Text(petroList[index]["pur_unit"].toString())),
                                   DataCell(Text(petroList[index]["pl_rate"].toString(),textAlign:TextAlign.end)),])),

                       ),
                     ),
                   );
                 }
                 return Center(child:CommonWidget.circularIndicator(),);
               }
           ),
        )

    );
  }
  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return const PetrosoftCustomerHomePage();
    }));
    // return true if the route to be popped
  }
}
