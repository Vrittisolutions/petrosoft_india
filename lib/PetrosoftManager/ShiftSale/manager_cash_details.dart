import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftManager/ShiftSale/shift_sale.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ManagerCashDetails extends StatefulWidget{
  const ManagerCashDetails({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ManagerCashDetailsState();
  }

}
class ManagerCashDetailsState extends State<ManagerCashDetails>{
  final TextEditingController rs2000xTxt=TextEditingController(text: '0.00');
  final TextEditingController rs500xTxt=TextEditingController(text: '0.00');
  final TextEditingController rs200xTxt=TextEditingController(text: '0.00');
  final TextEditingController rs100xTxt=TextEditingController(text: '0.00');
  final TextEditingController rs50xTxt=TextEditingController(text: '0.00');
  final TextEditingController rs20xTxt=TextEditingController(text: '0.00');
  final TextEditingController rs10xTxt=TextEditingController(text: '0.00');
  final TextEditingController rs5xTxt=TextEditingController(text: '0.00');
  final TextEditingController coin10xTxt=TextEditingController(text: '0.00');
  final TextEditingController coin5xTxt=TextEditingController(text: '0.00');
  final TextEditingController coin2xTxt=TextEditingController(text: '0.00');
  final TextEditingController coin1xTxt=TextEditingController(text: '0.00');
  final TextEditingController coinTxt=TextEditingController(text: '0.00');

  final TextEditingController noteTotal=TextEditingController(text: '0.00');
  final TextEditingController coinTotal=TextEditingController(text: '0.00');
  final TextEditingController total=TextEditingController(text: '0.00');
  double rs2000Tot=0.00;
  double rs500Tot=0.00;
  double rs200Tot=0.00;
  double rs100Tot=0.00;
  double rs50Tot=0.00;
  double rs20Tot=0.00;
  double rs10Tot=0.00;
  double rs5Tot=0.00;
  double coin10Tot=0.00;
  double coin5Tot=0.00;
  double coin2Tot=0.00;
  double coin1Tot=0.00;
  double coin=0.00;
  double noteTotal1=0.00;
  double coinTotal1=0.00;
  double nTot=0.00;
  var PumpHd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPumpHd();
  }
  Future<bool?> _willPopCallback()async{
   // UT.m['saledate']=UT.m['saledate'];
    return Navigator.of(context)
        .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
      return ManagerShiftSalePage();
    }));
    // return true if the route to be popped
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: ()async {
        _willPopCallback();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsForApp.appThemeColor,
          title:  Text("Cash Details",style: PetroSoftTextStyle.style17White,),

        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rs.2000 X",style: StyleForApp.text_style_bold_14_black,
                      ),
                      SizedBox(height: 40,width: 100,
                          child: TextFormField(
                            controller: rs2000xTxt,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.grey.shade400,

                                  )
                              ),
                              hintText: "",
                              //labelText: "Password",
                              contentPadding: const EdgeInsets.all(15.0),

                            ),
                            onChanged: (value){
                              if(value.isNotEmpty){
                                rstotal();
                              }
                            },
                          )),
                      Container(
                          height: 40,width: 100,
                          decoration: BoxDecoration(//DecorationImage
                            border: Border.all(
                              color: Colors.black38,
                              // width: 8,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Center(child: Text(rs2000Tot.toStringAsFixed(2)))
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rs.500 X",style: StyleForApp.text_style_bold_14_black,
                      ),
                      SizedBox(height: 40,width: 100,
                          child: TextFormField(
                            controller: rs500xTxt,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.grey.shade400,

                                  )
                              ),
                              hintText: "",
                              //labelText: "Password",
                              contentPadding: const EdgeInsets.all(15.0),

                            ),
                            onChanged: (value){
                              if(value.isNotEmpty){
                                rstotal();
                              }
                            },
                          )),
                      Container(
                          height: 40,width: 100,
                          decoration: BoxDecoration(//DecorationImage
                            border: Border.all(
                              color: Colors.black38,
                              // width: 8,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Center(child: Text(rs500Tot.toStringAsFixed(2)))
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rs.200 X",style: StyleForApp.text_style_bold_14_black,
                      ),
                      SizedBox(height: 40,width: 100,
                          child: TextFormField(
                            controller: rs200xTxt,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.grey.shade400,

                                  )
                              ),
                              hintText: "",
                              //labelText: "Password",
                              contentPadding: const EdgeInsets.all(15.0),

                            ),
                            onChanged: (value){
                              if(value.isNotEmpty){
                                rstotal();
                              }
                            },
                          )),
                      Container(
                          height: 40,width: 100,
                          decoration: BoxDecoration(//DecorationImage
                            border: Border.all(
                              color: Colors.black38,
                              // width: 8,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Center(child: Text(rs200Tot.toStringAsFixed(2)))
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rs.100 X",style: StyleForApp.text_style_bold_14_black,
                      ),
                      SizedBox(height: 40,width: 100,
                          child: TextFormField(
                            controller: rs100xTxt,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.grey.shade400,

                                  )
                              ),
                              hintText: "",
                              //labelText: "Password",
                              contentPadding: const EdgeInsets.all(15.0),

                            ),
                            onChanged: (value){
                              if(value.isNotEmpty){
                                rstotal();
                              }
                            },
                          )),
                      Container(
                          height: 40,width: 100,
                          decoration: BoxDecoration(//DecorationImage
                            border: Border.all(
                              color: Colors.black38,
                              // width: 8,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Center(child: Text(rs100Tot.toStringAsFixed(2)))
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rs.50 X",style: StyleForApp.text_style_bold_14_black,
                      ),
                      SizedBox(height: 40,width: 100,
                          child: TextFormField(
                            controller: rs50xTxt,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.grey.shade400,

                                  )
                              ),
                              hintText: "",
                              //labelText: "Password",
                              contentPadding: const EdgeInsets.all(15.0),

                            ),
                            onChanged: (value){
                            if(value.isNotEmpty){
                              rstotal();
                            }
                            },
                          )),
                      Container(
                          height: 40,width: 100,
                          decoration: BoxDecoration(//DecorationImage
                            border: Border.all(
                              color: Colors.black38,
                              // width: 8,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Center(child: Text(rs50Tot.toStringAsFixed(2)))
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rs.20 X",style: StyleForApp.text_style_bold_14_black,
                      ),
                      SizedBox(height: 40,width: 100,
                          child: TextFormField(
                            controller: rs20xTxt,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.grey.shade400,

                                  )
                              ),
                              hintText: "",
                              //labelText: "Password",
                              contentPadding: const EdgeInsets.all(15.0),

                            ),
                            onChanged: (value){
                              if(value.isNotEmpty){
                                rstotal();
                              }
                            },
                          )),
                      Container(
                          height: 40,width: 100,
                          decoration: BoxDecoration(//DecorationImage
                            border: Border.all(
                              color: Colors.black38,
                              // width: 8,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Center(child: Text(rs20Tot.toStringAsFixed(2)))
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rs.10 X",style: StyleForApp.text_style_bold_14_black,
                      ),
                      SizedBox(height: 40,width: 100,
                          child: TextFormField(
                            controller: rs10xTxt,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.grey.shade400,

                                  )
                              ),
                              hintText: "",
                              //labelText: "Password",
                              contentPadding: const EdgeInsets.all(15.0),

                            ),
                            onChanged: (value){
                              if(value.isNotEmpty){
                                rstotal();
                              }
                            },
                          )),
                      Container(
                          height: 40,width: 100,
                          decoration: BoxDecoration(//DecorationImage
                            border: Border.all(
                              color: Colors.black38,
                              // width: 8,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Center(child: Text(rs10Tot.toStringAsFixed(2)))
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rs.5 X",style: StyleForApp.text_style_bold_14_black,
                      ),
                      SizedBox(height: 40,width: 100,
                          child: TextFormField(
                            controller: rs5xTxt,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.grey.shade400,

                                  )
                              ),
                              hintText: "",
                              //labelText: "Password",
                              contentPadding: const EdgeInsets.all(15.0),

                            ),
                            onChanged: (value){
                              if(value.isNotEmpty){
                                rstotal();
                              }
                            },
                          )),
                      Container(
                          height: 40,width: 100,
                          decoration: BoxDecoration(//DecorationImage
                            border: Border.all(
                              color: Colors.black38,
                              // width: 8,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Center(child: Text(rs5Tot.toStringAsFixed(2)))
                      )
                    ],
                  ),
                ),
               //coin ui
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Coin 10 X",style: StyleForApp.text_style_bold_14_black,
                      ),
                      SizedBox(height: 40,width: 100,
                          child: TextFormField(
                            controller: coin10xTxt,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.grey.shade400,

                                  )
                              ),
                              hintText: "",
                              //labelText: "Password",
                              contentPadding: const EdgeInsets.all(15.0),

                            ),
                            onChanged: (value){
                              if(value.isNotEmpty){
                                rstotal();
                              }
                            },
                          )),
                      Container(
                          height: 40,width: 100,
                          decoration: BoxDecoration(//DecorationImage
                            border: Border.all(
                              color: Colors.black38,
                              // width: 8,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Center(child: Text(coin10Tot.toStringAsFixed(2)))
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Coin 5 X",style: StyleForApp.text_style_bold_14_black,
                      ),
                      SizedBox(height: 40,width: 100,
                          child: TextFormField(
                            controller: coin5xTxt,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.grey.shade400,

                                  )
                              ),
                              hintText: "",
                              //labelText: "Password",
                              contentPadding: const EdgeInsets.all(15.0),

                            ),
                            onChanged: (value){
                              if(value.isNotEmpty){
                                rstotal();
                              }
                            },
                          )),
                      Container(
                          height: 40,width: 100,
                          decoration: BoxDecoration(//DecorationImage
                            border: Border.all(
                              color: Colors.black38,
                              // width: 8,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Center(child: Text(coin5Tot.toStringAsFixed(2)))
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Coin 2 X",style: StyleForApp.text_style_bold_14_black,
                      ),
                      SizedBox(height: 40,width: 100,
                          child: TextFormField(
                            controller: coin2xTxt,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.grey.shade400,

                                  )
                              ),
                              hintText: "",
                              //labelText: "Password",
                              contentPadding: const EdgeInsets.all(15.0),

                            ),
                            onChanged: (value){
                              if(value.isNotEmpty){
                                rstotal();
                              }
                            },
                          )),
                      Container(
                          height: 40,width: 100,
                          decoration: BoxDecoration(//DecorationImage
                            border: Border.all(
                              color: Colors.black38,
                              // width: 8,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Center(child: Text(coin2Tot.toStringAsFixed(2)))
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Coin 1 X",style: StyleForApp.text_style_bold_14_black,
                      ),
                      SizedBox(height: 40,width: 100,
                          child: TextFormField(
                            controller: coin1xTxt,
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    color:Colors.grey.shade400,

                                  )
                              ),
                              hintText: "",
                              //labelText: "Password",
                              contentPadding: const EdgeInsets.all(15.0),

                            ),
                            onChanged: (value){
                             if(value.isNotEmpty){
                               rstotal();
                             }
                            },
                          )),
                      Container(
                          height: 40,width: 100,
                          decoration: BoxDecoration(//DecorationImage
                            border: Border.all(
                              color: Colors.black38,
                              // width: 8,
                            ), //Border.all
                            borderRadius: BorderRadius.circular(10.0),),
                          child: Center(child: Text(coin1Tot.toStringAsFixed(2)))
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.grey,

                    borderRadius:  const BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      bottomRight: const Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 15.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: SizedBox(
                                height: 35,
                                width: 110,
                                child: TextField(
                                    controller: noteTotal,
                                    readOnly: true,
                                    style: TextStyle(fontSize: 13,color: ColorsForApp.white,fontWeight: FontWeight.w600) ,
                                    decoration: InputDecoration(
                                      labelText: "Note Rs.",
                                      labelStyle: TextStyle(fontSize: 15,color: ColorsForApp.white,fontWeight: FontWeight.w600),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    )),
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Flexible(
                              child: SizedBox(
                                height: 35,width: 110,
                                child: TextField(
                                    controller: coinTotal,
                                    readOnly: true,
                                    style: TextStyle(fontSize: 13,color: ColorsForApp.white,fontWeight: FontWeight.w600),
                                    decoration: InputDecoration(
                                      labelText: "Coin Rs.",
                                      labelStyle: TextStyle(fontSize: 15,color: ColorsForApp.white,fontWeight: FontWeight.w600),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    )),
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Flexible(
                              child: SizedBox(
                                height: 35,width: 110,
                                child: TextField(
                                    controller: total,
                                    readOnly: true,
                                    style: TextStyle(fontSize: 13,color: ColorsForApp.white,fontWeight: FontWeight.w600),
                                    decoration: InputDecoration(
                                      labelText: "Total Rs.",
                                      labelStyle:  TextStyle(fontSize: 15,color: ColorsForApp.white,fontWeight: FontWeight.w600),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorsForApp.white,width: 1.0),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CommonButtonForAllApp(
                            onPressed: () async {
                            /*  double cashBalance=double.parse(UT.m['cash_balance']);
                              double total=double.parse(finalTotalValue.text);
                              if(total>cashBalance){
                                Fluttertoast.showToast(msg: "Total should not ge grater than cash balance");
                              }else{
                                DialogBuilder(context).showLoadingIndicator('');
                                saveData();
                              }*/
                               saveData();
                            },
                            title: 'Save', backgroundColor: ColorsForApp.appThemePetroOwner,
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ],
            ),
          ),
        ),
   /*   bottomNavigationBar: Container(
          height: 60,
        decoration:  BoxDecoration(
          border: Border.all(color: Colors.blue),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
         // borderRadius: BorderRadius.circular(20),
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              offset: const Offset(5, 5),
              blurRadius: 10,
            )
          ],
      //color: Colors.black,
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 15.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 35,
                      width: 110,
                      child: TextField(
                          controller: noteTotal,
                          readOnly: true,
                          style:const TextStyle(fontSize: 13,color: Colors.indigo,fontWeight: FontWeight.w600) ,
                          decoration: InputDecoration(
                            labelText: "Note Rs.",
                            labelStyle: TextStyle(fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 35,width: 110,
                      child: TextField(
                          controller: coinTotal,
                          readOnly: true,
                        style:const TextStyle(fontSize: 13,color: Colors.indigo,fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            labelText: "Coin Rs.",
                            labelStyle: TextStyle(fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 35,width: 110,
                      child: TextField(
                          controller: total,
                          readOnly: true,
                        style:const TextStyle(fontSize: 13,color: Colors.indigo,fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            labelText: "Total Rs.",
                            labelStyle: const TextStyle(fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        ),*/
      ),
    );

  }
   rstotal() {

    //var rs=0.0 ;
     var rs = (UT.Flt(rs500xTxt.text) * 500) + (UT.Flt(rs200xTxt.text) * 200) + (UT.Flt(rs100xTxt.text) * 100) + (UT.Flt(rs50xTxt.text) * 50);
     rs += (UT.Flt(rs2000xTxt.text) * 2000) + (UT.Flt(rs20xTxt.text) * 20) + (UT.Flt(rs10xTxt.text) * 10);
     rs += (UT.Flt(rs5xTxt.text) * 5) +(UT.Flt(coin2xTxt.text) * 2) + (UT.Flt(coin10xTxt.text) * 10) + (UT.Flt(coin5xTxt.text) * 5)  +UT.Flt(coin1xTxt.text)+ UT.Flt(coinTxt.text);



    var noters = (UT.Flt(rs500xTxt.text)*500 + UT.Flt(rs200xTxt.text)*200 + UT.Flt(rs100xTxt.text)*100 + UT.Flt(rs50xTxt.text)*50 + UT.Flt(rs2000xTxt.text)*2000 + UT.Flt(rs20xTxt.text)*20 + UT.Flt(rs10xTxt.text)*10 + UT.Flt(rs5xTxt.text)*5);
    var coinrs = (UT.Flt(coin2xTxt.text)*2 + UT.Flt(coin10xTxt.text)*10 + UT.Flt(coin5xTxt.text)*5 + UT.Flt(coin1xTxt.text) + UT.Flt(coinTxt.text));

    setState(() {
      noteTotal.text=noters.toStringAsFixed(2);
      coinTotal.text=coinrs.toStringAsFixed(2);
      total.text=rs.toString();
      rs2000Tot = UT.Flt(rs2000xTxt.text) * 2000;
      rs500Tot = UT.Flt(rs500xTxt.text) * 500;
      rs200Tot = UT.Flt(rs200xTxt.text) * 200;
      rs100Tot = UT.Flt(rs100xTxt.text) * 100;
      rs50Tot = UT.Flt(rs50xTxt.text) * 50;
      rs20Tot = UT.Flt(rs20xTxt.text) * 20;
      rs10Tot = UT.Flt(rs10xTxt.text) * 10;
      rs5Tot = UT.Flt(rs5xTxt.text) * 5;

      coin2Tot = UT.Flt(coin2xTxt.text) * 2;
      coin10Tot = UT.Flt(coin10xTxt.text) * 10;
      coin5Tot = UT.Flt(coin5xTxt.text) * 5;
      coin1Tot = UT.Flt(coin1xTxt.text) * 1;
      coin = UT.Flt(coinTxt.text) * 1;
    });
    return;
  }
  Widget noteLable(String name,TextEditingController controller,int note){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,style: StyleForApp.text_style_bold_14_black,
          ),
          SizedBox(height: 40,width: 100,
          child: TextFormField(
            controller: controller,
          keyboardType: TextInputType.number,
          autofocus: false,
              decoration: InputDecoration(
                enabledBorder:OutlineInputBorder( //Outline border type for TextFeild
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color:Colors.grey.shade400,

                    )
                ),
                hintText: "",
                //labelText: "Password",
                contentPadding: const EdgeInsets.all(15.0),

              ),
            onChanged: (value){
              if(value.isNotEmpty){
               print(note.toString());
                setState(() {
                  rs2000Tot=double.parse(value)*double.parse(note.toString());
                  print('total-->$rs2000Tot');
                });
              }
            },
      )),
          Container(
              height: 40,width: 100,
              decoration: BoxDecoration(//DecorationImage
                border: Border.all(
                  color: Colors.black38,
                  // width: 8,
                ), //Border.all
                borderRadius: BorderRadius.circular(10.0),),
              child: Center(child: Text(rs2000Tot.toString()))
          )
        ],
      ),
    );
  }

   getPumpHd() async {
     var _urlHD = UT.APIURL! +
         "api/PumpTrnE/GetPumpHD?year=" +
         UT.curyear! + "&shop=" + UT.shop_no! +
         "&Where=isdeleted%20<>%27Y%27%20and%20srno%3D${UT.m["slipNoOld"]}&Addrow=true";

     PumpHd = await UT.apiDt(_urlHD);
     rs2000xTxt.text=PumpHd[0]['rs_2000'].toStringAsFixed(2);
     rs500xTxt.text=PumpHd[0]['rs_500'].toStringAsFixed(2);
     rs200xTxt.text=PumpHd[0]['rs_200'].toStringAsFixed(2);
     rs100xTxt.text=PumpHd[0]['rshund'].toStringAsFixed(2);
     rs50xTxt.text=PumpHd[0]['rsfifty'].toStringAsFixed(2);
     rs20xTxt.text=PumpHd[0]['rs_20'].toStringAsFixed(2);
     rs10xTxt.text=PumpHd[0]['rsten'].toStringAsFixed(2);
     rs5xTxt.text=PumpHd[0]['rsfive'].toStringAsFixed(2);
     coin10xTxt.text=PumpHd[0]['_coin10'].toStringAsFixed(2);
     coin5xTxt.text=PumpHd[0]['_coin5'].toStringAsFixed(2);
     coin2xTxt.text=PumpHd[0]['rstwo'].toStringAsFixed(2);
     coin1xTxt.text=PumpHd[0]['rsone'].toStringAsFixed(2);
     coinTxt.text=PumpHd[0]['coins'].toStringAsFixed(2);
     rstotal();
   }
   saveData() async {
     PumpHd[0]['srno']=UT.m["slipNoOld"];
     PumpHd[0]['date']=UT.yearMonthDateFormat(UT.m["saledate"]);
     PumpHd[0]['shift']=UT.m['shift'];
     PumpHd[0]['rs_2000']=rs2000xTxt.text;
     PumpHd[0]['rs_500']=rs500xTxt.text;
     PumpHd[0]['rs_200']=rs200xTxt.text;
     PumpHd[0]['rshund']=rs100xTxt.text;
     PumpHd[0]['rsfifty']=rs50xTxt.text;
     PumpHd[0]['rs_20']=rs20xTxt.text;
     PumpHd[0]['rsten']=rs10xTxt.text;
     PumpHd[0]['rsfive']=rs5xTxt.text;
     PumpHd[0]['_coin10']=coin10xTxt.text;
     PumpHd[0]['_coin5']=coin5xTxt.text;
     PumpHd[0]['rstwo']=coin2xTxt.text;
     PumpHd[0]['rsone']=coin1xTxt.text;
     PumpHd[0]['coins']=coinTxt.text;
     var data = [];
     data.add(PumpHd);
     print("Updating HD->$PumpHd");
     var _url1 = UT.APIURL! +
         "api/PostData/Post?tblname=pmhd" +
         UT.curyear!+ UT.shop_no!;
     _url1 += "&Unique=srno";

     print("pmhd-url->$_url1");
     var res = await UT.save2Db(_url1, PumpHd);
     print("PumpHd-res->$res");
     if(res=="ok"){
       DialogBuilder(context).hideOpenDialog();
       Fluttertoast.showToast(msg: "Save successfully");
       UT.m['saledate']=UT.m['saledate'];
       return Navigator.of(context)
           .push(CupertinoPageRoute<bool>(builder: (BuildContext context) {
         return const ManagerShiftSalePage();
       }));
     }else{
       DialogBuilder(context).hideOpenDialog();
       Fluttertoast.showToast(msg: "Problem while data saving!");
     }



   }
}
