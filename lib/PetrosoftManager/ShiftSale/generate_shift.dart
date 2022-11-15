
import 'dart:convert';

import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/converter.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/PetrosoftManager/petrosoft_manager_app_theme.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../common/Classes/utility.dart';

class GenerateShift extends StatefulWidget{
  const GenerateShift({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GenerateShiftState();

  }
}
class GenerateShiftState extends State<GenerateShift>{
  DateTime? currentDate = DateTime.now();
  String? displayDateFormat;
  dynamic _saleShift = "I";
  List<DropdownMenuItem<String>> items = [
    const DropdownMenuItem(
      child: Text("I"),
      value: "I",
    ),
    const  DropdownMenuItem(
      child: Text("II"),
      value: "II",
    ),
    const DropdownMenuItem(
      child: Text("III"),
      value: "III",
    ),
    const DropdownMenuItem(
      child: Text("IV"),
      value: "IV",
    ),
    const DropdownMenuItem(
      child: Text("V"),
      value: "V",
    ),
  ];
  List<InchargeModel> inchargeList=[];
  var inchargeName;
  final slipNoController=TextEditingController();
  String selectedIncharge='';
  String acno='';
  dynamic api;
  var PumpHd;
  var PumpBd=[];
  var itemmst;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    api=callAllAPI();
  }

