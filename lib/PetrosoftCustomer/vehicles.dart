import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/customer_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({Key? key}) : super(key: key);

  @override
  _VehiclePageState createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {

  final vehicleNoController=TextEditingController();
  final vehicleTypeController=TextEditingController();
  dynamic vehiclesList;
  dynamic api;
  @override
  void initState() {
    super.initState();
   api= getVehicleList();
  }
  getVehicleList() async {
    var _url = UT.APIURL! +
        "api/getPetroCustData/GetData?shop=" +
        UT.shop_no! +
        "&cust_code="+UT.ClientAcno!+
        "&cols=cust_code,veh_no";
    var data = await UT.apiDt(_url);
    vehiclesList=data;
    return vehiclesList;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorsForApp.app_theme_color,
      statusBarBrightness: Brightness.dark,
    ));



    Future<bool?> _willPopCallback()async{
      return Navigator.of(context)
          .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
        return const PetrosoftCustomerHomePage();
      }));
      // return true if the route to be popped
    }
    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
  },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
          title: const Text('Vehicles',),),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: FutureBuilder(
              future: api,
                  builder: (context,snapshot){
                   if(snapshot.connectionState==ConnectionState.done && snapshot.hasData==true){
                     if(vehiclesList[0]["cust_code"]!="") {
                       return Padding(
                         padding: const EdgeInsets.only(top: 8),
                         child: ListView.builder(
                             itemBuilder: (context, index) {
                               return Container(
                                 margin: const EdgeInsets.only(bottom: 8),
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(7),
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
                                 child: Padding(
                                   padding: const EdgeInsets.all(7),
                                     child:Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: ColorsForApp.icon,
                                            child:  const Icon(Icons.directions_car_sharp,color: Colors.white, size: 25,),
                                          ),
                                          const SizedBox(width: 10,),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(vehiclesList[index]["veh_no"].toString(),
                                                style: StyleForApp.text_style_normal_16_black,),
                                              const SizedBox(height: 5,),
                                              Text("4 Wheeler", style: StyleForApp.text_style_bold_14_light_gray
                                              ),
                                            ],
                                          )
                                        ],
                                     )

                                 ),
                               );
                             },
                             itemCount: vehiclesList.length),
                       );
                     }else{
                       return Center(child:Text("No data found!! ",style: UT.PetrosoftCustomerNoDataStyle,));
                     }
                   }
                    return Center(child:CommonWidget.circularIndicator(),);
                  },
                )
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: const Icon(Icons.add),
          backgroundColor:ColorsForApp.appThemeColorPetroCustomer,
          onPressed: ()=>enterVehicle(context)
        ),
      ),
    );
  }
  enterVehicle(BuildContext context){
   return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title:  Text('Enter Vehicle Details', style: StyleForApp.text_style_bold_14_black,),
            content: SizedBox(
              height: 130,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: vehicleNoController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Vehicle No",
                            labelStyle: StyleForApp.text_style_normal_14_black
                          //contentPadding: EdgeInsets.all(15.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 45,
                      child: TextFormField(
                        controller: vehicleTypeController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Vehicle Type",
                          labelStyle: StyleForApp.text_style_normal_14_black
                          //contentPadding: EdgeInsets.all(15.0),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: ColorsForApp.app_theme_color_light_drawer,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    textStyle: StyleForApp.text_style_normal_14_black),
                child: const Text('Cancel',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onPressed: () {
                  vehicleNoController.clear();
                  vehicleTypeController.clear();
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 5,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary:ColorsForApp.appThemeColorPetroCustomer,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    textStyle: const TextStyle(
                        color:Colors.white ,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                child:   Text('Save',
                    style: StyleForApp.text_style_normal_14_white),
                onPressed: () {
                  if(vehicleNoController.text==''){
                    Fluttertoast.showToast(msg: "Please enter vehicle number");
                  }else if(vehicleTypeController.text==''){
                    Fluttertoast.showToast(msg: "Please enter vehicle type");
                  }else{
                    saveData();
                  }

                },
              ),
            ],
          );
        });
  }
  saveData() async {
    var vehicleData= Map();
    vehicleData["veh_no"]= vehicleNoController.text;
    vehicleData["cust_code"]=UT.ClientAcno;
    vehicleData["isdeleted"]="N";
    vehicleData["isapproved"]="N";
    List crhdDataList=[];
    crhdDataList.add(vehicleData);
    var _url = UT.APIURL! +
        "api/PostData/Post?tblname=mob_vehlst" +
        UT.shop_no!;
    _url += "&Unique=cust_code,veh_no";
    var Result = await UT.save2Db(_url, crhdDataList);
    if(Result=="ok"){
      Fluttertoast.showToast(msg: 'saved successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VehiclePage()));
    }
  }

}


