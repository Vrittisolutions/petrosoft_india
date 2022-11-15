import 'dart:convert';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/common_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/login.dart';
import 'package:flutter/material.dart';

class PetrosoftOwnerDrawer extends StatelessWidget {
  const PetrosoftOwnerDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color:UT.BACKGROUND_COLOR),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(children: <Widget>[
                UserAccountsDrawerHeader(
                    accountName: Text(UT.userName!+" - "+UT.ExternalUserID!, style: StyleForApp.text_style_normal_16_white,),
                    accountEmail: Text(UT.firm_name!, style: StyleForApp.text_style_normal_13_white,),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.3,1],
                          colors:[
                            ColorsForApp.app_theme_color_owner,
                            ColorsForApp.app_theme_color_light_owner_drawer,
                          ]),
                    ),
                    currentAccountPicture: const CircleAvatar(
                        backgroundImage: AssetImage("assets/profile.png"))),
                Expanded(
                  // height: 200,
                  child: ListView.builder(
                      itemCount:UT.FirmData.length,
                      itemBuilder: (context,index){
                        return DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.0),

                          ),
                          child: Column(
                            children: [
                              ListTile(
                                onTap: (){
                                  UpdateSelect(context,index);
                                },
                                title: Row(
                                  children: <Widget>[
                                    Icon(Icons.arrow_drop_down_circle,color: ColorsForApp.icon_owner,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(UT.FirmData[index]["clientfirmname"]),
                                    )
                                  ],
                                ),
                              ),
                              const Divider(color: Colors.grey,),

                              InkWell(
                                onTap: (){
                                  UT.SPF!.setBool("islogin", false);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                },
                                child: Padding(padding: const EdgeInsets.only(left:15 ,),
                                  child:  Row(
                                    children: [
                                      Icon(Icons.login_outlined, size: 20, color: ColorsForApp.icon_owner,),
                                      const SizedBox(width: 10,),
                                      Text('Logout', style: StyleForApp.text_style_normal_14_black,),
                                    ],

                                  ),),
                              )
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
                    gradient: LinearGradient(colors: [ColorsForApp.secondary, ColorsForApp.secondary],
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
                             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddFirm()));
                            },
                           // leading: Icon(Icons.add_circle,color: Colors.white,),
                            title: Text('Version : ${UT.m["AppVersion"]}',style: TextStyle(fontSize:16,color: Colors.white),)),
                      ),
                    )
                )),
          /*  Container(
                height: 50,
                //margin: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.blue, Colors.blue],
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
                             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddFirm()));
                            },
                            leading: Icon(Icons.add_circle,color: Colors.white,),
                            title: Text('Add Firm',style: TextStyle(fontSize:16,color: Colors.white),)),
                      ),
                    )
                )),*/
          ],
        ),
      ),
    );
  }
  UpdateSelect(ctx, index) async {
    UT.SPF!.setBool("islogin", true);
    var str = jsonEncode(UT.FirmData);
    UT.SPF!.setString("FirmData", str);
    UT.SPF!.setInt("firmno", index);
    await UT.setEnv();
    Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (BuildContext context) => const Dashboard(),
      ), (route) => false,
    );
  }
}
