import 'dart:convert';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOperator/operator_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/login.dart';
import 'package:flutter/material.dart';

class petroDSRDrawer extends StatelessWidget {
  const petroDSRDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(children: <Widget>[
                UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.3,1],
                          colors:[
                            ColorsForApp.appThemeColor,
                            ColorsForApp.appThemeColor,
                          ]),
                    ),
                    accountName: Text(UT.userName!+" - "+UT.ExternalUserID!, style: StyleForApp.text_style_normal_16_white,),
                    accountEmail: Text(UT.firm_name!, style: StyleForApp.text_style_normal_13_white,),
                    currentAccountPicture: CircleAvatar(
                        backgroundImage: AssetImage("assets/profile.png"))),
                Expanded(
                  // height: 200,
                  child: ListView.builder(
                      itemCount: UT.FirmData.length,
                      itemBuilder: (context,index){
                        return DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.0),
                             // color: Color(0xFFccd9f9)
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                  onTap: (){
                                    UpdateSelect(context,index);
                                  },
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Icon(Icons.arrow_drop_down_circle,color:ColorsForApp.icon_operator,),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Text(UT.FirmData[index]["clientfirmname"], style: StyleForApp.text_style_normal_14_black,),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                              Divider(color: Colors.grey,),

                              InkWell(

                                child: Padding(padding: EdgeInsets.only(left:15 ,),
                                  child:  Row(
                                    children: [
                                      Icon(Icons.login_outlined, size: 20, color: ColorsForApp.icon_operator,),
                                      SizedBox(width: 10,),
                                      Text('Logout', style: StyleForApp.text_style_normal_14_black,),
                                    ],

                                  ),),
                                onTap: (){
                                  UT.SPF!.setBool("islogin", false);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                },
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ]),
            ),
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
        builder: (BuildContext context) => PetroSoftOperatorHomePage(),
      ), (route) => false,
    );
  }
}
