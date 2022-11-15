import 'dart:convert';
import 'package:petrosoft_india/AdatsoftOwner/adat_owner_home_page.dart';
import 'package:petrosoft_india/AdatsoftSeller/farmer_home_page.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/PetrosoftCustomer/customer_home_page.dart';
import 'package:petrosoft_india/PetrosoftManager/manager_home_page.dart';
import 'package:petrosoft_india/PetrosoftOperator/operator_home_page.dart';
import 'package:petrosoft_india/common_home_page.dart';
import 'package:petrosoft_india/PetrosoftOwner/widget/background.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';



class FirmSelection extends StatefulWidget {
  FirmSelection({Key? key}) : super(key: key);

  @override
  _FirmSelectionState createState() => _FirmSelectionState();
}

class _FirmSelectionState extends State<FirmSelection> {
  bool isLoading=true;
  @override
  void initState() {
    super.initState();
    if(UT.m["isFirmAvailable"]!=null){
      isLoading=false;
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient:App.Type=="PetroOwner"?LinearGradient(
                colors: [
                  ColorsForApp.appThemePetroOwner,
                  ColorsForApp.appThemePetroOwner
                ]
            ):App.Type=="PetroBuyer"?LinearGradient(
                colors: [
                  ColorsForApp.appThemeColorPetroCustomer,
                  ColorsForApp.appThemeColorPetroCustomer
                ]
            ):
            App.Type=="PetroOperator"?LinearGradient(
                colors: [
                  ColorsForApp.appThemeColorPetroOperator,
                  ColorsForApp.appThemeColorPetroOperator
                ]
            ): App.Type=="AdatSeller"?LinearGradient(
                colors: [
                  UT.adatSoftSellerAppColor!,
                  UT.adatSoftSellerAppColor!
                ]
            ):App.Type=="AdatOwner"?
            LinearGradient(
                colors: [
                  ColorsForApp.appThemeColorAdatOwner,
                  ColorsForApp.appThemeColorAdatOwner
                ]
            ):LinearGradient(
                colors: [
                  Colors.purple.shade900,
                  Colors.purple.shade900
                ]
            )
          /*image: DecorationImage(
              image: AssetImage('petrosoft_India/primaryBg.png'),
              fit: BoxFit.cover,
            )*/
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 50,
                left: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Select Firm",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                        ),
                      ],
                    )
                  ],
                )
            ),
            Positioned(
                top: 80, right: 0, bottom: 0, child: Container(
              width: MediaQuery.of(context).size.width,
              // height: 350,
              decoration: const BoxDecoration(
                color: const Color(0x80FFFFFF),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60.0),
                    bottomRight: const Radius.circular(0.0)
                ),
              ),
            )
            ),
            Positioned(top: 100, right: 0, bottom: 0,
                child: Container(
              width: 350,
              // height: 584,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60.0),
                  bottomRight: const Radius.circular(0.0),
                  bottomLeft: const Radius.circular(0.0),
                ),
              ),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        //  border: Border.all(color: Colors.grey.shade300),
                          color: const Color(0x80FFFFFF),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                            onTap: () {
                              DialogBuilder(context).showLoadingIndicator('');
                              UpdateSelect(context, index);
                            },
                            title: Text(UT.FirmData[index]["clientfirmname"],style: const TextStyle(fontSize:16,color: Colors.black,fontWeight: FontWeight.bold),),
                            subtitle:Text(UT.FirmData[index]["clientacname"],style: const TextStyle(fontSize:13,color: Colors.blueGrey)),
                            leading:  Icon(Icons.label_important_outlined,color: Colors.blueGrey,),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: UT.FirmData.length
              ),
            )),

          ],
        ),
      ),
    );

  }
}

UpdateSelect(ctx, index) async {
  if(App.Type=="PetroOperator"){
    UT.SPF!.setBool("islogin", true);
  }else if(App.Type=="PetroBuyer"){
    UT.SPF!.setBool("islogin", true);
  }else if(App.Type=="PetroOwner"){
    UT.SPF!.setBool("islogin", true);
  }else if(App.Type=="AdatSeller"){
    UT.SPF!.setBool("islogin", true);
  }else if(App.Type=="AdatOwner"){
    UT.SPF!.setBool("islogin", true);
  }else if(App.Type=="PetroManager"){
    UT.SPF!.setBool("islogin", true);
  }
  var str = jsonEncode(UT.FirmData);
  UT.SPF!.setString("FirmData", str);
  UT.SPF!.setInt("firmno", index);
  await UT.setEnv();
  if(App.Type=="PetroOperator"){
    /*Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => const PetrosoftOperatorHomePage(),
      ), (route) => false,
    );*/
    Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => const Dashboard(),
      ), (route) => false,
    );
  }else  if(App.Type=="PetroBuyer"){
    Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => const Dashboard(),
      ), (route) => false,
    );/*Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => const PetrosoftCustomerHomePage(),
      ), (route) => false,
    );*/
  }else if(App.Type=="PetroOwner"){
    Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => const Dashboard(),
      ), (route) => false,
    );/*Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => const PetroOwnerHomePage(),
      ), (route) => false,
    );*/
  }else if(App.Type=="PetroManager"){
    Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => const Dashboard(),
      ), (route) => false,
    );/*  Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => const Dashboard(),
      ), (route) => false,
    );*/
  }else if(App.Type=="AdatSeller"){
    Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => const AdatSellerHomePage(),
      ), (route) => false,
    );
  }else if(App.Type=="AdatOwner"){
    Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => const AdatOwnerHomePage(),
      ), (route) => false,
    );
  }
}
