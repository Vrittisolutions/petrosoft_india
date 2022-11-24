import 'dart:convert';

import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/firmsele_page.dart';
import 'package:petrosoft_india/common/widgets/forgot_password.dart';
import 'package:petrosoft_india/common/widgets/reset_password.dart';
import 'package:petrosoft_india/common/widgets/register_new_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:petrosoft_india/common/widgets/textfield.dart';


import 'package:uuid/uuid.dart';

import '../../AdatsoftOwner/adat_owner_home_page.dart';
import '../../AdatsoftSeller/farmer_home_page.dart';
import '../../Classes/converter.dart';

import '../../common_home_page.dart';
import '../../main.dart';
import 'custom_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final user = TextEditingController();
final pass = TextEditingController();
final apiUrl = TextEditingController();
final clientCode = TextEditingController();
final custCode = TextEditingController();

class _LoginPageState extends State<LoginPage> {
 // final _firebaseMessaging = FirebaseMessaging;
  GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormFieldState> mobileFormFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> usernameFormFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFormFieldKey = GlobalKey<FormFieldState>();
  final _otpController = TextEditingController();
  bool forgotPasswordUI=false;
  bool _obscureText=true;
  String messageTitle = "Empty";
  String notificationAlert = "alert";
  String? deviceToken;
  final formKey = GlobalKey<FormState>();
 /* Future handleStartUpLogic() async {
    PushNotificationService _pushNotificationService=PushNotificationService(_firebaseMessaging);
    await _pushNotificationService.initialise();
  }*/

  @override
  void initState() {
    // TODO: implement initState
   // handleStartUpLogic();

    if(UT.SPF!.getString("ExternalUserID") != null){
      clientCode.text = UT.SPF!.getString("ExternalUserID")!;
    }else{
      clientCode.text='';
    }
    //_firebaseMessaging.subscribeToTopic('all');
   //  _firebaseMessaging.deleteInstanceID();

    /*FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        deviceToken = token;
        UT.SPF!.setString("deviceId", deviceToken!);
        print('fcm token: $token');
      });
      // Print the Token in Console
    });*/
    super.initState();
  }
  bool isChecked = false;
  dynamic currentSelectedYear;

