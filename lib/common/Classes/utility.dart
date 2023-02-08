import 'dart:convert';
import 'dart:io';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/petrosoft_owner_app_theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
class App{
        static String Type = "PetroOperator"; //Petrosoft DSR app1
    // static String Type = "PetroBuyer"; //Petrosoft Transporter app2
   // static String Type = "PetroOwner"; //Petrosoft Business app3
  // static String Type = "PetroManager"; //Petrosoft Business app3


   //static String Type = "AdatSeller"; //AdatSoft Farmer
  // static String Type = "AdatOwner"; //AdatSoft Business
  //static String Type = "AdatOperator";//AdatSoft Operator
  //static String Type = "AdatBuyer"; //AdatSoft Customer


}
class UT {

  //New Testing url
  // static String? APIURL = "https://adatpetroAPI.ekatm.co.in/";

   //For New Testing
  // static String? ReportAPIURL="https://adatpetromvc.ekatm.co.in/";


  // static String? APIURL="http://192.168.1.84/AdatAPIProj/";

  //static String? APIURL="http://192.168.1.72:81/";



   //For Release : use this api while uploading app on play store
   static String? ReportAPIURL="https://adatsoft.vritti.co.in/";

  //Final Release
   static String? APIURL = "https://adatpetroapi.vritti.co.in/";

  static List<CameraDescription> cameras = [];
  static SharedPreferences? SPF;
  static String? CustCodeAmt = "";
  static String? userName = "";
  static String? clientAcName = "";
  static String? ExternalUserID = "";
  static String? loginId = "";
  static String? loginName = "";

  static String? TempDBId = "";
  static String? TokenHistid = "";
  static String? shop_no = "";
  static String? curyear = "";
  static String? firm_name = "";
  static String? ModuleNo = "";
  static String? ClientUserLinkId = "";
  static String? ClientAcno = "";
  static var FirmData;
  static var mastData;
  static var itemList;
  static var m=  Map();
  static var setUpData;
  static var acSetData;
  static var couponData;
  static List customerList=[];
  static List<Map<String, dynamic>> imageList=[];
  static List receiptDepositList=[];
  static List cashDepositeList=[];
  static DateTime? displayDate;
  static String? yearStartDate;
  static String? yearEndDate;
  static String? userInFoId;
  static Color? ownerAppColor=const Color(0xFF414C58);
  static const Color BACKGROUND_COLOR = Color(0xFFF7F2ED);
  static Color? PetroOperatorAppColor=const Color(0xFF2F4697);
  static Color? PetrosoftCustomerAppLightColor=Colors.purple.shade900;
  static Color? PetrosoftCustomerDarkColor=Colors.purple.shade900;
  static Color? adatSoftSellerAppColor=const Color(0xFF355E3B);
  static TextStyle PetrosoftCustomerNoDataStyle = TextStyle(fontSize:14,color:ColorsForApp.appThemeColorPetroCustomer,fontWeight: FontWeight.bold);
  static TextStyle PetroOperatorNoDataStyle = TextStyle(fontSize:14,color:ColorsForApp.icon_operator,fontWeight: FontWeight.bold);
  static TextStyle PetroOwnerNoDataStyle = TextStyle(fontSize:14,color:ColorsForApp.appThemePetroOwner,fontWeight: FontWeight.bold);
  static TextStyle adatSoftSellerNoDataStyle = TextStyle(fontSize:15,color:UT.adatSoftSellerAppColor,fontWeight: FontWeight.bold);
  static bool downloading = false;
  static  var progress = "";
  static  var path = "No Data";
  static var savedPath;
  static var platformVersion = "Unknown";
  static  var _onPressed;
  static  late Directory externalDir;

