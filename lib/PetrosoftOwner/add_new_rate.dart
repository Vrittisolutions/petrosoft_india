import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:petrosoft_india/PetrosoftOwner/rate_master.dart';
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:petrosoft_india/common/widgets/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AddNewRate extends StatefulWidget {
  final String validFromDate,validUptoDate;
  const AddNewRate({Key? key, required this.validFromDate,required this.validUptoDate}) : super(key: key);
  @override
  _AddNewRateState createState() => _AddNewRateState();
}

class _AddNewRateState extends State<AddNewRate> {
  List<TextEditingController> textEditingControllers = [];
  List<TextEditingController> mrpControllers = [];

  dynamic itemList;
  double? plRate;
  double? mRP;
  dynamic api;
  bool disableTextField=true;
  @override
  void initState() {
    super.initState();
    api=getData();
  }

    getData() async {
    var _url = UT.APIURL! +
        "api/PriceListEnt/GetData4mobileApp?_shop=" +
        UT.shop_no! +
        "&validfrom=" +
        widget.validFromDate;
    var data = await UT.apiDt(_url);
    itemList=data;
    for(int i=0;i<itemList.length;i++){
      plRate=itemList[i]["pl_rate"];
      mRP=itemList[i]["item_mrp"];
      var textEditingController = TextEditingController(text: plRate.toString());
      textEditingControllers.add(textEditingController);
      var mrpEditingController = TextEditingController(text: mRP.toString());
      mrpControllers.add(mrpEditingController);
    }

    var yearEndDate=UT.dateMonthYearFormat(UT.yearEndDate!);
    if(yearEndDate==widget.validUptoDate){
      disableTextField=false;
    }
    return itemList;
  }

  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        /*onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RateMasterPage()));
        },*/
        title: const Text('Rate Master',),
        backgroundColor: ColorsForApp.app_theme_color_owner,
        ),


        body: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
            child:Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0.0,right: 0.0,top: 0),
                  child: Container(
                    color: ColorsForApp.app_theme_color_light_owner_drawer,
                    height: 40,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            "  Description",
                            maxLines: 2,
                            style: StyleForApp.text_style_bold_14_owner_icon
                          ),
                        ),
                        SizedBox(width: 30,),
                        Expanded(
                          child: Text(
                            "           PL Rate",
                            maxLines: 2,
                              style: StyleForApp.text_style_bold_14_owner_icon
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "        MRP",
                            maxLines: 2,
                              style: StyleForApp.text_style_bold_14_owner_icon
                          ),
                        ),
                      ]),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: api,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                          itemBuilder: (context, index) {
                             plRate=itemList[index]["pl_rate"];
                            // textEditingControllers[index].text=plRate.toString();
                             mRP=itemList[index]["item_mrp"];
                          //  mrpController.text=MRP.toString();
                            return Stack(
                              children: [
                                Container(
                                  height: 53.0,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(left: 0.0,top: 10,right: 20),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5,),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  itemList[index]["item_desc"],
                                                 style: StyleForApp.text_style_normal_14_black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 40,
                                                width: 70,
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  readOnly: disableTextField,
                                                  controller: textEditingControllers[index],
                                                  keyboardType: TextInputType.number,
                                                  autofocus: false,
                                                  onChanged: (text) {
                                                    plRate=double.parse(text);
                                                  },
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                    //hintText: "$plRate",
                                                    //contentPadding: EdgeInsets.all(15.0),
                                                  ),
                                                ),

                                              ),
                                              const SizedBox(width: 10,),
                                              SizedBox(
                                                height: 40,
                                                width: 70,
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  readOnly: disableTextField,
                                                  controller: mrpControllers[index],
                                                  keyboardType: TextInputType.number,
                                                  autofocus: false,
                                                  onChanged: (text) {
                                                   mRP=double.parse(text);
                                                  },
                                                  decoration: InputDecoration(
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                                                    //  hintText: "$MRP"
                                                    //contentPadding: EdgeInsets.all(15.0),
                                                  ),
                                                ),

                                              ),

                                            ]),

                                      ]),
                                ),
                                 Divider(color: ColorsForApp.light_gray_color,)
                              ],
                            );
                          },
                          itemCount: itemList.length);
                    }
                    return Center(child:CommonWidget.circularIndicator());
                  },
                  ),
                ),

              ],
            )

        ),
      bottomNavigationBar: submitButton(),
    );
  }
  Widget submitButton(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 100,
        child: CommonButtonForAllApp(
            onPressed: () async {
          DialogBuilder(context).showLoadingIndicator('');
          List itemDataList=[];
          for(int i=0;i<itemList.length;i++){
            var itemlistSaveDate= Map();
            itemlistSaveDate["item_desc"]=itemList[i]["item_desc"];
            itemlistSaveDate["item_code"]=itemList[i]["item_code"];
            itemlistSaveDate["validfrom"]=itemList[i]["validfrom"];
            itemlistSaveDate["validupto"]=itemList[i]["validupto"];
            itemlistSaveDate["pl_rate"]=textEditingControllers[i].text;
            itemlistSaveDate["item_mrp"]=mrpControllers[i].text;
            itemDataList.add(itemlistSaveDate);
          }
          var save_url = UT.APIURL! +
              "api/PostData/Post?tblname=plrate" +
              UT.shop_no!;
          save_url += "&Unique=item_code,validfrom";
          var result = await UT.save2Db(save_url, itemDataList);
          DialogBuilder(context).hideOpenDialog();
        }, title: 'Save',backgroundColor: ColorsForApp.app_theme_color_owner),
      ),
    );
  }

}
