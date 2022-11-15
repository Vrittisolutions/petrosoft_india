import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftCustomer/customer_home_page.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class AddFirm extends StatefulWidget {
  @override
  _AddFirmState createState() =>  _AddFirmState();
}
class _AddFirmState extends State<AddFirm> {
  final GlobalKey<FormState> _formKey =  GlobalKey();
  DateTime selectedDate = DateTime.now();
  bool isLoading=false;
  final GlobalKey<FormFieldState> userNameFormFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> firmIdFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> shopNoFormFieldKey = GlobalKey<FormFieldState>();
  final _firmIDController = TextEditingController();
  final _shopNoController = TextEditingController(text: "01");
  final _userName = TextEditingController();
  final _mobileNo = TextEditingController();
  final _otpController = TextEditingController();
  final firmIdKey= GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop:  ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.orange[150],
        appBar: AppBar(
         // automaticallyImplyLeading: true,
          titleSpacing: 0.0,
          leading: IconButton(
            onPressed: (){
              //Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PetrosoftCustomerHomePage()));
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("Account Registration"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  bodyUI(),
                ],
              ),
            ),
          ),
        ),
        /*bottomNavigationBar: isLoading==true?Container(
            height:40,child: Center(child: CircularProgressIndicator(),)):Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(colors: [ColorsForApp.app_theme_color, ColorsForApp.icon],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    ),
      borderRadius: BorderRadius.circular(20.0),
    ),
            height: 40,
            child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                      )
                  )
              ),
              onPressed: (){
                if (_formKey.currentState!.validate()) {
                  //registerAPI();
                  saveUserData();
                }
              },
              child: Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),*/
      ),
    );
  }
  Future<bool?> _willPopCallback()async{
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return  const PetrosoftCustomerHomePage();
    }));
    // return true if the route to be popped
  }

  Widget bodyUI(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          paymentField(),
          saveButton()
        ],
      ),
    );
  }

  Widget paymentField(){
    return  Container(
      height: MediaQuery.of(context).size.height*0.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //const SizedBox(height: 30),
            clientIDField(),
            shopNo(),
            userNameField(),


          ],
        ),
      ),
    );
  }
  Widget shopNo(){
    return Padding(
        padding: const EdgeInsets.all(8.0),
    child:SizedBox(
    height: 45,
        child:TextFormField(
        controller: _shopNoController,
        key: shopNoFormFieldKey,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          //hintText: "Narration", hintStyle: StyleForApp.text_style_normal_14_black,
          labelText: "Shop No",
            labelStyle: StyleForApp.text_style_normal_14_black
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
    ),
    );
  }
  Widget userNameField(){
    return  Padding(
        padding: const EdgeInsets.all(8.0),
    child:SizedBox(
    height: 45,
      //leading: const Icon(Icons.person,color: Colors.blue),
      child:TextFormField(
        controller: _userName,
        key: userNameFormFieldKey,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          //hintText: "Narration", hintStyle: StyleForApp.text_style_normal_14_black,
          labelText: "Username",
            labelStyle: StyleForApp.text_style_normal_14_black,
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
    ),
    );
  }




  Widget clientIDField(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:SizedBox(
        height: 45,
      //leading: Icon(Icons.perm_identity,color: Colors.blue),
      child:  TextFormField(
        controller: _firmIDController,
        key: firmIdFieldKey,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          //hintText: "Narration", hintStyle: StyleForApp.text_style_normal_14_black,
          labelText: "Firm ID",
            labelStyle: StyleForApp.text_style_normal_14_black
          //contentPadding: EdgeInsets.all(15.0),
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
    );
  }

  Widget saveButton(){
    return  SizedBox(
      width: 180,

      child: Padding(
          padding: const EdgeInsets.only(left: 16.0,right:16.0),
          child:CommonButtonForAllApp(
            onPressed: (){
              saveData();
            },
            title: "Submit",
            backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
          )
      ),
    );
  }
  registerAPI() async {
    setState(() {
      isLoading=true;
    });
    UT.ExternalUserID=_mobileNo.text;
    UT.CustCodeAmt="000";
    var _url = UT.APIURL! +
        "api/ChkRegisterMobile?mobileNo=" +_mobileNo.text;
    var data = await UT.apiStr(_url);
    if(data!=null){
      setState(() {
        isLoading=false;
      });
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
                        saveUserData();
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
  saveUserData() async {
   var clientInfo= Map();
   UT.SPF!.setString("ExternalUserID", _mobileNo.text);
   UT.SPF!.setString("CustCodeAmt",_firmIDController.text);
   clientInfo["clientuserlinkid"]=Uuid().v1();
   clientInfo["userinfoid"]=UT.userInFoId;
   clientInfo["usertype"]= App.Type;
   clientInfo["username"]=_userName.text;
   clientInfo["clientid"]=_firmIDController.text;
   clientInfo["clientshopno"]=_shopNoController.text;
   List clientInfoList=[];
   clientInfoList.add(clientInfo);
   var _url1 = UT.APIURL! + "api/ChkRegisterMobile/Post?tblname=c";
   var Result1 = await UT.save2Db(_url1, clientInfoList);
   if(Result1=="ok"){
     Fluttertoast.showToast(msg: 'Your request has sent to approval ');
    var _url = UT.APIURL! + 'api/getClientUserLink?appType='+App.Type;
    var  data = await UT.apiDt(_url);
       UT.FirmData = data;
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PetrosoftCustomerHomePage()));
   }
  }

  void saveData() {}
}