import 'package:petrosoft_india/AdatsoftOwner/NewUI/home_page.dart';
import 'package:petrosoft_india/AdatsoftOwner/adat_owner_home_page.dart';
import 'package:petrosoft_india/AdatsoftSeller/farmer_home_page.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/manager_home_page.dart';
import 'package:petrosoft_india/PetrosoftOperator/operator_home_page.dart';
import 'package:petrosoft_india/common_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'PetrosoftCustomer/customer_home_page.dart';
import 'common/widgets/login.dart';

var flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
late AndroidNotificationChannel channel;


Future main() async {

  WidgetsFlutterBinding.ensureInitialized();
  UT.cameras = await availableCameras();
  //await Firebase.initializeApp();

  /*FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title// description
      importance: Importance.high,
    );
  }
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  initialise();*/

  UT.SPF = await SharedPreferences.getInstance();
  if (UT.SPF!.getBool("islogin") == true &&
      UT.SPF!.getString("FirmData") != null) {
   var setEnvRes= await UT.setEnv();
    print("setEnvRes--$setEnvRes");
  }
  nav()  {
    var _appType=UT.SPF!.getString("SPAppType");
    print("_appType-->$_appType");
    if(_appType==null){
     return const selectAppType();
    }else{
      App.Type=_appType;
    }
    if(UT.SPF!.getBool("islogin") == true &&App.Type=="PetroOperator"){

     //return const PetrosoftOperatorHomePage();
     return const Dashboard();

    }else if(UT.SPF!.getBool("islogin") == true &&App.Type=="PetroBuyer"){

     // return const PetrosoftCustomerHomePage();
      return const Dashboard();
    }else if(UT.SPF!.getBool("islogin") == true &&App.Type=="PetroOwner"){
      //return const PetroOwnerHomePage();
      return const Dashboard();

    }else if(UT.SPF!.getBool("islogin") == true && App.Type=="AdatSeller"){
      return const AdatSellerHomePage();
    }else if(UT.SPF!.getBool("islogin") == true && App.Type=="PetroManager"){
      //return const Dashboard();
      return const Dashboard();
    }else if(UT.SPF!.getBool("islogin") == true && App.Type=="AdatOwner"){
      return  HomeScreen();
     // return const AdatOwnerHomePage();
    }
    else{
      return const LoginPage();
    }
  }
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Vritti Solutions Ltd.",
      home:nav(),
     // theme: ThemeData(primarySwatch: ColorsForApp.app_theme_color_new),
    ),
  );

}

/*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) {
    print("RemoteMessage-->$message");
  });


    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'ic_launcher',
            ),
          ));
    }


}


Future initialise() async {

  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) {
  print("RemoteMessage-->$message");
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'ic_launcher',
            ),
          ));
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');

  });
}
*/



class selectAppType extends StatefulWidget{
  const selectAppType({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return selectAppTypestate();
  }

}
class selectAppTypestate extends State<selectAppType>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsForApp.appThemeColor,
        title: Text(" Select App Type",style: PetroSoftTextStyle.style17White,),titleSpacing: 0.0,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children:  [
              InkWell(
                onTap: (){
                  UT.SPF!.setString("SPAppType", "PetroOperator");
                  App.Type="PetroOperator";
                 // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      LoginPage()), (Route<dynamic> route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 45,
                      child: Center(child: Text("Petrosoft Operator",style: StyleForApp.text_style_bold_14_white,)),
                    color: ColorsForApp.secondary,
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  UT.SPF!.setString("SPAppType", "PetroBuyer");
                  App.Type="PetroBuyer";
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      LoginPage()), (Route<dynamic> route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 45,
                    child: Center(child: Text("Petrosoft Transporter",style: StyleForApp.text_style_bold_14_white,)),
                    color: ColorsForApp.secondary,
                  ),
                ),
              ), InkWell(
                onTap: (){
                  UT.SPF!.setString("SPAppType", "PetroOwner");
                  App.Type="PetroOwner";
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      LoginPage()), (Route<dynamic> route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 45,
                    child: Center(child: Text("Petrosoft Business",style: StyleForApp.text_style_bold_14_white,)),
                    color: ColorsForApp.secondary,
                  ),
                ),
              ), InkWell(
                onTap: (){
                  UT.SPF!.setString("SPAppType", "PetroManager");
                  App.Type="PetroManager";
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      LoginPage()), (Route<dynamic> route) => false);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 45,
                    child: Center(child: Text("Petrosoft Manager",style: StyleForApp.text_style_bold_14_white,)),
                    color: ColorsForApp.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
 





