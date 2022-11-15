import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:petrosoft_india/AppTheme/assets_files.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:petrosoft_india/common/widgets/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petrosoft_india/common/widgets/textfield.dart';
import 'package:uuid/uuid.dart';

final _firmIDController = TextEditingController();
final _shopNoController = TextEditingController(text: "01");
final _userName = TextEditingController();
final _userID = TextEditingController();
final _mobileNo = TextEditingController();
final _password = TextEditingController();
final _confirmPass= TextEditingController();
final _email = TextEditingController();
final _address = TextEditingController();
final _landmark = TextEditingController();
final _city = TextEditingController();
final _taluka = TextEditingController();
final _district = TextEditingController();
final _otpController = TextEditingController();
class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}
class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  DateTime selectedDate = DateTime.now();
  bool isLoading=false;
  final GlobalKey<FormFieldState> userNameFormFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> firmIdFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> userIDFormFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> mobileFormFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFormFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> confirmPassFormFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> shopNoFormFieldKey = GlobalKey<FormFieldState>();

  bool _validate = false;
  bool _obscureText=true;
  bool _obscureTextConfirmpass=true;
  var  _dropdownError;
  var otpData;
 final firmIdKey= GlobalKey<FormFieldState>();


  dynamic _currentSelectedValue;
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
                //color: Colors.red,
                child: Image.asset(
                  PetroSoftAssetFiles.signUp,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20,),
              Padding(padding: EdgeInsets.only(left: 20,bottom: 10),
                child: Text('Sing Up',style: StyleForApp.text_style_bold_20_black,),),
              Padding(
                padding: const EdgeInsets.only(right: 10,left: 10),
                child: PetroSoftTextField.textFieldPrefixIcon(_firmIDController,"Firm ID",PetroSoftAssetFiles.email,)),
              Padding(
                padding: const EdgeInsets.only(right: 10,left: 10),
                child: PetroSoftTextField.textFieldPrefixIcon(_userName,"Username",PetroSoftAssetFiles.person),),
              Padding(
                padding: const EdgeInsets.only(right: 10,left: 10),
                child: PetroSoftTextField.mobileTextFieldPrefixIcon(_mobileNo,"Mobile Number",PetroSoftAssetFiles.phone),),
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
                )




                //PetroSoftTextField.textFieldSufixIcon(pass,"Password",AssetFiles.password, Icons.visibility_off),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10,left: 10),
                child: PetroSoftTextField.textFieldPrefixIcon(_confirmPass,"Email",PetroSoftAssetFiles.email),),
              const SizedBox(height: 10,),
              CommonButtonForAllApp(
                  onPressed: () async {
                    if(_firmIDController.text.isEmpty){
                      Fluttertoast.showToast(msg: "Please enter firm code");
                    }else if(_userName.text.isEmpty){
                      Fluttertoast.showToast(msg: "Please enter username");
                    }else if(_mobileNo.text.isEmpty){
                      Fluttertoast.showToast(msg: "Please enter mobile no");
                    }else if(_password.text.isEmpty){
                      Fluttertoast.showToast(msg: "Please enter password");
                    }else{
                      registerAPI();
                    }

                  },
                  title: 'Sing Up',
                  backgroundColor: ColorsForApp.buttonColors
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have account? '),
                  GestureDetector(
                    onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
                    },
                    child: Text('Login',
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
    return  Scaffold(
      appBar:  AppBar(
        backgroundColor:
             App.Type=="PetroOwner"? ColorsForApp.appThemePetroOwner
            :App.Type=="PetroOperator"?ColorsForApp.appThemeColorPetroOperator
             :App.Type=="PetroManager"?ColorsForApp.appThemeColorPetroManager
            :App.Type=="PetroBuyer"?ColorsForApp.appThemeColorPetroCustomer
            :App.Type=="AdatSeller"? UT.adatSoftSellerAppColor!
            :App.Type=="AdatOwner"?ColorsForApp.appThemeColorAdatOwner
            :Colors.purple.shade900,
        automaticallyImplyLeading: false,
        title:  Text(App.Type=="PetroBuyer"?"Buyer Registration":
                     App.Type=="PetroOperator"?"Operator Registration":
                     App.Type=="PetroOwner"?"Owner Registration":
                     App.Type=="PetroManager"?"Manager Registration":
                     App.Type=="AdatSeller"?"Farmer Registration":"Adat Owner Registration"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:  Column(
              children: <Widget>[
                //clientIDField(),
                firmID(),
                userNameField(),
               // userIDField(),
                mobileField(),
                passwordField(),
                confirmPasswordField(),
                const SizedBox(height: 10,),
                const Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                emailField(),
               /* addressField(),
                landmarkField(),
                cityField(),
                talukaField(),
                districtField(),*/
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: isLoading==true? SizedBox(
          height:40,child: Center(child: CircularProgressIndicator(
        color:  App.Type=="PetroOwner"? ColorsForApp.appThemePetroOwner
            :App.Type=="PetroOperator"?ColorsForApp.appThemeColorPetroOperator
            :App.Type=="PetroBuyer"?ColorsForApp.appThemeColorPetroCustomer
            :App.Type=="AdatSeller"? UT.adatSoftSellerAppColor!
            :App.Type=="AdatOwner"?ColorsForApp.appThemeColorAdatOwner
            :Colors.purple.shade900,
      ),))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40,
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    App.Type=="PetroOwner"? ColorsForApp.appThemePetroOwner
                        :App.Type=="PetroOperator"?ColorsForApp.appThemeColorPetroOperator
                        :App.Type=="PetroBuyer"?ColorsForApp.appThemeColorPetroCustomer
                        :App.Type=="AdatSeller"? UT.adatSoftSellerAppColor!
                        :App.Type=="AdatOwner"?ColorsForApp.appThemeColorAdatOwner
                        :Colors.purple.shade900
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                            color: App.Type=="PetroOwner"? ColorsForApp.appThemePetroOwner
                                :App.Type=="PetroOperator"?ColorsForApp.appThemeColorPetroOperator
                                :App.Type=="PetroBuyer"?ColorsForApp.appThemeColorPetroCustomer
                                :App.Type=="AdatSeller"? UT.adatSoftSellerAppColor!
                                :App.Type=="AdatOwner"?ColorsForApp.appThemeColorAdatOwner
                                :Colors.purple.shade900
                        )
                    )
                )
            ),
            onPressed: (){
              if (_formKey.currentState!.validate()) {
                registerAPI();
              }
            },
            child: Text('Register', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
  Widget userNameField(){
    return  ListTile(
      leading:  Icon(Icons.person,color: Colors.grey.shade600),
      title:  TextFormField(
        controller: _userName,
        key: userNameFormFieldKey,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: const InputDecoration(
          hintText: "User Name",
          labelText: "User Name",
          //contentPadding: EdgeInsets.all(15.0),
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Username is empty';
          }
          return null;
        },
        onFieldSubmitted: (term) {
          userNameFormFieldKey.currentState!.validate();
          },
        onChanged: (term) {
          userNameFormFieldKey.currentState!.validate();
        },
        //validator: FormValidator().validateEmail,
      ),
    );
  }
  Widget mobileField(){
    return  ListTile(
      leading:  Icon(Icons.call,color: Colors.grey.shade600),
      title:  TextFormField(
        controller: _mobileNo,
        key: mobileFormFieldKey,
        maxLength: 10,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: const InputDecoration(
          counterText: '',
          hintText: "Mobile Number",
          labelText: "Mobile Number",
          //contentPadding: EdgeInsets.all(15.0),
          /*border: OutlineInputBorder(borderRadius: BorderRadius.circular(0.0)),
          filled: true,
          fillColor: Colors.grey[200],*/
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Mobile number is empty';
          }else  if ( text.length<10) {
            return 'Invalid Mobile number';
          }
          return null;
        },
        onFieldSubmitted: (term) {
          mobileFormFieldKey.currentState!.validate();
        },
        onChanged: (term) {
          mobileFormFieldKey.currentState!.validate();
        },
        //validator: FormValidator().validateEmail,
      ),
    );
  }
  Widget userIDField(){
    return  ListTile(
      leading:  Icon(Icons.location_city,color: Colors.grey.shade600),
      title:  TextFormField(
        controller: _userID,
        key: userIDFormFieldKey,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: const InputDecoration(
          hintText: "User ID",
           labelText: "User ID",
          //contentPadding: EdgeInsets.all(15.0),
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'User ID is empty';
          }
          return null;
        },
        onFieldSubmitted: (term) {
          userIDFormFieldKey.currentState!.validate();
        },
        onChanged: (term) {
          userIDFormFieldKey.currentState!.validate();
        },
        // validator: FormValidator().validatePassword(value),
      ),
    );
  }
  Widget passwordField(){
    return ListTile(
      leading:  Icon(Icons.lock,color: Colors.grey.shade600),
      title:  TextFormField(
        controller: _password,
        key: passwordFormFieldKey,
        keyboardType: TextInputType.text,
        autofocus: false,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: "Password",
           labelText: "Password",
          //contentPadding: EdgeInsets.all(15.0),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
        validator: (value) {
         // String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
          //RegExp regExp = new RegExp(patttern);
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
      ),
    );
  }
  Widget confirmPasswordField(){
    return ListTile(
      leading:  Icon(Icons.lock,color: Colors.grey.shade600),
      title:  TextFormField(
        controller: _confirmPass,
        key: confirmPassFormFieldKey,
        keyboardType: TextInputType.text,
        autofocus: false,
        obscureText: _obscureTextConfirmpass,
        decoration: InputDecoration(
          hintText: "Re-Type Password",
           labelText: "Re-Type Password",
          // contentPadding: EdgeInsets.all(15.0),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureTextConfirmpass = !_obscureTextConfirmpass;
              });
            },
            child: Icon(
              _obscureTextConfirmpass ? Icons.visibility : Icons.visibility_off,
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
      ),
    );
  }
  Widget userTypeField(){
    return  Container(
        padding: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        //height: 48,
        child: Row(
          children: [
             SizedBox(
              width: 62,
              child: Center(child: Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Icon(Icons.arrow_drop_down_circle,color: Colors.purple.shade900),
              )),
            ),
            Expanded(
              child: DropdownButton<String>(
                underline: Container( height: 1, color: Colors.purple.shade900),
                isExpanded: true,
                focusColor:Colors.white,
                value: _currentSelectedValue,
                //elevation: 5,
                style: TextStyle(color: Colors.white),
                iconEnabledColor:Colors.purple.shade900,
                items: <String>[
                  'Operator',
                  'Seller',
                  'Buyer',
                  'Owner'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,style: const TextStyle(color: Colors.black),),
                  );
                }).toList(),
                hint:const Text(
                  "Select user type",
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 14,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _currentSelectedValue = value;
                    _dropdownError=null;
                  });
                },
              ),
            ),
          ],
        )
    );
  }
  Widget firmID(){
    return ListTile(
      leading:Icon(Icons.perm_identity,color: Colors.grey.shade600),
       title: TextFormField(
         controller: _firmIDController,
         key: firmIdFieldKey,
         keyboardType: TextInputType.text,
         autofocus: false,
         decoration: InputDecoration(
           //prefixIcon:Icon(Icons.person) ,
           hintText: "Firm ID",
           labelText: "Firm ID",
           //contentPadding: EdgeInsets.all(10.0),
         ),
         validator: (text) {
           if (text == null || text.isEmpty) {
             return 'Firm ID is empty';
           }
           return null;
         },
         onFieldSubmitted: (term) {
           firmIdFieldKey.currentState!.validate();
         },
         onChanged: (term) {
           firmIdFieldKey.currentState!.validate();
         },
         //validator: FormValidator().validateEmail,
       ),
    );
  }


  Widget clientIDField(){
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        //mainAxisAlignment:MainAxisAlignment.spaceBetween ,
        children: [
          SizedBox(
            width: 140,
            child:  TextFormField(
              controller: _firmIDController,
              key: firmIdFieldKey,
              keyboardType: TextInputType.text,
              autofocus: false,
              decoration:  InputDecoration(
                icon: Icon(Icons.perm_identity,color: Colors.grey.shade600),
                //prefixIcon:Icon(Icons.person) ,
                hintText: "Firm ID",
                 labelText: "Firm ID",
                //contentPadding: EdgeInsets.all(10.0),
              ),
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Firm ID is empty';
                }
                return null;
              },
              onFieldSubmitted: (term) {
                firmIdFieldKey.currentState!.validate();
              },
              onChanged: (term) {
                firmIdFieldKey.currentState!.validate();
              },
              //validator: FormValidator().validateEmail,
            ),
          ),

          /*SizedBox(
            width: 140,
            child:  TextFormField(
              controller: _shopNoController,
              key: shopNoFormFieldKey,
              keyboardType: TextInputType.number,
              autofocus: false,
              decoration:  InputDecoration(
                hintText: "Shop No",
                labelText: "Shop No",
                icon: Icon(Icons.shopping_bag_rounded,color:Colors.grey.shade600),
                // prefixIcon:Icon(Icons.person) ,
                // labelText: "00",
                //contentPadding: EdgeInsets.all(15.0),
              ),
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Shop No is empty';
                }
                return null;
              },
              onFieldSubmitted: (term) {
                shopNoFormFieldKey.currentState!.validate();
              },
              onChanged: (term) {
                shopNoFormFieldKey.currentState!.validate();
              },
              //validator: FormValidator().validateEmail,
            ),
          ),*/
        ],
      ),
    );
  }

  Widget emailField(){
    return  ListTile(
      leading:  Icon(Icons.email,color:Colors.grey.shade600),
      title:  TextFormField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: const InputDecoration(
          hintText: "Email",
          labelText: "Email",
          //contentPadding: EdgeInsets.all(15.0),
        ),
       // validator: FormValidator().validateEmail,
      ),
    );
  }
  Widget addressField(){
    return  ListTile(
      leading:  Icon(Icons.location_city,color:Colors.grey.shade600),
      title:  TextFormField(
        controller: _address,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: const InputDecoration(
          hintText: "Address",
          labelText: "Address",
          //contentPadding: EdgeInsets.all(15.0),
        ),
        //validator: FormValidator().validateEmail,
      ),
    );
  }
  Widget landmarkField(){
    return  ListTile(
      leading:  Icon(Icons.location_city,color: Colors.grey.shade600),
      title:  TextFormField(
        controller: _landmark,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: const InputDecoration(
          hintText: "Landmark",
          labelText: "Landmark",
          //contentPadding: EdgeInsets.all(15.0),
        ),
        //validator: FormValidator().validateEmail,
      ),
    );
  }
  Widget talukaField(){
    return  ListTile(
      leading:  Icon(Icons.location_city,color: Colors.grey.shade600),
      title:  TextFormField(
        controller: _taluka,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: const InputDecoration(
          hintText: "Taluka",
          labelText: "Taluka",
          //contentPadding: EdgeInsets.all(15.0),

        ),
        //validator: FormValidator().validateEmail,
      ),
    );
  }
  Widget cityField(){
    return  ListTile(
      leading:  Icon(Icons.location_city,color: Colors.grey.shade600),
      title:  TextFormField(
        controller: _city,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: const InputDecoration(
          hintText: "City",
          labelText: "City",
          //contentPadding: EdgeInsets.all(15.0),
        ),
        //validator: FormValidator().validateEmail,
      ),
    );
  }
  Widget districtField(){
    return  ListTile(
      leading:  Icon(Icons.location_city,color: Colors.grey.shade600),
      title:  TextFormField(
        controller: _district,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: const InputDecoration(
          hintText: "District",
          labelText: "District",
          //contentPadding: EdgeInsets.all(15.0),
        ),
        //validator: FormValidator().validateEmail,
      ),
    );
  }

  String _validatePassword(String value) {
    var ret;
    String patttern = r'(^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{6,}$)';
    RegExp regExp =  RegExp(patttern);
    if (value.isEmpty) {
      ret= "Password is Required";
    } else if (value.length < 8) {
      ret= "Password must minimum eight characters";
    } else if (!regExp.hasMatch(value)) {
      ret= "Password at least one uppercase letter, one lowercase letter and one number";
    }else if(regExp.hasMatch(value)==true){
      ret='';
    }
    return ret;
  }
  registerAPI() async {

    UT.ExternalUserID=_mobileNo.text;
    UT.CustCodeAmt="000";
    var _url = UT.APIURL! +
        "api/ChkRegisterMobile?mobileNo=" +_mobileNo.text;

     otpData = await UT.apiStr(_url);
    print("OTP URL -->$_url");
    print("OTP-->$otpData");
    if(otpData!=null){
     if(otpData.length==6){
        return  Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPScreen(otp: otpData)));
       /* return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Enter OTP'),
                content: Container(
                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,

                  ),
                ),
                actions: <Widget>[
                   TextButton(
                    child: Text('Resend OTP',
                        style: TextStyle(
                          color: Colors.green,
                        )),
                     onPressed: () {
                       resendOTP();
                     },
                  ),
                   TextButton(
                    child: Text('Ok',
                        style: TextStyle(
                          color: Colors.green,
                        )),
                    onPressed: () {
                      if(otpData!=_otpController.text){
                        Fluttertoast.showToast(msg: 'Invalid OTP');
                      }else{
                        saveUserData();
                      }
                    },
                  ),
                ],
              );
            });*/
      }else{
        Fluttertoast.showToast(msg: "Mobile number  already registered.Please use other number");
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
  bool isResendClick=false;
  var otpData;


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
                child: Text('A 6-digit OTP is send to your mobile number ${_mobileNo.text}',style: StyleForApp.text_style_normal_14_black),
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
                 // setState(() {
                    _verificationCode=verificationCode;
                   // clearText = true;
                 // });
                }, // end onSubmit
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  if(_verificationCode==""||_verificationCode==null){
                    Fluttertoast.showToast(msg: 'Please enter OTP');
                  }else{
                    isResendClick=true;
                    DialogBuilder(context).showLoadingIndicator("");
                    resendOTP();
                  }

                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20,bottom: 10),
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

            if(isResendClick==true){
              if(otpData!=_verificationCode){
                Fluttertoast.showToast(msg: 'Invalid OTP');
              }else{
                DialogBuilder(context).showLoadingIndicator("");
                saveUserData();
              }
            }else{
              if(_verificationCode==""||_verificationCode==null){
                Fluttertoast.showToast(msg: 'Please enter OTP');
              } if(widget.otp!=_verificationCode){
                Fluttertoast.showToast(msg: 'Invalid OTP');
              }else{
                DialogBuilder(context).showLoadingIndicator("");
                saveUserData();
              }
            }


          },
          title: 'Confirm',
          backgroundColor: ColorsForApp.buttonColors
      ),
    );
  }
  saveUserData() async {
    var userInfo= Map();
    var clientInfo= Map();
    UT.SPF!.setString("ExternalUserID", _mobileNo.text);
    UT.SPF!.setString("CustCodeAmt",_firmIDController.text);
    userInfo["userinfoid"]=Uuid().v1();
    userInfo["mobile"]=_mobileNo.text;
    _userID.text=_userName.text.toString();
    userInfo["userid"]=_userID.text;
    userInfo["password"]=_password.text;
    //_currentSelectedValue;
    userInfo["username"]=_userName.text;
    userInfo["email"]=_email.text;
    userInfo["add1"]=_address.text;
    userInfo["add2"]=_landmark.text;
    userInfo["taluka"]=_taluka.text;
    userInfo["dist"]=_district.text;
    userInfo["city"]=_city.text;
    userInfo["isdeleted"]="N";
    userInfo["usertype"]= App.Type;

    clientInfo["clientuserlinkid"]=Uuid().v1();
    clientInfo["userinfoid"]=userInfo["userinfoid"];
    clientInfo["usertype"]= App.Type;
    clientInfo["username"]=_userName.text;
    clientInfo["clientid"]=_firmIDController.text;
    clientInfo["clientshopno"]=_shopNoController.text;
    List userInfoList=[];
    List clientInfoList=[];
    userInfoList.add(userInfo);
    clientInfoList.add(clientInfo);

    var _url = UT.APIURL! +
        "api/ChkRegisterMobile/Post?tblname=u";
    var Result = await UT.save2Db(_url, userInfoList);
    var _url1 = UT.APIURL! +
        "api/ChkRegisterMobile/Post?tblname=c";
    var Result1 = await UT.save2Db(_url1, clientInfoList);
    if(Result=="ok"&&Result1=="ok"){
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: 'Registration successfully done');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }else{
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: 'Something went wrong please try again!');
    }
  }
  resendOTP() async{
   _verificationCode='';
   controls=[];
    var _url = UT.APIURL! +
        "api/ChkRegisterMobile?mobileNo=" +_mobileNo.text;

    otpData = await UT.apiStr(_url);
    print("Resend OTP URL -->$_url");
    print("Resend OTP-->$otpData");

    if(otpData!=null){
      if(otpData.length==6){

      }
    }
  }
}