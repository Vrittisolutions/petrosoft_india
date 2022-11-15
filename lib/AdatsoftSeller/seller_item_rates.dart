import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'farmer_home_page.dart';

class SellerItemRates extends StatefulWidget {
  const SellerItemRates({Key? key}) : super(key: key);

  @override
  _SellerItemRatesState createState() => _SellerItemRatesState();
}

class _SellerItemRatesState extends State<SellerItemRates> {
  dynamic rateMasterData;
  dynamic api;
  double totalCredit=0.0;
  @override
  void initState() {
    super.initState();
    api= getData();
  }
  getData() async {
    var _url = UT.APIURL! +
        "api/GeneralLdpr?cyr="+UT.curyear!+"&shop=" +
        UT.shop_no! +
        "&date1="+UT.yearStartDate! +
        "&date2="+UT.yearEndDate! +
        "&acno="+UT.ClientAcno.toString();
    rateMasterData = await UT.apiDt(_url);
    print(_url);
    print(rateMasterData);
    for(int i=0;i<rateMasterData.length;i++){
      totalCredit+=rateMasterData[i]["credit"];
    }
    setState(() {});
    return rateMasterData;
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: UT.adatSoftSellerAppColor,
          titleSpacing: 0.0,
          leading: IconButton(
            onPressed: (){
              UT.m['saledate']=UT.m['saledate'];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdatSellerHomePage()));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          iconTheme: StyleForApp.iconThemeData,
          title: const CommonAppBarText(title: "Item Rates"),
          //title: const Text("Item Rates"),
        ),
        body: FutureBuilder(
          future: api,
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done && snapshot.hasData == true){
              if(rateMasterData.length!=0) {
                return Column(
                  children: [
                    // const SizedBox(height: 10),
                    Container(
                      height: 50,
                      color: Colors.grey.shade200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:  const [
                          SizedBox(
                            //width: 60,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Name",style:TextStyle(fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            ),
                          ),
                          SizedBox(
                           // width: 50,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Min Rate",style:TextStyle(fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                            ),
                          ),
                          SizedBox(
                            //width: 50,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Max Rate",style:TextStyle(fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                            ),
                          ),
                          SizedBox(
                            //width: 50,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Avg Rate",style:TextStyle(fontSize:16,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                            ),
                          )
                        ],
                      ),
                    ),
                    // const Divider(thickness: 1.0,color: Colors.grey,),
                    Expanded(
                      child: ListView.builder(
                        itemCount:rateMasterData.length ,
                        itemBuilder: (context, index){
                          if(rateMasterData[index]["debit"]==0){
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    SizedBox(
                                      //width: 100,
                                     // height: 30,
                                      child: Padding(
                                        padding: EdgeInsets.only(left:8.0,top: 8.0,bottom: 8.0),
                                        child: Text("Shimla M",textAlign: TextAlign.start)),
                                      ),

                                    SizedBox(
                                      //width: 100,
                                      height: 30,
                                      child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("1000",textAlign: TextAlign.end,)
                                      ),
                                    ),
                                    SizedBox(
                                      //width: 100,
                                      //height: 30,
                                      child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("1000",textAlign: TextAlign.end,)
                                      ),
                                    ),
                                    SizedBox(
                                      //width: 100,
                                     // height: 30,
                                      child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("1000",textAlign: TextAlign.end,)
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(thickness: 1.0,color: Colors.grey,),
                              ],
                            );
                          }else{
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                );
              }else{
                return Center(child:Text("No data found!! ",style: UT.adatSoftSellerNoDataStyle));
              }
            }
            return Center(child:CommonWidget.circularIndicator(),);
          },
        ),
      ),
    );
  }
  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return const AdatSellerHomePage();
    }));
    // return true if the route to be popped
  }
}