  static apiDt(url) async {
    var _url = url;
    TempDBId = await zgetTempDBId();
    var token = "${TempDBId!}|${CustCodeAmt!}|${ExternalUserID!}";
    var res = await http.get(Uri.parse(_url), headers: {
      'Authorization': 'Bearer $token',
    });
    var data = jsonDecode(res.body);
    print(res.statusCode);
    return data;
  }
  static save2Db(url,jdata) async {
    var _url = url;
    TempDBId = await zgetTempDBId();
    var token = "${TempDBId!}|${CustCodeAmt!}|${ExternalUserID!}";

    var res = await http.post(Uri.parse(_url),
        headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json; charset=UTF-8',},
    body: jsonEncode(jdata),
       );
    return res.body;
  }
   static saveImages2Server(id,base64) async {
     TempDBId = await zgetTempDBId();
     var token = "${TempDBId!}|${CustCodeAmt!}|${ExternalUserID!}";
     String jsonData='''{"data":"$base64"}''';
     print("jsonData-->$jsonData");
     var imageApiUrl = "${UT.APIURL!}api/Image/Post?id=$id";
     print("imageApi_url-->$imageApiUrl");
     var res = await http.post(Uri.parse(imageApiUrl),
       headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json; charset=UTF-8',},
       body: jsonData,
     );
     return res.body;
   }
  static apiStr(url) async {
    var _url = url;
    TempDBId = await zgetTempDBId();
    var token = "${TempDBId!}|${CustCodeAmt!}|${ExternalUserID!}";
    var res = await http.get(Uri.parse(_url), headers: {
      'Authorization': 'Bearer $token',
    });
    var data = res.body;
    return data;
  }
  static zgetTempDBId() async {
    var url = '${APIURL!}/api/GenerateToken?userid=${TokenHistid!}';
    var res = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer VrittiSoltionLTD|$CustCodeAmt|$ExternalUserID',
    });
    var _id = res.body.toString();
    return _id;
  }
  static setEnv() async {
    APIURL = UT.SPF!.getString("APIURL");
    loginId = UT.SPF!.getString("loginId");
    loginName = UT.SPF!.getString("loginName");
    var password = UT.SPF!.getString("password");
    var currentYear= UT.SPF!.getString("FinancialYear");
    TokenHistid = const Uuid().v1();
    var _url = "${UT.APIURL!}api/Login/CheckPass?loginid=${loginId!}&password=${password!}&test=${TokenHistid!}";
    String? _str = UT.SPF!.getString("FirmData");
    FirmData = jsonDecode(_str!);
    int? i = UT.SPF!.getInt("firmno");
    ModuleNo = FirmData[i]["moduleno"];
    shop_no = FirmData[i]["clientshopno"];
    firm_name = FirmData[i]["clientfirmname"];
    curyear = currentYear;
    ClientUserLinkId = FirmData[i]["clientuserlinkId"];
    ClientAcno = FirmData[i]["clientacno"];
    CustCodeAmt = FirmData[i]["clientid"];
    userName = FirmData[i]["username"];
    clientAcName = FirmData[i]["clientacname"];
    userInFoId = FirmData[i]["userinfoid"];
    UT.SPF!.setString("CustCodeAmt", CustCodeAmt!);
    ExternalUserID = UT.SPF!.getString("ExternalUserID");
    var data = await UT.apiStr(_url);
    loadSetup();
    loadAcSet();

    //TODO : set year start date & end date according to Financial current year
    int cy=int.parse(currentYear.toString())-1;
    print(cy);
    String apiStartDate = "20${cy.toString()}-04-01";
    String apiYearEndDate = "20$currentYear-03-31";
      yearStartDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(apiStartDate));
      yearEndDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(apiYearEndDate));
      print('yearStartDate-->$yearStartDate');
      print('yearEndDate-->$yearEndDate');

  }
  static loadSetup() async {
    var _url="${UT.APIURL!}api/GetSetup/Get?shop=${shop_no!}";
    setUpData= await apiDt(_url);

  }
  static loadAcSet() async {
    acSetData= await apiDt("${UT.APIURL!}api/AdatAcSet/AcSet?year=${curyear!}&shop=${shop_no!}");
  }
  static Setup(key) {
    key = key.toLowerCase();
    var val = "";
    for(int i=0;i<setUpData.length;i++){
      var sKey=setUpData[i]["s_key"].toString().toLowerCase();
      if(sKey==key){
        val=setUpData[i]["s_defaultvalue"];
        return val;
      }
    }
    return val;
  }
  static AC(key) {
    key = key.toLowerCase();
    var val = "";
    for(int i=0;i<acSetData.length;i++){
     // print("acSetData-->$acSetData");
      var sKey=acSetData[i]["acvariable"].toString().toLowerCase();
      if(sKey==key){
        val=acSetData[i]["accode"];
        return val;
      }
    }
    return val;
  }

  static dateConverter(DateTime? selectedDate){
    String sendDateToApi = "${selectedDate!.year.toString()}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')}";
   return sendDateToApi;
  }
  static displayDateConverter(DateTime? selectedDate){
    String sendDateToApi = "${selectedDate!.day.toString().padLeft(2,"0")}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.year.toString().padLeft(2,'0')}";
    return sendDateToApi;
  }
  static yearMonthDateConverter(DateTime? selectedDate){
   // String sendDateToApi = "${selectedDate!.day.toString().padLeft(2,"0")}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.year.toString().padLeft(2,'0')}";
    String sendDateToApi = "${selectedDate!.year.toString().padLeft(2,"0")}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')}";
    return sendDateToApi;
  }
  static dateMonthYearFormat(String date){
   String formateddate= DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
   return formateddate;
  }
  static yearMonthDateFormat(String date){
    print("date-->$date");
    String formateddate= DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    return formateddate;
  }
  static yearMonthDate(String date){
    print("date-->$date");
    DateTime  formateddate= DateFormat("yyyy-MM-dd").parse(date);
    return formateddate;
  }
   //Todo:Functions for AdatOwner APP
   static Flt(f1) {
     var nn = double.parse(f1.toString().trim());
     return nn;
   }
   static convertIntoDouble(f1) {
     double nn = double.parse(f1.toString().trim());
     String value=nn.toStringAsFixed(2);
     return value;
   }
   static RepAllCol(data, Keycol, Val) {
     for (var i = 0; i < data.length; i++) {
       data[i][Keycol] = Val;
     }
     return data;
   }
   static String GetRow(tbl, col, val,name) {
     var resp = "";
     var colVal = "";
     for(int i=0;i<tbl.length;i++){
       colVal = tbl[i][col];
       if (colVal.trim() == val) {
         resp = tbl[i][name];
       }
     }
     return resp;
   }
   static getrowindxItm(date1, item_code,item) {
     var row = -1;
    // var dt = Date(date1);
    // var dt = DateTime.parse(date1);
     var dt = date1;

     item_code = item_code.trim();

     for (var i = 0; i < item.length; i++) {
       var dt1 =  DateTime.parse(item[i]["itemvalid"]);
       var dt2 =  DateTime.parse(item[i]["validfrom"]);
       if (item[i]["item_code"].trim() == item_code && dt1.compareTo(dt)>0 && dt2.compareTo(dt)<0) {
        int checkd1= dt1.compareTo(dt);
         row = i;
       }
     }
     return row;
   }

   static getrowindex(dt, colname, value) {
     var col = colname.split(',');
     var val = value.split(',');
     var row = -1;
     if (dt.length == 0) { return row; }

     for (int i = 0; i < dt.length; i++) {
     int  MC = 0;
       for (int j = 0; j < col.length ; j++) {
         if (dt[i][col[j]].toString().trim() == val[j].toString().trim()) {
           MC++;

         }
         else {
           MC--;
         }
       }
       if (MC == col.length) {
         row = i;
         break;
       }
     }
     return row;
   }

  static Future<bool> ChkDtLoc(date1) async {
     if (date1 == "") {
       return false;
     }
     var dtlk = [];
     //dtlk = GetDt(OpenTable("dtlk") + Setup("curyear") + Firm("shop"), "isdeleted<>'Y' and lk_date = '" + date1 + "' order by lk_date", false, "");

     var _url = UT.APIURL! +
         "api/Security/GetDTLK?year=" +
         UT.curyear.toString() +
         "&shop="+UT.shop_no.toString()+"&Where=lk_date = '" + date1 + "' order by lk_date&Addrow=false";
     var  response = await UT.apiStr(_url);
     dtlk=json.decode(response);
     if (dtlk.isNotEmpty)
     {
       if (dtlk[0]["locked"] == "1")
       {
         Fluttertoast.showToast( msg: "Date is Locked.");
         return true;
       }
     }
     else
     {
       //dtlk = GetDt(OpenTable("dtlk") + Setup("curyear") + Firm("shop"), "isdeleted<>'Y' and lk_date = '" + date1 + "' order by lk_date", true, "");


       var _url = UT.APIURL! +
           "api/Security/GetDTLK?year=" +
           UT.curyear.toString() +
           "&shop="+UT.shop_no.toString()+"&Where=lk_date = '" + date1 + "' order by lk_date&Addrow=true";
       dtlk = await UT.apiStr(_url);

       var dt = dtlk[dtlk.length - 1];
       dt["lk_date"] = date1;
       dtlk = [];
       dtlk.add(dt);
       // var res = Save2DB(OpenTable("dtlk") + Setup("curyear") + Firm("shop"), "lk_date", dtlk);

     }
     return false;
   }

   static chkDate(dateStr) {
     if (dateStr == '') {
       return;
     }
     var minDate =  DateTime.parse(UT.yearStartDate!);
     var maxDate =  DateTime.parse(UT.yearEndDate!);

    // var date =  DateTime(yymmdd(dateStr));
     /*if (dateStr>= minDate && dateStr <= maxDate) {
       return true;
     }*/
     if (dateStr.compareTo(minDate)>=0 && dateStr.compareTo(maxDate)<= 0) {
       return true;
     }
     else {
       Fluttertoast.showToast(msg: 'Invalid Date.');
       return false;
     }
   }
  //owner app icons
  static String rateMaster="assets/brown_color_icons/rateMaster.png";
  static String pendingOrders="assets/brown_color_icons/time.png";
  static String shiftSale="assets/brown_color_icons/shiftSale.png";
  static String customerReceipt="assets/brown_color_icons/bill.png";
  static String paymentEntry="assets/brown_color_icons/paymentEntry.png";
  static String reports="assets/brown_color_icons/reports.png";

  static converter(objectToConvert) async {
    try {
      if (objectToConvert is String) {
        objectToConvert = double.parse(objectToConvert);
      }

      print("CLAIM_AMOUNT CON METHOD TRY-> $objectToConvert");

      String convertedObject = '0';
     /* if (objectToConvert >= 100000) {
        if (objectToConvert is int) {
          double tempObj = objectToConvert.toDouble();
          var tempObj2 = tempObj / 100000;
          var f = NumberFormat("###,##0.000", "en_US");
          convertedObject = f.format(double.parse(tempObj2.toString()));
          print("CONVERTER VALUE IS INT 1 -> $convertedObject");
        } else if (objectToConvert is double) {
          var tempObj = objectToConvert / 100000;
          var f = NumberFormat("###,##0.000", "en_US");
          convertedObject = f.format(double.parse(tempObj.toString()));
          print("CONVERTER VALUE IS DOUBLE 1 -> $convertedObject");
        } else {
          var tempObj = objectToConvert / 100000;
          var f = NumberFormat("###,##0.000", "en_US");
          convertedObject = f.format(double.parse(tempObj.toString()));
          print("CONVERTER VALUE IS OTHER 1 -> $convertedObject");
        }
      } else*/ {
        if (objectToConvert is int) {
          double tempObj = objectToConvert.toDouble();
          var f = NumberFormat("#,##,##0.000", "en_US");
          convertedObject = f.format(double.parse(tempObj.toString()));
          print("CONVERTER VALUE IS INT 2 -> $convertedObject");
        } else if (objectToConvert is double) {
          var f = NumberFormat("#,##,##0.000", "en_US");
          convertedObject = f.format(double.parse(objectToConvert.toString()));
          print("CONVERTER VALUE IS DOUBLE 2 -> $convertedObject");
        } else {
          var f = NumberFormat("#,##,##0.000", "en_US");
          convertedObject = f.format(double.parse(objectToConvert.toString()));
          print("CONVERTER VALUE IS OTHER 2 -> $convertedObject");
        }
      }

      print("CONVERT_METHOD_");
      print(convertedObject);
      return convertedObject.substring(0, convertedObject.length - 1);
    } on Exception catch (e) {
      print("CLAIM_AMOUNT CON METHOD CATCH-> $e");
    }
  }


}
class CommonWidget{
 static Widget circularIndicator(){
   return App.Type=="PetroOperator"?
      CircularProgressIndicator(
      valueColor:AlwaysStoppedAnimation<Color>(ColorsForApp.appThemeColorPetroOperator)
    ):App.Type=="PetroBuyer"?
    CircularProgressIndicator(
       valueColor:AlwaysStoppedAnimation<Color>(ColorsForApp.appThemeColorPetroCustomer)
   ):App.Type=="PetroOwner"?
    CircularProgressIndicator(
       valueColor:AlwaysStoppedAnimation<Color>(ColorsForApp.appThemePetroOwner))
   :App.Type=="PetroManager"?
    CircularProgressIndicator(
       valueColor:AlwaysStoppedAnimation<Color>(PetroOwnerAppTheme.blueColor)):
   const CircularProgressIndicator(
       valueColor:AlwaysStoppedAnimation<Color>(Colors.black));
  }
}
class CommonAppBarText extends StatelessWidget{
  const CommonAppBarText({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Text(title,style:  PetroSoftTextStyle.style17White,);
  }
}

class CommonButtonForAllApp extends StatelessWidget {
  CommonButtonForAllApp({Key? key, required this.onPressed,required this.title, required this.backgroundColor}) : super(key: key);
  final GestureTapCallback onPressed;
  final String title;
  var backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0,right: 15.0,bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,height: 45,
            decoration: BoxDecoration(
                gradient:  LinearGradient(colors: [ColorConverter.hexToColor("#00487C"), ColorConverter.hexToColor("#00487C")],
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
            child: TextButton(
              onPressed: onPressed,
              child:  Text(
                title,
                style: const TextStyle(fontSize:16,color: Colors.white),
              ),
            ),
          ),
        ],
      )
    );
  }
}

