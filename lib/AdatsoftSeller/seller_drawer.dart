import 'dart:convert';
import 'package:petrosoft_india/AdatsoftSeller/farmer_home_page.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/add_firm.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AdatSellerDrawer extends StatelessWidget {
  const AdatSellerDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(children: <Widget>[
                UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: UT.adatSoftSellerAppColor),
                    accountName: Text(UT.userName!+" - "+UT.ExternalUserID!,style: StyleForApp.text_style_normal_16_white),
                    accountEmail: Text(UT.clientAcName!+"\n"+UT.firm_name!,style: StyleForApp.text_style_normal_13_white),
                    currentAccountPicture: const CircleAvatar(
                        backgroundImage: AssetImage("assets/profile.png"))),
                Expanded(
                // height: 200,
                  child: ListView.builder(
                      itemCount: UT.FirmData.length,
                      itemBuilder: (context,index){
                        return DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.0),
                              //color: Colors.purple[50]
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                onTap: (){
                                  updateSelect(context,index);
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.arrow_drop_down_circle,color:UT.adatSoftSellerAppColor,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(UT.FirmData[index]["clientfirmname"]),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0),
                                      child: Text(UT.FirmData[index]["clientacname"],style: TextStyle(color:UT.adatSoftSellerAppColor),),
                                    ),
                                  ],
                                )
                              ),
                              Divider(color: Colors.grey[400],)
                            ],
                          ),
                        );
                      }),
                ),
              ]),
            ),
            Container(
              height: 50,
                //margin: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.green.shade700, Colors.green.shade900],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(0.0)
                ),
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Center(
                        child: ListTile(
                          onTap: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddFirm()));
                          },
                            leading: const Icon(Icons.add_circle,color: Colors.white,),
                            title: const Text('Add Firm',style: TextStyle(fontSize:16,color: Colors.white),)),
                      ),
                    )
                )),
          ],
        ),
      ),
    );
  }
  updateSelect(ctx, index) async {
    UT.SPF!.setBool("islogin", true);
    var str = jsonEncode(UT.FirmData);
    UT.SPF!.setString("FirmData", str);
    UT.SPF!.setInt("firmno", index);
    await UT.setEnv();
      Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(
          builder: (BuildContext context) => const AdatSellerHomePage(),
        ), (route) => false,
      );

    //Navigator.pushReplacementNamed(ctx, "/home");
    // Fluttertoast.showToast(
    //     msg: UT.FirmData[index]["NAME"]);
  }
}
