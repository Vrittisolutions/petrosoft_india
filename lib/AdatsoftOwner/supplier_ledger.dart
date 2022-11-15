import 'package:petrosoft_india/Classes/appbar.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/customer_ledger_report.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/save_card_sale.dart';
import 'package:petrosoft_india/PetrosoftOwner/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SupplierLedger extends StatefulWidget {
  const SupplierLedger({Key? key}) : super(key: key);

  @override
  _SupplierLedgerState createState() => _SupplierLedgerState();
}

class _SupplierLedgerState extends State<SupplierLedger> {
  List supplierLedgerData=[];
  late Color color;
  int selectedIndex = -1;
  dynamic api;
  String textForSearch = '';
  List searchResult=[];
  @override
  void initState() {
    super.initState();
    api=getData();
  }
  getData() async {
    print("hii");
//"/api/CustLdpr/GetLdgr?curyear=" + Setup("curyear") + "&shop=" + Firm("Shop") + "&custprefix=" + AC("CustPrefix") + "&getPrint=true"
    var _url = UT.APIURL! +
        "api/SuppLdpr/GetLdgr?curyear=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&suppprefix=" +
        UT.AC("SuppPrefix")+"&getPrint=false";
    print("$_url");
    var data = await UT.apiDt(_url);
    supplierLedgerData.addAll(data);
    searchResult.addAll(data);
    print(supplierLedgerData);
    return supplierLedgerData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.indigo.shade100,
      /*appBar: AppBar(
        backgroundColor: UT.ownerAppColor,
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
        title: const Text("Customer Ledger"),
      ),*/
      appBar: CustomAppBar(enableSearchBar: "ENB",title: 'Supplier Ledger',specifyClickFromPage: "SupplierLedger",
          objPage: this),
     // appBar: AppBar(title: const Text('Supplier Ledger',), backgroundColor: ColorsForApp.appThemeColorAdatOwner),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: api,
              builder: (context,snapshot){
                if(snapshot.hasData){
                  if(supplierLedgerData.length==1&&supplierLedgerData[0]["srno"]!=""&&supplierLedgerData[0]["balance"]!=0.0){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 300,),
                        Center(
                            child:Text("No customer Ledger found!!",style: UT.PetroOwnerNoDataStyle,))
                      ],
                    );
                  }else {
                    return Column(
                      children: [
                        // const SizedBox(height: 10),
                        Container(
                          height: 40,
                          color: ColorsForApp.appThemeColorAdatOwner,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children:   const [
                              SizedBox(
                                width: 140,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Name",style:TextStyle(color:Colors.white,fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Bal",style:TextStyle(color:Colors.white,fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.end),
                              ),
                              SizedBox(
                                //width: 50,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Mobile",style:TextStyle(color:Colors.white,fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // const Divider(thickness: 1.0,color: Colors.grey,),
                        Expanded(
                          child:searchResult.length != 0 || textForSearch.isNotEmpty
                              ? searchResult.length != 0
                              ? ListView.builder(
                            itemCount:searchResult.length ,
                            itemBuilder: (context, index){
                              return Container(
                                color: index % 2 == 0?ColorsForApp.app_theme_color_light_owner_drawer.withOpacity(0.3)
                                    : Colors.white,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap:(){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomerLedgerReport(accNo:searchResult[index]["acno"],title: "Supplier Ledger",color: ColorsForApp.appThemeColorAdatOwner)));
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:  [
                                          Expanded(
                                            child: Container(
                                              width: 100,
                                              //height: 50,
                                              child: Padding(
                                                  padding: const EdgeInsets.only(left:8.0,top: 8.0,bottom: 8.0),
                                                  child: Text(searchResult[index]["name"],maxLines:2,style:StyleForApp.text_style_normal_13_black,textAlign: TextAlign.start)),
                                            ),
                                          ),

                                          Expanded(
                                            child: SizedBox(
                                              width: 80,
                                              //height: 30,
                                              child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text( searchResult[index]["balance"]
                                                      .toStringAsFixed(2)
                                                      .toString(),textAlign: TextAlign.end,)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            //height: 30,
                                            child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(searchResult[index]["pager"],style:StyleForApp.text_style_normal_13_black,textAlign: TextAlign.end,)
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    // const Divider(thickness: 1.0,color: Colors.grey,),
                                  ],
                                ),
                              );

                            },
                          ) :
                          Card(
                            margin: const EdgeInsets.all(0.0),
                            child: new ListTile(
                              title: const Text("No search result found!"),
                            ),
                          ): ListView.builder(
                            itemCount:supplierLedgerData.length ,
                            itemBuilder: (context, index){
                              return Container(
                                color: index % 2 == 0?ColorsForApp.app_theme_color_light_owner_drawer.withOpacity(0.3)
                                    : Colors.white,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap:(){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomerLedgerReport(accNo:supplierLedgerData[index]["acno"],title:"Supplier Ledger",color: ColorsForApp.appThemeColorAdatOwner)));
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:  [
                                          Expanded(
                                            child: Container(
                                              width: 100,
                                              height: 50,
                                              child: Padding(
                                                  padding: const EdgeInsets.only(left:8.0,top: 8.0,bottom: 8.0),
                                                  child: Text(supplierLedgerData[index]["name"],maxLines:2,style:StyleForApp.text_style_normal_13_black,textAlign: TextAlign.start)),
                                            ),
                                          ),

                                          Expanded(
                                            child: SizedBox(
                                              width: 80,
                                              height: 30,
                                              child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text( supplierLedgerData[index]["balance"]
                                                      .toStringAsFixed(2)
                                                      .toString(),textAlign: TextAlign.end,)
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            height: 30,
                                            child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(supplierLedgerData[index]["pager"],textAlign: TextAlign.end,)
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    // const Divider(thickness: 1.0,color: Colors.grey,),
                                  ],
                                ),
                              );

                            },
                          ),
                        ),
                      ],
                    );
                  }

                }
                return Center(child: CommonWidget.circularIndicator());
              },
            )

        ),
      ),

    );
  }
  onSearchTextChanged(String text) async {
    textForSearch = text;

    searchResult.clear();

    if (text.isEmpty||text=='') {
      print("inside search isempty");
      //searchResult.addAll(listCategory);
      setState(() {});
      return;
    }

    supplierLedgerData.forEach((userDetail) {
      String name = userDetail["name"];
      String pager = userDetail["pager"];

      name=name.toLowerCase();

      if (name.contains(text.toLowerCase()) || name.startsWith(text.toLowerCase()) || pager.contains(text.toLowerCase()) || pager.startsWith(text.toLowerCase())) searchResult.add(userDetail);
    });

    setState(() {});
  }
}
