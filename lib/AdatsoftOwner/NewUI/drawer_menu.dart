import 'dart:convert';
import 'dart:io';

import 'package:petrosoft_india/AdatsoftOwner/NewUI/home_page.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DrawerMenuScreen extends StatefulWidget {
  const DrawerMenuScreen({Key? key}) : super(key: key);

  @override
  _DrawerMenuScreenState createState() => _DrawerMenuScreenState();
}

class _DrawerMenuScreenState extends State<DrawerMenuScreen> {
  @override
  Widget build(BuildContext context) {
    const _androidStyle = TextStyle(
     fontSize: 14,
     fontWeight: FontWeight.bold,
     color: Colors.white,
   );
   const _iosStyle = TextStyle(color: Colors.white);
   final style = kIsWeb
       ? _androidStyle
       : Platform.isAndroid
       ? _androidStyle
       : _iosStyle;

   return Scaffold(
     backgroundColor: Colors.white,
     body: Container(
       height: MediaQuery.of(context).size.height,
       decoration: BoxDecoration(
         gradient: LinearGradient(
           colors: [
             Theme.of(context).primaryColor,
            // Colors.grey.shade300,
             Colors.indigo,
           ],
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,
         ),
       ),
       child: SafeArea(
         child:Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Expanded(
               child: Column(children: <Widget>[
                 UserAccountsDrawerHeader(
                    //decoration: BoxDecoration(color:Theme.of(context).primaryColor),
                   accountName: Text(UT.userName!+" - "+UT.ExternalUserID!,style: StyleForApp.text_style_normal_13_white,),
                   accountEmail: Text(UT.clientAcName!+"\n"+UT.firm_name!, style: StyleForApp.text_style_normal_13_white,),
                   currentAccountPicture: const CircleAvatar(
                     radius: 16,
                     backgroundImage: AssetImage("assets/profile.png"),
                   ),
                   decoration: BoxDecoration(
                     gradient: LinearGradient(
                       colors: [
                         Theme.of(context).primaryColor,
                         // Colors.grey.shade300,
                         Colors.indigo,
                       ],
                       begin: Alignment.topLeft,
                       end: Alignment.bottomRight,
                     ),
                   ),
                 ),
                 Expanded(
                   // height: 200,
                   child: ListView.builder(
                       itemCount: UT.FirmData.length,
                       shrinkWrap: true,
                       itemBuilder: (context,index){
                         return DecoratedBox(
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(0.0),
                             //color: Colors.purple[50]
                           ),
                           child: Column(
                             children: [
                               InkWell(
                                 onTap: (){
                             updateSelect(context,index);
                           },
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Row(
                                         children: <Widget>[
                                           Icon(Icons.arrow_drop_down_circle,color:Colors.white,size: 16,),
                                           Padding(
                                             padding: const EdgeInsets.only(left: 8.0),
                                             child: Text(UT.FirmData[index]["clientfirmname"], style: StyleForApp.text_style_normal_13_white,),
                                           )
                                         ],
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(left: 30.0),
                                       child: Text(UT.FirmData[index]["clientacname"],style: StyleForApp.text_style_normal_13_white),
                                     ),
                                   ],
                                 ),
                               ),


                               Divider(color: Colors.white,),

                               InkWell(
                                 child: Padding(padding: EdgeInsets.only(left:8 ,),
                                   child:  Row(
                                     children: [
                                       Icon(Icons.login_outlined, size: 16, color: Colors.white,),
                                       SizedBox(width: 8,),
                                       Text('Logout', style: StyleForApp.text_style_normal_13_white,),
                                     ],

                                   ),),
                                 onTap: (){
                                   UT.SPF!.setBool("islogin", false);
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                 },
                               ),
                             ],
                           ),
                         );
                       }),
                 ),
               ]),
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Container(
                 height: 50,
                 //margin: EdgeInsets.symmetric(vertical: 15),
                 color: Colors.transparent,
                 child: Align(
                     alignment: FractionalOffset.bottomCenter,
                     child: Padding(
                       padding: const EdgeInsets.only(left: 15.0, right: 24.0),
                       child: OutlinedButton.icon(
                         label:  Padding(
                           padding: EdgeInsets.all(5.0),
                           child: Text(
                             "Add Firm",
                               style: StyleForApp.text_style_normal_13_white,
                           ),
                         ),
                         icon: Icon(Icons.add_circle,color: Colors.white,),

                         style: OutlinedButton.styleFrom(
                           side: const BorderSide(color: Colors.white, width: 2.0),
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(16.0),
                           ),
                           textStyle: const TextStyle(color: Colors.white),
                         ),
                         onPressed: () {
                           //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddFirm()));
                         },
                        /* child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text(
                             "Add Firm",
                             style: const TextStyle(fontSize: 18),
                           ),
                         ),*/
                       ),
                     ),



                 )),
               ],
             ),
         ])
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
        builder: (BuildContext context) =>  HomeScreen(),
      ), (route) => false,
    );

    //Navigator.pushReplacementNamed(ctx, "/home");
    // Fluttertoast.showToast(
    //     msg: UT.FirmData[index]["NAME"]);
  }


}


