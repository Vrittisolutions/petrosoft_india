import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:petrosoft_india/common/widgets/login.dart';
import 'package:petrosoft_india/common/widgets/reset_password.dart';
import 'package:petrosoft_india/common/widgets/textfield.dart';

import '../../Classes/colors.dart';
import '../../Classes/styleforapp.dart';
import '../Classes/utility.dart';


TextEditingController  mobileController =TextEditingController();
class ForgotPassword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ForgotPasswordState();
  }

}
class ForgotPasswordState extends State<ForgotPassword>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                height: 200,
                child: Image.asset(PetroSoftAssetFiles.forgotPasswordBg),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 20,bottom: 10),
              child: Text(
                "Forgot Password",
                style: StyleForApp.text_style_bold_20_black,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20,left: 20,top: 10),
              child: PetroSoftTextField.mobileTextFieldPrefixIcon(mobileController,"Mobile Number",PetroSoftAssetFiles.phone),),
            const SizedBox(height: 40),
            CommonButtonForAllApp(
            title: 'Get OTP',
            onPressed: (){
              if(mobileController.text.contains(" ")||mobileController.text.length<10) {
                Fluttertoast.showToast(msg: "Invalid Mobile Number");
              }else{
                DialogBuilder(context).showLoadingIndicator("");
                getOTP();
              }

            }, backgroundColor: null,
          )
          ],
        ),
      ),
    );
  }
  getOTP() async {
    UT.ExternalUserID=mobileController.text;
    //TODO: API for get otp
    var _url = UT.APIURL! +
        "api/ChkRegisterMobile/ChngPassOTP?mobileNo1=" +mobileController.text;
    var data = await UT.apiStr(_url);

    print("OTP RESS-->$data");
    if(data!=null){
      DialogBuilder(context).hideOpenDialog();
      if(data.length==6){
        return  Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPScreen(otp: data)));
       // return OTPScreen(otp: data,);
      }else if(data=="0"){
        Fluttertoast.showToast(msg: "something went wrong");

      }else{
        Fluttertoast.showToast(msg: "$data");
      }

    }


  }

}


class OTPScreen extends StatefulWidget {
   final String otp;
  const OTPScreen({Key? key, required this.otp}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  TextEditingController firmIDController = TextEditingController();

  late List<TextStyle?> otpTextStyles;
  late List<TextEditingController?> controls;
  int numberOfFields = 6;
  bool clearText = false;
  String _verificationCode = '';
  String get otp=>widget.otp;
  var resendOtp;
  bool isResendClick=false;

  @override
  Widget build(BuildContext context) {
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
              Container(
                height: 250,
                //color: Colors.red,
                /* child: Image.asset(
                  "assets/login.png",
                  width: double.infinity,
                  height: 250,
                ),*/
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 20,bottom: 10),
                child: Text('Enter OTP',style: StyleForApp.text_style_bold_20_black,),),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 20,bottom: 10),
                child: Text('A 6-digit OTP is send to your mobile number ${mobileController.text}',style: StyleForApp.text_style_normal_14_black),
              ),
              OtpTextField(
                decoration: const InputDecoration(
                  filled: true, //<-- SEE HERE
                  fillColor: Colors.deepPurpleAccent, //<-- SEE HERE
                ),
                numberOfFields: numberOfFields,
                borderColor: const Color(0xFF512DA8),
                focusedBorderColor: Colors.red,
                clearText: clearText,
                showFieldAsBox: true,
                textStyle: Theme.of(context).textTheme.subtitle2,
                onCodeChanged: (String value) {
                  //Handle each value
                },
                handleControllers: (controllers) {
                  //get all textFields controller, if needed
                  controls = controllers;
                },
                onSubmit: (String verificationCode) {
                  //set clear text to clear text from all fields
                  //setState(() {
                    _verificationCode=verificationCode;
                    print("_verificationCode-->$_verificationCode");
                   // clearText = true;
                  //});
                }, // end onSubmit
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  isResendClick=true;
                  DialogBuilder(context).showLoadingIndicator("");
                  resendOTP();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,bottom: 10),
                  child: Row(
                    children: [
                      Text("Didn't get OTP?",style: StyleForApp.text_style_normal_14_black),
                      const SizedBox(width: 5,),
                      Image.asset(PetroSoftAssetFiles.resend,height: 20,width: 20,),
                      const SizedBox(width: 5,),
                      Text('Resend OTP',
                        style: StyleForApp.text_style_bold_14_blue,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CommonButtonForAllApp(
          onPressed: () async {
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));

            if(isResendClick==true){
              print("resend");
              UT.ExternalUserID=mobileController.text;
              print(UT.ExternalUserID);
             if(_verificationCode==""||_verificationCode==null){
               Fluttertoast.showToast(msg: 'Please enter OTP');
             }else if(resendOtp!=_verificationCode){
                Fluttertoast.showToast(msg: 'Invalid OTP');
              }else{
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ResetPassword()));
              }
            }else{
              UT.ExternalUserID=mobileController.text;
              print(UT.ExternalUserID);
              if(_verificationCode==""||_verificationCode==null){
                Fluttertoast.showToast(msg: 'Please enter OTP');
              }else if(otp!=_verificationCode){
                Fluttertoast.showToast(msg: 'Invalid OTP');
              }else{
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ResetPassword()));
              }
            }
          },
          title: 'Confirm',
          backgroundColor: ColorsForApp.buttonColors
      ),
    );
  }

  Future resendOTP() async{
    _verificationCode='';
    controls=[];

    var _url = UT.APIURL! +
        "api/ChkRegisterMobile?mobileNo=" +mobileController.text;

    var otpData = await UT.apiStr(_url);
    print("Resend OTP URL -->$_url");
    print("Resend OTP-->$otpData");

    if(otpData!=null){
      var splitOTp=otpData.toString().split("|");
      resendOtp=splitOTp[0];
      DialogBuilder(context).hideOpenDialog();
    }
    return resendOtp;
  }

}