  List<dynamic> fy=[
    {
      "id":"23",
      "value":"2022-2023",
    },
    {
      "id":"24",
      "value":"2023-2024",
    },
    {
      "id":"25",
      "value":"2024-2025",
    },
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    apiUrl.text = UT.APIURL!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 60,),
              Image.asset(
                PetroSoftAssetFiles.login,
                width: double.infinity,
                height: 200,
              ),
              const SizedBox(height: 20,),
              App.Type=="PetroOperator"? Padding(
                padding: const EdgeInsets.only(left: 20,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PETRO DSR LOGIN",
                      style: StyleForApp.text_style_bold_16_black,
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>selectAppType()));
                        },
                        child: Text("Change Login?",style: StyleForApp.text_style_bold_13_indigo,)),
                    SizedBox(width: 3,)
                  ],
                ),
              ):App.Type=="PetroBuyer"? Padding(
                padding: const EdgeInsets.only(left: 20,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                     // width: 100,
                      child: Text(
                        "PETRO TRANSPORT LOGIN",
                        style: StyleForApp.text_style_bold_16_black,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>selectAppType()));
                        },
                        child: Text("Change Login?",style: StyleForApp.text_style_bold_13_indigo,)),
                    SizedBox(width: 3,)
                  ],
                ),
              ):App.Type=="PetroOwner"? Padding(
                padding: const EdgeInsets.only(left: 20,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PETRO OWNER LOGIN",
                      style: StyleForApp.text_style_bold_16_black,
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>selectAppType()));
                      },
                        child: Text("Change Login?",style: StyleForApp.text_style_bold_13_indigo,)),
                    SizedBox(width: 3,)
                  ],
                ),
              ):App.Type=="PetroManager"? Padding(
                padding: const EdgeInsets.only(left: 20,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "PETRO Manager LOGIN",
                      style: StyleForApp.text_style_bold_16_black,
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>selectAppType()));
                        },
                        child: Text("Change Login?",style: StyleForApp.text_style_bold_13_indigo,)),
                    SizedBox(width: 3,)
                  ],
                ),
              ):App.Type=="AdatSeller"? Padding(
                padding: const EdgeInsets.only(left: 20,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ADAT FARMER LOGIN",
                      style: StyleForApp.text_style_bold_16_black,
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>selectAppType()));
                        },
                        child: Text("Change Login?",style: StyleForApp.text_style_bold_13_indigo,)),
                    SizedBox(width: 3,)
                  ],
                ),
              ):App.Type=="AdatOwner"? Padding(
                padding: const EdgeInsets.only(left: 20,bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ADAT OWNER LOGIN",
                      style: StyleForApp.text_style_bold_16_black,
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>selectAppType()));
                        },
                        child: Text("Change Login?",style: StyleForApp.text_style_bold_13_indigo,)),
                    SizedBox(width: 3,)
                  ],
                ),
              ):Container(),

              Padding(
                padding: const EdgeInsets.only(right: 10,left: 10),
                child: PetroSoftTextField.mobileTextFieldPrefixIcon(clientCode,"Mobile Number",PetroSoftAssetFiles.phone),),
              Padding(
                padding: const EdgeInsets.only(right: 10,left: 10),
                child: PetroSoftTextField.textFieldPrefixIcon(user,"Username",PetroSoftAssetFiles.person),),
              Padding(
                padding: const EdgeInsets.only(right: 10,left: 10),
                child: Row(

               children: [
                 Padding(
                     padding: EdgeInsets.all(7),
                     child:Container(
                       child: Image.asset(
                         PetroSoftAssetFiles.password,
                         height: 20,width: 20,),)),
                 Expanded(
                   child: Container(
                     child: Column(
                       children: [
                         TextField(
                           obscureText: _obscureText,
                           controller: pass,
                           decoration: InputDecoration(
                             isDense: true,
                             labelText: "Password",
                             suffixIcon: GestureDetector(
                               onTap: () {
                                 setState(() {
                                   _obscureText = !_obscureText;
                                 });
                               },
                               child: Icon(
                                 _obscureText ? Icons.visibility_off : Icons.visibility,size: 20,
                               ),
                             ),
                             border: InputBorder.none,
                           ),
                           minLines: 1,
                           maxLines: 1,
                         ),
                         Divider(
                           height: 1,
                           thickness: 1,
                           color: ColorConverter.hexToColor("#8F8F8F"),
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
                ),
               // PetroSoftTextField.textFieldSufixIcon(pass,"Password",PetroSoftAssetFiles.password, Icons.visibility_off),
              ),

              Container(
                padding: const EdgeInsets.all(5.0),
                child: FormField(
                  builder: (FormFieldState<String> state) {
                    return Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(7),
                            child:Container(
                              child: Image.asset(
                                PetroSoftAssetFiles.calender,color: Colors.grey,
                                height: 20,width: 20,),)),
                        Expanded(
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              // prefixIcon: Icon(Icons.language, color: ColorsForApp.lightGrayColor,size: 20,),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: const Text(" Select Financial year",),
                                value: currentSelectedYear,
                                icon: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: const Icon(
                                    Icons.arrow_drop_down_circle,
                                    size: 20,color: Colors.grey,
                                  ),
                                ),
                                isDense: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    currentSelectedYear = newValue;
                                    print("selected id--->${currentSelectedYear}");
                                    UT.SPF!.setString("FinancialYear", currentSelectedYear);
                                  });
                                },
                                items: fy.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value["id"],
                                    child: Text(value["value"]),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 10,left: 10,top: 10),
                        child: Text('Forgot Password?', style: StyleForApp.text_style_normal_14)),
                  ],
                ),
              ),
              const SizedBox(height: 10,),

              CommonButtonForAllApp(
                  onPressed: () async {
                    if(clientCode.text.isEmpty){
                      Fluttertoast.showToast(msg: "Please enter mobile");
                    }else if(user.text.isEmpty){
                      Fluttertoast.showToast(msg: "Please enter username");
                    }else if(pass.text.isEmpty){
                      Fluttertoast.showToast(msg: "Please enter password");
                    }else if(currentSelectedYear==null||currentSelectedYear==""){
                      Fluttertoast.showToast(msg: "Please select financial year");
                    }else if(clientCode.text.contains(" ")||clientCode.text.length<10){
                      Fluttertoast.showToast(msg: "Invalid Mobile Number");
                    }else{
                      DialogBuilder(context).showLoadingIndicator('');
                      login(context);
                    }

                  },
                  title: 'Login',
                  backgroundColor: ColorsForApp.buttonColors
              ),
              const SizedBox(height: 10,),
             //UI of google login for time being its commented
             /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 20,top: 20),
                      child: Divider(height: 5,thickness: 1,color: ColorConverter.hexToColor("#8F8F8F"),),
                    ),
                  ),
                  Text('OR',style: StyleForApp.text_style_normal_16_grey,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 20,top: 20),
                      child: Divider(height: 5,thickness: 1,color: ColorConverter.hexToColor("#8F8F8F"),),
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0,bottom: 10.0,),
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    //olor: ColorConverter.hexToColor("#8FD9D9D9"),
                    decoration: BoxDecoration(
                        gradient:  LinearGradient(
                          colors: [Colors.grey.shade500, Colors.grey.shade500],
                          //colors: [ColorsForApp.googleButtonColors, ColorsForApp.googleButtonColors,],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(5, 5),
                            blurRadius: 10,
                          )
                        ],
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: GestureDetector(
                      onTap: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            PetroSoftAssetFiles.google,
                            height: 20,width: 20,
                          ),
                          const SizedBox(width: 10,),
                          const Text(
                            "Login with Google",
                            style: TextStyle(fontSize:16,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
              ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New to PetroSoft? '),
                  GestureDetector(
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> const RegistrationForm()));
                    },
                    child: Text('Sing Up',
                      style: StyleForApp.text_style_normal_14_blue,),
                  ),
                ],
              ),
              const SizedBox(height: 10,)
            ],
          ),
        ),
      ),

    );
    return Scaffold(
      body: SafeArea(
        child: Container(
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
              ):App.Type=="PetroManager"?LinearGradient(
                  colors: [
                    ColorsForApp.appThemeColorPetroManager,
                    ColorsForApp.appThemeColorPetroManager
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
                  top: 40,
                  left: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      App.Type=="PetroOperator"|| App.Type=="PetroBuyer"||
                          App.Type=="PetroOwner"|| App.Type=="PetroManager"?Container(
                        alignment: Alignment.center,
                        child:Image.asset("assets/Petrosoft.png"),
                        height: size.height * 0.10,
                      ):Container(
                        alignment: Alignment.center,
                        child:Image.asset("assets/adat.png"),
                        height: size.height * 0.10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  App.Type=="PetroOperator"?const Text(
                                    "PETRO DSR LOGIN",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18
                                    ),
                                    textAlign: TextAlign.center,
                                  ):App.Type=="PetroBuyer"?const Text(
                                    "PETRO TRANSPORT LOGIN",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18
                                    ),
                                    textAlign: TextAlign.center,
                                  ):App.Type=="PetroOwner"?const Text(
                                    "PETRO OWNER LOGIN",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18
                                    ),
                                    textAlign: TextAlign.center,
                                  ):App.Type=="PetroManager"?const Text(
                                    "PETRO Manager LOGIN",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18
                                    ),
                                    textAlign: TextAlign.center,
                                  ):App.Type=="AdatSeller"?const Text(
                                    "ADAT FARMER LOGIN",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18
                                    ),
                                    textAlign: TextAlign.center,
                                  ):App.Type=="AdatOwner"?const Text(
                                    "ADAT OWNER LOGIN",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18
                                    ),
                                    textAlign: TextAlign.center,
                                  ):Container(),
                                ],
                              )
                          ),
                        ],
                      )
                    ],
                  )
              ),
              Positioned(
                  top: 140, right: 0, bottom: 0, child: Container(
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
              Positioned(top: 150, right: 0, bottom: 0, child: Container(
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
                child: Container(
                 // alignment: Alignment.center,
                //  color: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                  child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                           forgotPasswordUI==false? Column(
                              children: [
                              /*  SizedBox(
                                  height: 65,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      controller: apiUrl,
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                          hintText: "Server API",
                                          labelText: "Server API"//labelText: "Server API",
                                        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                      ),
                                    ),
                                  ),
                                ),*/
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextFormField(
                                    controller: clientCode,
                                    key: mobileFormFieldKey,
                                    textInputAction: TextInputAction.next,
                                    maxLength: 10,
                                    keyboardType: TextInputType.number,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (input) {
                                      if(input==" "||input!.isEmpty){
                                        return "Mobile number is required";
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (term) {
                                      mobileFormFieldKey.currentState!.validate();
                                    },
                                    onChanged: (term) {
                                      mobileFormFieldKey.currentState!.validate();
                                    },
                                    decoration: const InputDecoration(
                                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                        hintText: "Mobile",
                                        counterText: "",
                                        labelText: "Mobile"
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextFormField(
                                    controller: user,
                                    key: usernameFormFieldKey,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                        hintText: "Enter Username",
                                        labelText: "Username"),
                                    onFieldSubmitted: (term) {
                                      usernameFormFieldKey.currentState!.validate();
                                    },
                                    onChanged: (term) {
                                      usernameFormFieldKey.currentState!.validate();
                                    },
                                    validator: (input){
                                      if(input==""||input!.isEmpty){
                                        return "Username is required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextFormField(
                                    controller: pass,
                                    key: passwordFormFieldKey,
                                    textInputAction: TextInputAction.done,
                                    decoration: const InputDecoration(
                                      //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                        hintText: "Enter Password",
                                        labelText: "Password"
                                      //labelText: "Password"
                                    ),
                                    obscureText: true,
                                    onFieldSubmitted: (term) {
                                      passwordFormFieldKey.currentState!.validate();
                                    },
                                    onChanged: (term) {
                                      passwordFormFieldKey.currentState!.validate();
                                    },
                                    validator: (input){
                                      if(input==""||input!.isEmpty){
                                        return "Password is required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                 Container(
                                   padding: const EdgeInsets.all(5.0),
                                   child: FormField(
                                     builder: (FormFieldState<String> state) {
                                       return InputDecorator(
                                         decoration: const InputDecoration(
                                         // prefixIcon: Icon(Icons.language, color: ColorsForApp.lightGrayColor,size: 20,),
                                        ),
                                         child: DropdownButtonHideUnderline(
                                           child: DropdownButton(
                                             hint: const Text("Select Financial year",style: TextStyle(fontSize: 14.0),),
                                            value: currentSelectedYear,
                                             isDense: true,
                                             onChanged: (newValue) {
                                               setState(() {
                                                 currentSelectedYear = newValue;
                                                 print("selected id--->${currentSelectedYear}");
                                                 UT.SPF!.setString("FinancialYear", currentSelectedYear);
                                               });
                                             },
                                             items: fy.map((value) {
                                               return DropdownMenuItem<String>(
                                                 value: value["id"],
                                                 child: Text(value["value"]),
                                               );
                                             }).toList(),
                                           ),
                                         ),
                                       );
                                     },
                                   ),
                                 ),
                              ],
                            ):Column(
                             children: [
                             /*  SizedBox(
                                 height: 65,
                                 child: Padding(
                                   padding: const EdgeInsets.all(5.0),
                                   child: TextFormField(
                                     controller: apiUrl,
                                     readOnly: true,
                                     decoration: const InputDecoration(
                                         hintText: "Server API",
                                         labelText: "Server API"//labelText: "Server API",
                                       // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                     ),
                                   ),
                                 ),
                               ),*/
                               Padding(
                                 padding: const EdgeInsets.all(5.0),
                                 child: TextFormField(
                                   controller: clientCode,
                                   key: mobileFormFieldKey,
                                   maxLength: 10,
                                   keyboardType: TextInputType.number,
                                   autovalidateMode: AutovalidateMode.onUserInteraction,
                                   validator: (input) {
                                     if(input==" "||input!.isEmpty){
                                       return "Mobile number is required";
                                     }
                                     return null;
                                   },
                                   onFieldSubmitted: (term) {
                                     mobileFormFieldKey.currentState!.validate();
                                   },
                                   onChanged: (term) {
                                     mobileFormFieldKey.currentState!.validate();
                                   },
                                   decoration: const InputDecoration(
                                     // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                                       hintText: "Mobile",
                                       counterText: "",
                                       labelText: "Mobile"
                                   ),
                                 ),
                               ),
                             ],
                           ),
                            const SizedBox(height: 5,),
                            App.Type=="AdatOwner"?Container(): InkWell(
                              onTap: (){

                                  setState(() {
                                    forgotPasswordUI=true;
                                    if (clientCode.text.isNotEmpty) {
                                      DialogBuilder(context).showLoadingIndicator('');
                                      getOTP();
                                    }else{
                                      Fluttertoast.showToast(msg: 'Please enter mobile');
                                    }

                                  });


                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children:  [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Forgot password?",style: StyleForApp.text_style_bold_12_black,),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 10,),

                            const SizedBox(height: 10,),
                             Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  alignment: Alignment.centerRight,
                                 // margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      UT.APIURL=apiUrl.text;
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationForm()));
                                    },
                                    child: const Text(
                                      "New user? Register Here",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )

                          ],
                        ),
                      )
                  ),
                ),
              )),

            ],
          ),
        ),
      ),
    );
  }

  login(ctx) async {
    var res = false;
    UT.APIURL = apiUrl.text;
    UT.CustCodeAmt = clientCode.text;
    UT.ExternalUserID = clientCode.text;
    var _user = user.text;
    var _pass = pass.text;
    var TokenHistid = const Uuid().v1();
    var _url = UT.APIURL! +
        "api/Login/CheckPass?loginid=" +
        _user +
        "&password=" +
        _pass +
        "&test=" +
        TokenHistid;
    //_url = "http://jsonplaceholder.typicode.com/photos";
   // print("LOGIN-->$url");
    var data = await UT.apiStr(_url);
    print("LOGIN RESS-->$data");
    if (data == "Success") {
      //pr.hide();
      UT.SPF!.setString("password", pass.text);
      UT.SPF!.setString("loginId", user.text);
      UT.SPF!.setString("loginName", user.text);
      UT.SPF!.setString("APIURL", apiUrl.text);
      UT.SPF!.setString("CustCodeAmt", custCode.text);
      UT.SPF!.setString("ExternalUserID", clientCode.text);

      _url = UT.APIURL! + 'api/getClientUserLink?appType='+App.Type;
    //call new method
      data = await UT.apiDt(_url);
      var message=data[0]['clientuserlinkid'];
      if(message==""){
        DialogBuilder(context).hideOpenDialog();
        UT.m["isFirmAvailable"] = "NO";
        Fluttertoast.showToast(msg: "Firm not found");
      }
      else{
        //TODO : set year start date & end date according to Financial current year

        int cy=int.parse(currentSelectedYear.toString())-1;
        print(cy);
        String apiStartDate = "20${cy.toString()}-04-01";
        String apiYearEndDate = "20$currentSelectedYear-03-31";
        UT.yearStartDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(apiStartDate));
        UT.yearEndDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(apiYearEndDate));
        print('yearStartDate-->${UT.yearStartDate}');
        print('yearEndDate-->${ UT.yearEndDate}');
        UT.m["isFirmAvailable"] = "YES";
        UT.FirmData = data;
        sendDeviceId(ctx);
      }
    } else {
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Invalid id");
    }
    return false;
  }
  sendDeviceId(ctx) async {
    print(UT.SPF!.getString("deviceId"));
    var userInfo= Map();
    userInfo["mobile"]=clientCode.text;
    userInfo["userinfoid"]=UT.FirmData[0]["userinfoid"];
    userInfo["deviceid"]=UT.SPF!.getString("deviceId");
    var _url = UT.APIURL! + "api/ChkRegisterMobile/Post?tblname=u";
    List userInfoList=[];
    userInfoList.add(userInfo);
    var Result = await UT.save2Db(_url, userInfoList);
    DialogBuilder(context).hideOpenDialog();
    print('UT.FirmData---->${UT.FirmData}');
    if(UT.FirmData.length==1){
      UpdateSelect(context,0);
    }else{
      Navigator.push(ctx, MaterialPageRoute(builder: (context) => FirmSelection()));
    }

  }

  UpdateSelect(ctx,index) async {
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
      Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(
          builder: (BuildContext context) => const Dashboard(),
        ), (route) => false,
      );/*Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(
          builder: (BuildContext context) => const PetrosoftOperatorHomePage(),
        ), (route) => false,
      );*/
    }else  if(App.Type=="PetroBuyer"){
      Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(
          builder: (BuildContext context) => const Dashboard(),
        ), (route) => false,
      );/*  Navigator.pushAndRemoveUntil(
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
      );
    }else if(App.Type=="PetroManager"){
      Navigator.pushAndRemoveUntil(
        ctx,
        MaterialPageRoute(
          builder: (BuildContext context) => const Dashboard(),
        ), (route) => false,
      );/*Navigator.pushAndRemoveUntil(
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

  //TODO :call for otp
  getOTP() async {
    UT.ExternalUserID=clientCode.text;
    UT.CustCodeAmt="000";
   //TODO: API for get otp
    var _url = UT.APIURL! +
        "api/ChkRegisterMobile/ChngPassOTP?mobileNo1=" +clientCode.text;
     var data = await UT.apiStr(_url);

    print("OTP RESS-->$data");
    if(data!=null){
      DialogBuilder(context).hideOpenDialog();
      if(data.length==6){
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Enter OTP'),
                content: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,

                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel',
                        style: TextStyle(
                          color: Colors.green,
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Ok',
                        style: TextStyle(
                          color: Colors.green,
                        )),
                    onPressed: () {
                      if(data!=_otpController.text){
                        Fluttertoast.showToast(msg: 'Invalid OTP');
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ResetPassword()));
                      }

                    },
                  ),
                ],
              );
            });
      }else if(data=="0"){
        Fluttertoast.showToast(msg: "something went wrong");

      }else{
        Fluttertoast.showToast(msg: "$data");
      }

    }


  }
}