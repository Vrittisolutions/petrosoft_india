import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/customer_ledger_report.dart';
import 'package:petrosoft_india/PetrosoftOwner/Reports/report_list.dart';
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
    print("Cust ledger");
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
    print("customerLedgerData-->$customerLedgerData");
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
                    builder: (context) => const ReportListPage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title:  Text("Customer Ledger",style: PetroSoftTextStyle.style17White),
      ),
      // appBar: AppBar(title: const Text('Customer Ledger',), backgroundColor: ColorsForApp.app_theme_color_owner),
      body: Center(
        child: FutureBuilder(
          future: api,
          builder: (context,snapshot){
            if(snapshot.hasData){
              return SingleChildScrollView(
                // scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    showBottomBorder: true,
                    columnSpacing: 10.0,
                    border: TableBorder.all(
                      width: 0.1,
                      color:ColorsForApp.light_gray_color,
                    ),
                    headingRowColor: MaterialStateColor
                        .resolveWith(
                          (states) => ColorConverter.hexToColor("#D9D9D9").withOpacity(0.2),),
                    columns:  <DataColumn>[
                      DataColumn(label: Text("Name",style: PetroSoftTextStyle.style15BlackBold,)),
                      DataColumn(label: Text("Bal",style: PetroSoftTextStyle.style15BlackBold,)),
                      DataColumn(label: Text("Mobile",style: PetroSoftTextStyle.style15BlackBold,)),
                    ],
                    rows: List<DataRow>.generate(
                        customerLedgerData.length,
                            (index) => DataRow(

                          /*color: MaterialStateProperty.resolveWith<Color>(
                                   (Set<MaterialState> states) {
                                 // Even rows will have a grey color.
                                 if (index % 2 == 0) {
                                   return ColorsForApp.app_theme_color_light_owner_drawer.withOpacity(0.3);
                                 }
                                 return Colors.white; // Use default value for other states and odd rows.
                               }),*/
                            cells: <DataCell>[
                              DataCell(Text(customerLedgerData[index]["name"],style: PetroSoftTextStyle.style12Black),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerLedgerReport(accNo:customerLedgerData[index]["acno"],title: "Customer Ledger",color: ColorsForApp.app_theme_color_owner)));
                                },),
                              DataCell(Text( customerLedgerData[index]["balance"].toStringAsFixed(2).toString(),style: PetroSoftTextStyle.style13Black),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerLedgerReport(accNo:customerLedgerData[index]["acno"],title: "Customer Ledger",color: ColorsForApp.app_theme_color_owner)));
                                  }),
                              DataCell(Text(customerLedgerData[index]["pager"],style: PetroSoftTextStyle.style13Black),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerLedgerReport(accNo:customerLedgerData[index]["acno"],title: "Customer Ledger",color: ColorsForApp.app_theme_color_owner)));
                                  }),
                            ])),
                  ),
                ),
              );

            }
            return Center(child: CommonWidget.circularIndicator());
          },
        ),
      ),

    );
  }
}
