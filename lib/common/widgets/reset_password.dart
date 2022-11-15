import 'dart:convert';
import 'package:petrosoft_india/AdatsoftOwner/adat_owner_home_page.dart';
import 'package:petrosoft_india/AdatsoftSeller/farmer_home_page.dart';
import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/customer_home_page.dart';
import 'package:petrosoft_india/PetrosoftOperator/operator_home_page.dart';
import 'package:petrosoft_india/common_home_page.dart';
import 'package:petrosoft_india/PetrosoftOwner/widget/background.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:petrosoft_india/common/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
 // final GlobalKey<FormState> _formKey = GlobalKey();
  final _formKey = GlobalKey < FormState > ();
  final GlobalKey<FormFieldState> passwordFormFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> confirmPassFormFieldKey = GlobalKey<FormFieldState>();
  final _password = TextEditingController();
  final _confirmPass= TextEditingController();
  bool _obscureText=true;
  bool obscureConfirmPass=true;
  @override
  void initState() {
    super.initState();
    print(UT.ExternalUserID);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
       autovalidateMode:AutovalidateMode.always ,
        child: SingleChildScrollView(
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
                  "Reset Password",
                  style: StyleForApp.text_style_bold_20_black,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
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
                            TextFormField(
                              obscureText: _obscureText,
                              controller: _password,
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
                              validator: (password) {
                               if(password!.isNotEmpty) {
                                 return null;
                               }else{
                                 return "Enter password";
                               }
                              },

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
              const SizedBox(height: 10),
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
                            TextFormField(
                              obscureText: obscureConfirmPass,
                              controller: _confirmPass,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: "Confirm Password",
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscureConfirmPass = !obscureConfirmPass;
                                    });
                                  },
                                  child: Icon(
                                    obscureConfirmPass ? Icons.visibility_off : Icons.visibility,size: 20,
                                  ),
                                ),
                                border: InputBorder.none,
                              ),
                              minLines: 1,
                              maxLines: 1,
                              validator: (password) {
                                if(password!.isNotEmpty) {
                                  return null;
                                }
                                else{
                                  return "Enter Confirm password";
                                }
                              },
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
              const SizedBox(height: 30),
              CommonButtonForAllApp(
                title: 'Save',
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                   if(_password.text==_confirmPass.text){
                     DialogBuilder(context).showLoadingIndicator("");
                     resetPasswordAPI();
                  }else{
                     Fluttertoast.showToast(msg: "Password and Confirm password must be same");
                   }
                  }


                }, backgroundColor: null,
              )
            ],
          ),
        ),
      )
    );
  }
  Widget passwordField(){
    return   TextFormField(
        controller: _password,
        key: passwordFormFieldKey,
        keyboardType: TextInputType.text,
        autofocus: false,
        obscureText: _obscureText,

        decoration: InputDecoration(
          enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                color:Colors.grey.shade600,

              )
          ),
          prefixIcon:Icon(Icons.lock,size:18,color: Colors.grey.shade600) ,
          hintText: "Password",
          //labelText: "Password",
          contentPadding: const EdgeInsets.all(15.0),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,size:18
            ),
          ),
        ),
        validator: (value) {
          if (value==""|| value!.isEmpty) {
            return "Password is Required";
          }/* else if (value.length < 8) {
            return"Password must minimum eight characters";
          } else if (!regExp.hasMatch(value)) {
            return "Password at least one uppercase letter, one lowercase letter and one number";
          }*/
          return null;
          // return _validatePassword(text!);
        },
        onFieldSubmitted: (term) {
          passwordFormFieldKey.currentState!.validate();
        },
        onChanged: (term) {
          passwordFormFieldKey.currentState!.validate();
        },
      );

  }
  Widget confirmPasswordField(){
    return TextFormField(
        controller: _confirmPass,
        key: confirmPassFormFieldKey,
        keyboardType: TextInputType.text,
        autofocus: false,
        obscureText: obscureConfirmPass,
        decoration: InputDecoration(
            enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                borderRadius: const BorderRadius.all(const Radius.circular(15)),
                borderSide: BorderSide(
                  color:Colors.grey.shade600,

                )
            ),
          prefixIcon:Icon(Icons.lock,color: Colors.grey.shade600,size:18) ,
          hintText: "Re-Type Password",
        //  labelText: "Re-Type Password",
          contentPadding: EdgeInsets.all(15.0),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                obscureConfirmPass = !obscureConfirmPass;
              });
            },
            child: Icon(
              obscureConfirmPass ? Icons.visibility : Icons.visibility_off,size:18
            ),
          ),
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Re-type Password is empty';
          }else if(text!=_password.text){
            return 'Re-type Password does not match with password entered';
          }
          return null;
        },
        onFieldSubmitted: (term) {
          confirmPassFormFieldKey.currentState!.validate();
        },
        onChanged: (term) {
          confirmPassFormFieldKey.currentState!.validate();
        },
      );

  }

  resetPasswordAPI() async {
    var _url = UT.APIURL! +
        "api/ChkRegisterMobile/ChngPass?mobileNo2=" +UT.ExternalUserID!+"&pass=${_password.text}";
    var data = await UT.apiStr(_url);
    print("Forgot API --->$_url");
    print("Forgot API RESS--->$data");
    if(data=="ok"){
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Password update successfully");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    }else{
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: data);
    }

  }
}

