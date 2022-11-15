import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/add_receipt.dart';
import 'package:petrosoft_india/common_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ReceiptEntryPage extends StatefulWidget {
  const ReceiptEntryPage({Key? key}) : super(key: key);

  @override
  _ReceiptEntryPageState createState() => _ReceiptEntryPageState();
}

class _ReceiptEntryPageState extends State<ReceiptEntryPage> {
  var recepitEntryData;


  getData() async {
  //  CustRect/getReceiptList4mobileApp(string _year, string _shop, string date)
    var _url = UT.APIURL! +
        "api/CustRect/getReceiptList4mobileApp?_year=" +
        UT.curyear! +
        "&_shop=" +
        UT.shop_no! +
        "&date=" +
        UT.m['saledate'].toString();
    recepitEntryData = await UT.apiDt(_url);
    print("uRl-->$_url");
    print(recepitEntryData);
    return recepitEntryData;
  }
  Future<bool?> _willPopCallback()async{
    UT.m['saledate']=UT.m['saledate'];
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return const Dashboard();
    }));
    // return true if the route to be popped
  }
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
       // backgroundColor: Colors.indigo.shade100,
        appBar: AppBar(backgroundColor: ColorsForApp.appThemeColor,
          titleSpacing: 0.0,
          title:   Text("Receipt Entry",style: PetroSoftTextStyle.style17White,),
          actions: [
            Row(
              children: [
                Image.asset(PetroSoftAssetFiles.calender,height: 20,width: 20,),
                const SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(UT.dateMonthYearFormat(UT.m['saledate'].toString()),
                ),
                )
              ],
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: getData(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                return  ListView.builder(
                    itemBuilder: (context, index) {
                      if(recepitEntryData.length==1&&recepitEntryData[0]["srno"]==""){
                      return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                        const SizedBox(height: 300,),
                        Center(
                         child:Text("No receipt entry found!!",style: UT.PetroOwnerNoDataStyle,))
                      ],
                      );
                      }else {
                        return InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddNewReceipt(SrNo:recepitEntryData[index]["srno"])));
                          },
                          child: Stack(
                            children: [
                              Card(
                                elevation: 3
                                , color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text('Amount: ', style: StyleForApp.text_style_bold_16_owner_dark,),
                                            Text(
                                                "\u{20B9}"+ recepitEntryData[index]["amount"].toStringAsFixed(2).toString(),
                                                style: StyleForApp.text_style_bold_16_owner_dark),
                                          ],
                                        ),
                                        Divider(color: ColorsForApp.light_gray_color,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                        Text(
                                        recepitEntryData[index]["srno"],
                                            style: StyleForApp.text_style_normal_14_black
                                        ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                            Text(
                                            recepitEntryData[index]["name"],
                                                style: StyleForApp.text_style_normal_14_black
                                            ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 7,),
                                        Text(
                                            recepitEntryData[index]["narration"],
                                            style: StyleForApp.text_style_normal_14_black
                                        ),

                                      ]
                                  ),
                                ),
                                ),
                            ],
                          ),
                        );
                      }

                    },
                    itemCount: recepitEntryData.length);
              }
              return Center(child: CommonWidget.circularIndicator());
            },
            )

          ),
        ),
       /* floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: const Icon(Icons.add),
          backgroundColor: ColorsForApp.app_theme_color_owner,
          onPressed: () {
            getMaxNo();

          },
        ),*/
      ),
    );
  }
  getMaxNo()async{
    //PayVou/ GetMaxSrno(string year, string shop)
    var _url = UT.APIURL! +
        "api/CustRect/GetMaxSrno?year=" +
        UT.curyear! +
        "&shop="+UT.shop_no.toString();
    var data = await UT.apiStr(_url);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddNewReceipt(SrNo:data.toString().padLeft(5,'0'))));

  }
}
