import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/PetrosoftManager/Reports/customer_ledger_report.dart';
import 'package:petrosoft_india/PetrosoftManager/Reports/report_list.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomerLedger extends StatefulWidget {
  const CustomerLedger({Key? key}) : super(key: key);

  @override
  _CustomerLedgerState createState() => _CustomerLedgerState();
}

class _CustomerLedgerState extends State<CustomerLedger> {
  dynamic customerLedgerData;
  late Color color;
  int selectedIndex = -1;
 dynamic api;
  @override
  void initState() {
    super.initState();
     api=getData();
  }
  getData() async {
    print("hii");
//"/api/CustLdpr/GetLdgr?curyear=" + Setup("curyear") + "&shop=" + Firm("Shop") + "&custprefix=" + AC("CustPrefix") + "&getPrint=true"
    var _url = UT.APIURL! +
        "api/CustLdpr/GetLdgr?curyear=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&custprefix=" +
        UT.AC("CustPrefix")+"&getPrint=false";
    print("$_url");
     customerLedgerData = await UT.apiDt(_url);
    print("end");
    print(customerLedgerData);
    return customerLedgerData;
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
        title: const Text("Cardex Entry"),
      ),
     // appBar: AppBar(title: const Text('Customer Ledger',), backgroundColor: ColorsForApp.app_theme_color_owner),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: api,
           builder: (context,snapshot){
             if(snapshot.hasData){
               return SingleChildScrollView(
                 scrollDirection: Axis.vertical,
                 child: SizedBox(
                   width: double.infinity,
                   child: DataTable(showBottomBorder: true,
                     columnSpacing: 20.0,
                     headingRowColor: MaterialStateColor
                         .resolveWith(
                             (states) => ColorsForApp.app_theme_color_light_owner),
                     columns: const <DataColumn>[
                       DataColumn(label: Text("Date",style: TextStyle(color: Colors.white),)),
                       DataColumn(label: Text("Received From / Issue To",style: TextStyle(color: Colors.white),)),
                       DataColumn(label: Text("Received",style: TextStyle(color: Colors.white),)),
                       DataColumn(label: Text("Issue",style: TextStyle(color: Colors.white),)),
                       DataColumn(label: Text("Balance",style: TextStyle(color: Colors.white),)),
                     ],
                     rows: List<DataRow>.generate(
                         customerLedgerData.length,
                             (index) => DataRow(

                             color: MaterialStateProperty.resolveWith<Color>(
                                     (Set<MaterialState> states) {
                                   // Even rows will have a grey color.
                                   if (index % 2 == 0) {
                                     return ColorsForApp.app_theme_color_light_owner_drawer.withOpacity(0.3);
                                   }
                                   return Colors.white; // Use default value for other states and odd rows.
                                 }),
                             cells: <DataCell>[
                               DataCell(Text(customerLedgerData[index]["name"]),),
                               DataCell(Text( customerLedgerData[index]["balance"].toStringAsFixed(2).toString()),),
                               DataCell(Text(customerLedgerData[index]["pager"]),),
                               DataCell(Text(customerLedgerData[index]["pager"]),),
                               DataCell(Text(customerLedgerData[index]["pager"]),),
                             ])),
                   ),
                 ),
               );

             }
             return Center(child: CommonWidget.circularIndicator());
           },
          )

        ),
      ),

    );
  }
}