  callAllAPI() async {
    getItemList();
   await shiftInChargeData();
   getMaxNo().then((value) async {
     slipNoController.text=value.toString().padLeft(5,'0');
     await validateSrNo();
   });
   return true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PetroManagerAppTheme.blueColor,
        shape:const RoundedRectangleBorder(
          borderRadius:  BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        titleSpacing: 0.0,
        title: const Text(
          'Generate New Shift ',
          style:
          TextStyle(fontSize: 17, color: Colors.white, letterSpacing: 0.53),
        ),
        actions: [
          InkWell(
              onTap: () async {
                openDatePicker(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(UT.displayDateConverter(currentDate),style: StyleForApp.text_style_bold_14_white),
                      ],
                    ),
                  ),
                ),))
        ],
      ),
     body: FutureBuilder(
       future: api,
       builder: (context,snapshot){
         if(snapshot.hasData){
           return SingleChildScrollView(
             keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 const SizedBox(height: 20,),

                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Card(
                     shape:const RoundedRectangleBorder(
                       borderRadius:  BorderRadius.all(
                         Radius.circular(10),
                       ),
                     ),
                     elevation: 5,
                     child: Column(
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             slipNo(),
                             Container(
                                 height: 40,
                                 width:100,
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(8.0),
                                     border: Border.all(color: Colors.black12)
                                 ),
                                 child: Padding(
                                   padding: const EdgeInsets.all(5.0),
                                   child: DropdownButton(
                                     isExpanded: true,
                                     items: items,
                                     underline: Container(),
                                     hint: const Text("Select Shift"),
                                     value: _saleShift,
                                     onChanged: (val) async {
                                       _saleShift = val.toString();
                                       setState(() {});
                                     },
                                   ),
                                 )),
                           ],
                         ),


                         shiftInCharge(),
                         const SizedBox(height: 20,),


                       ],
                     ),
                   ),
                 ),
                 const SizedBox(height: 20,),
                 CommonButtonForAllApp(onPressed: (){
                   newGenerateShift();
                  // generateShift();
                 },
                     title: "Generate shift",
                     backgroundColor: PetroManagerAppTheme.blueColor)
               ],
             ),
           );
         }else{
           return Center(child: CommonWidget.circularIndicator(),);
         }
       },
     ),
    );
  }
  Widget slipNo(){
    return  Padding(padding: const EdgeInsets.all(8.0),
        child:SizedBox(
          height: 40,
          width: 150,
          child: TextFormField(
            controller: slipNoController,
            keyboardType: TextInputType.text,
            autofocus: false,
            readOnly: true,
            enabled: false,
            decoration: InputDecoration(
              // icon: Icon(Icons.confirmation_num,color: Colors.blue,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
              hintText: "Slip No",
              labelText: "Slip No",
              labelStyle: StyleForApp.text_style_normal_13_black,
              contentPadding: const EdgeInsets.all(8.0),
            ),
          ),
        ));
  }
  Widget shiftInCharge(){
    return  Padding(
      padding: const EdgeInsets.only(left: 40.0,right: 35.0),
      child: Container(
          height: 40,
        //  width:200,
          decoration: BoxDecoration(//DecorationImage
            border: Border.all(
              color: Colors.black12,
              // width: 8,
            ), //Border.all
            borderRadius: BorderRadius.circular(10.0),),
          child: Autocomplete<InchargeModel>(
      optionsBuilder: (TextEditingValue value) {

        // When the field is empty
        if (value.text.isEmpty) {
          return [];
        }

        // The logic to find out which ones should appear
        return inchargeList
            .where((customer) => customer.name!.toLowerCase()
            .startsWith(value.text.toLowerCase())
        )
            .toList();
      },
      fieldViewBuilder: (
          BuildContext context,
          TextEditingController controller,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted
          ) {
        return TextField(
          controller: controller,
          focusNode: fieldFocusNode,
          decoration: InputDecoration(
            // prefixIcon: Icon(icon, color: ColorsForApp.light_gray_color,),
              counterText: "",
              iconColor: ColorsForApp.light_gray_color,
              isDense: true,
              contentPadding: EdgeInsets.all(8),

              //fillColor:Colors.grey.shade300,
              //border: OutlineInputBorder(),
              labelText: "Select Shift Incharge",
              labelStyle: TextStyle(fontSize: 13.0, color: ColorConverter.hexToColor("#838383")),
              border: InputBorder.none
          ),
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      },


      displayStringForOption: (InchargeModel option) => option.name!,

      onSelected: (value) {
        setState(() {
          selectedIncharge = value.name!;
          acno = value.acno!;
        });
      },
      ),
      ),
    );
  }
  Future<void> openDatePicker(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: currentDate!,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now()))!;
    if (picked != null && picked != currentDate) {
      setState(() {
        currentDate = picked;
      //  sendDateToApi = UT.dateConverter(selectedDate);

       // UT.m['saledate']=sendDateToApi;
      });
    }
  }

   newGenerateShift() async {

    int srno=int.parse(slipNoController.text)-1;

     var _url = UT.APIURL! +
         "api/PumpTrnEgenShift/CalcGetPumpHD?cyear="+UT.curyear!+
         "&cshop="+ UT.shop_no! +"&date=${UT.dateConverter(currentDate)}"+
         "&shift=${_saleShift}&srno=${srno.toString().padLeft(5,'0')}&csrno=${slipNoController.text.padLeft(5,'0')}&coll_code=${acno}&Addrow=true";
     print("In--$_url");
     var data = await UT.apiStr(_url);
     if(data=="ok"){
       DialogBuilder(context).hideOpenDialog();
       Fluttertoast.showToast(msg: "Save successfully");
       UT.m["slipNoOld"]=slipNoController.text;
       Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManagerShiftSalePage()));
     }else{
       Fluttertoast.showToast(msg: "$data");
     }
     print("data-->$data");

   }
   Future getMaxNo()async{
    var _url = UT.APIURL! +
        "api/PumpTrnE/GetMaxNo?curyear=" +
        UT.curyear! +
        "&shop="+UT.shop_no.toString();
    var data = await UT.apiStr(_url);
    UT.m["slipNoOld"]=data;
    return data;
  }
   getLastSlipNo(String srno) async {
    var _url = UT.APIURL! +
        "api/PumpTrnE/GetPumpHD?year=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&Where=srno%3D$srno&Addrow=true";
    print(_url);
    var data = await UT.apiDt(_url);
    print(data);
    for(int i=0;i<data.length;i++){
      setState(() {
        UT.m["slipNoOld"]=slipNoController.text;
        UT.m['shift']=data[i]["shift"];
        UT.m["saledate"]=data[i]["date"];
        DateTime date1 = DateTime.parse(data[i]["date"]);
        displayDateFormat=UT.displayDateConverter(date1);
      });

    }
 //   DialogBuilder(context).hideOpenDialog();
  }
    shiftInChargeData() async {
    var _url = UT.APIURL! +
        "api/AccountMaster/GetAcMast?curyear="+UT.curyear!+
        "&shop="+ UT.shop_no! +
        "&Where=left(acno,3)='" + UT.AC("Collect_AC") + "' and len(acno) >= 6";
    print("In--$_url");
    var data = await UT.apiStr(_url);
    List  decode=json.decode(data);
    inchargeList = decode.map((val) =>  InchargeModel.fromJson(val)).toList();
  }
   getItemList(){
      itemmst =UT.itemList;
   }

   validateSrNo() async {
    var _urlHD = UT.APIURL! +
        "api/PumpTrnE/GetPumpHD?year=" +
        UT.curyear! + "&shop=" + UT.shop_no! +
        "&Where=isdeleted%20<>%27Y%27%20and%20srno%3D${slipNoController.text}&Addrow=true";

    PumpHd = await UT.apiDt(_urlHD);
   // print("PumpHd-->$PumpHd");
    PumpHd = PumpHd[0];

    var _urlBD = UT.APIURL! +
        "api/PumpTrnE/GetPumpBD?cur_year=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&Where=isdeleted%20%3C%3E%27Y%27%20and%20srno%3D${slipNoController.text}&Addrow=true";
    print(_urlBD);
    PumpBd = await UT.apiDt(_urlBD);
    //print("PumpBd-->$PumpBd");

  }
   generateShift() async {
     if (selectedIncharge == null || selectedIncharge == "") {
       Fluttertoast.showToast(msg: "Please select shift Incharge.");
     } else {
       DialogBuilder(context).showLoadingIndicator('');
       if (!UT.chkDate(currentDate)) {
         return;
       }

       var _url = UT.APIURL! +
           "api/PumpTrnE/checkforShift?year4shiftchk=" +
           UT.curyear! +
           "&shop4shiftchk=" + UT.shop_no.toString() + "&shift2chk=" +
           _saleShift + "&date=${UT.dateConverter(currentDate)}";
       print("_url-->$_url");
       var resp = await UT.apiStr(_url);
       print("resp-->$resp");
       if (resp == 'success') {
         await getInfo();
        await saveDT();
       }
       else {
         DialogBuilder(context).hideOpenDialog();
         Fluttertoast.showToast(msg: "Shift already exist.");
       }
     }
   }
   getInfo() async {

     PumpHd['srno']=slipNoController.text;
     PumpHd['shift']=_saleShift;
     PumpHd['coll_code']=acno;
     PumpHd['date']=UT.dateConverter(currentDate);
     print(PumpHd);

    var _url1 = UT.APIURL! +
        "api/PumpTrnE/GetPumpBD?cur_year=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&Where=srno%3D${slipNoController.text}&Addrow=true";
    print(_url1);
   var pmbd4open = await UT.apiDt(_url1);

    var _url2 = UT.APIURL! +
        "api/PumpTrnE/GetPumpHD?year=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&Where=srno%3D${slipNoController.text}&Addrow=true";
    print(_url2);
    var pmhd4open = await UT.apiDt(_url2);
    PumpHd['pcashbal'] = pmhd4open[0]['cashtonext'];



    var _url3 = UT.APIURL! +
        "api/PumpTrnE/GetIMHS?year1=" +
        UT.curyear! +
        "&shop=" +
        UT.shop_no! +
        "&Where=location=%2702%27%20and%20trndate=%27${UT.dateConverter(currentDate)}%27%20and%20reason=%27${_saleShift}%27&Addrow=true";
    print("imhs url-$_url3");
    var imhs = await UT.apiDt(_url3);

    var _url4 = UT.APIURL! +
        "api/PriceListEnt/GetData?shop=" +
        UT.shop_no! +
        "&Where=isdeleted<>'Y' and%27${UT.dateConverter(currentDate)}%27between validfrom and validupto order by item_code";
    print(_url4);
    var plrate = await UT.apiDt(_url4);

    var _url5 = UT.APIURL! +
        "api/PumpLste/GetData?shop=" +
        UT.shop_no! +
        "&Where=isdeleted<>'Y' and (clos_date>=%27${UT.dateConverter(currentDate)}%27or reset_date = clos_date)  order by pump_seq , pump_no";
    print(_url5);
    var pumplist = await UT.apiDt(_url5);

    for (var i = 0; i < pumplist.length; i++) {
     // var newrow = JSON.parse(JSON.stringify(PumpBd[PumpBd.length - 1]));
      var newrow = {};
      if (PumpBd.length == 1 && (PumpBd[0]["no"] == "" ||PumpBd[0]["no"] == null)) {

         newrow["no"] = "001";
      }
      else {
        var srno = int.parse(PumpBd[PumpBd.length - 1]["no"]) + 1;
        newrow["no"] = srno.toString().padLeft(3, "0");
      }
      newrow["srno"] = PumpHd['srno'];
      newrow["date"] = UT.dateConverter(currentDate);
      newrow["shift"] = _saleShift;

      newrow["pump_no"] = pumplist[i]["pump_no"];
      newrow["item_code"] = pumplist[i]["pump_prod"];
      //27.06.2022
      var indx4st = UT.getrowindex(pmbd4open, "pump_no", newrow["pump_no"]);
      if (indx4st >= 0) {
        newrow["st_meter"] = pmbd4open[indx4st]["end_meter"];
        newrow["end_meter"] = pmbd4open[indx4st]["end_meter"];
      } else {
        newrow["st_meter"] = pumplist[i]["cur_read"];
        newrow["end_meter"] = pumplist[i]["cur_read"];
      }

      var plrow = UT.getrowindex(plrate, "item_code", pumplist[i]["pump_prod"]);
      if (plrow >= 0) {
        newrow["rate"] = plrate[plrow]["pl_rate"];
      }
      else {
        newrow["rate"] = 0;
      }
      newrow["petro_item"] = pumplist[i]["pump_prod"];
      newrow["petro_per"] = 100;
      newrow["pump_name"] = pumplist[i]["pump_name"];
      newrow["isdeleted"] = "N";

      var pmbdi = UT.getrowindex(PumpBd, "pump_no", newrow["pump_no"]);
      if(pmbdi == -1) {
        if (PumpBd[PumpBd.length - 1]["no"] == "") {
          PumpBd[PumpBd.length - 1] = newrow;
        }
        else {
          PumpBd.add(newrow);
          print("added-->$PumpBd");
        }
      }
      else {

      }

    }

    for (var i = 0; i < itemmst.length; i++) {
      if (itemmst[i]['item_group'] != 'PETRO') {
        //var newrow = JSON.parse(JSON.stringify(PumpBd[PumpBd.length - 1]));
        var newrow = {};
      /*  print(PumpBd[PumpBd.length - 1]["no"]);
        if(PumpBd[PumpBd.length - 1]["no"]==""){
          PumpBd[PumpBd.length - 1]["no"]="0";
        }*/
        //newrow["no"] = (int.parse(PumpBd[PumpBd.length - 1]["no"]) + 1).toString().padLeft(3, "0");
        var srno = int.parse(PumpBd[PumpBd.length - 1]["no"]) + 1;
        newrow["no"] = srno.toString().padLeft(3, "0");

        newrow["srno"] = PumpHd['srno'];
        newrow["date"] = UT.dateConverter(currentDate);
        newrow["shift"] = _saleShift;
        newrow["pump_no"] = '';
        newrow["pump_name"] = '';
        var iii = itemmst[i]['item_code'];
        newrow["item_code"] = itemmst[i]['item_code'];
        newrow["st_meter"] = 0;
        newrow["end_meter"] = 0;
        newrow["petro_item"] = itemmst[i]['item_code'];
        newrow["petro_per"] = 0;

        var plrow = UT.getrowindex(plrate, "item_code", newrow["item_code"]);
        if (plrow >= 0) {
          newrow["rate"] = plrate[plrow]["pl_rate"];
        }
        else {
          newrow["rate"] = 0;
        }

        var  recd_qty = 0.0;
        var recd_trnamt = 0.0;
        for(int i=0;i<imhs.length;i++){
        if (imhs[i]['item_code'] == newrow["item_code"]) {
        recd_qty += UT.Flt(imhs[i]['qty']);
        recd_trnamt += UT.Flt(imhs[i]['trnamt']);
        }
        }
        newrow["recd_qty"] = recd_qty;
        newrow["st_qty"] = 0;
        newrow["trn_rate"] = 0;

        var indx4st = UT.getrowindex(pmbd4open, "item_code", newrow["item_code"]);
        if (indx4st >= 0) {
          newrow["st_qty"] = pmbd4open[indx4st]["end_qty"];
          if(pmbd4open[indx4st]["trn_rate"]==""||pmbd4open[indx4st]["trn_rate"]==null){
            newrow["trn_rate"]=0;
          }else{
            newrow["trn_rate"] = pmbd4open[indx4st]["trn_rate"];
            var trnopval = UT.Flt(newrow["st_qty"]) * UT.Flt(newrow["trn_rate"]);
            newrow["trn_rate"] = (trnopval + recd_trnamt) /  (UT.Flt(newrow["recd_qty"]) + UT.Flt(newrow["st_qty"]));
          }

        }


        newrow["isdeleted"] = "N";
        newrow["end_qty"] = UT.Flt(newrow["st_qty"]) + UT.Flt(newrow["recd_qty"]);
        newrow["diff_qty"] = UT.Flt(newrow["st_qty"]) + UT.Flt(newrow["recd_qty"]) - UT.Flt(newrow["end_qty"]);

        var pmbdi = UT.getrowindex(PumpBd, "item_code", newrow["item_code"]);
        if (pmbdi == -1) {
          PumpBd.add(newrow);
        }
        else {
          PumpBd[pmbdi]["st_qty"] = newrow["st_qty"];
          PumpBd[pmbdi]["recd_qty"] = recd_qty;
          //PumpBd[pmbdi]["end_qty"] = Flt(newrow["st_qty"]) + Flt(newrow["recd_qty"]) - Flt(newrow["diff_qty"]);
          //PumpBd[pmbdi]["diff_qty"] = Flt(newrow["st_qty"]) + Flt(newrow["recd_qty"]) - Flt(newrow["end_qty"]);

          PumpBd[pmbdi]["end_qty"] = UT.Flt(PumpBd[pmbdi]["st_qty"]) +UT.Flt(PumpBd[pmbdi]["recd_qty"]) - UT.Flt(PumpBd[pmbdi]["diff_qty"]);
          PumpBd[pmbdi]["diff_qty"] = UT.Flt(PumpBd[pmbdi]["st_qty"]) + UT.Flt(PumpBd[pmbdi]["recd_qty"]) - UT.Flt(PumpBd[pmbdi]["end_qty"]);
          PumpBd[pmbdi]["trn_rate"] = newrow["trn_rate"];

        }
      }
    }
    }



   saveDT() async {
    var data = [];
    data.add(PumpHd);


   // GetStr(APIURL + "/api/LedgPost?year="+Setup('curyear')+ "&EntryType=PUMPPOST&Shop=" + Firm("shop") + "&Condition=SRNO='" + PumpHd.srno + "'&isdelete=true");
   // var res = Save2DB(OpenTable('pmhd' + Setup("curyear") + Firm("Shop")), "srno", data);
    var _url1 = UT.APIURL! +
        "api/PostData/Post?tblname=pmhd" +
        UT.curyear!+ UT.shop_no!;
    _url1 += "&Unique=srno";

    print("pmhd-url->$_url1");
    var res = await UT.save2Db(_url1, data);
    print("PumpHd-res->$res");

    print("PumpBd-->$PumpBd");
   // var decodeBD = json.decode(PumpBd.toString());
   // print("decodeBD-->$decodeBD");
var pmbd2 =[];
for(int i=0;i<22;i++){
  pmbd2.add(PumpBd[i]);
}
var _url2 = UT.APIURL! +
        "api/PostData/Post?tblname=pmbd" +
        UT.curyear!+ UT.shop_no!;
    _url2 += "&Unique=srno,no";
    print("pmbd-url->$_url2");
    var res1 = await UT.save2Db(_url2, PumpBd);
    print("pmbd-res->$res1");

    if (res == "ok" && res1 == "ok") {
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Save successfully");
      UT.m["slipNoOld"]=slipNoController.text;
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManagerShiftSalePage()));
      return true;
    }
    else {
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Problem while data saving!");
      return false;
    }
  }

}

class InchargeModel {
  String? acno;
  String? name;

  InchargeModel({this.acno, this.name});

  InchargeModel.fromJson(Map<String, dynamic> json) {
    acno = json['acno'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acno'] = this.acno;
    data['name'] = this.name;
    return data;
  }
}