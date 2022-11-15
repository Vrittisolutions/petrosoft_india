import 'package:petrosoft_india/AdatsoftOwner/AppTheame/textFileds.dart';
import 'package:petrosoft_india/Classes/colors.dart';
import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PattiBookEntry extends StatefulWidget {
  const PattiBookEntry({Key? key}) : super(key: key);

  @override
  State<PattiBookEntry> createState() => _PattiBookEntryState();
}


class _PattiBookEntryState extends State<PattiBookEntry> {

  String ?formatDate;
  TextEditingController txtControllerPattiNo =  TextEditingController();
  TextEditingController txtControllerInwDate =  TextEditingController();
  TextEditingController txtControllerPattiAccount =  TextEditingController();
  TextEditingController txtControllerItem =  TextEditingController();
  TextEditingController txtControllerLotNo =  TextEditingController();
  TextEditingController txtControllerCommodity =  TextEditingController();
  TextEditingController txtControllerQuantity =  TextEditingController();
  TextEditingController txtControllerAvgWT =  TextEditingController();
  TextEditingController txtControllerWeight =  TextEditingController();
  TextEditingController txtControllerRate =  TextEditingController();
  TextEditingController txtControllerAmount =  TextEditingController();
  TextEditingController txtControllerRemark =  TextEditingController();


  final List<AddPattiItem> _entriesList=[];

  @override
  void initState() {
    DateTime currentDate = DateTime.now();
    formatDate = DateFormat("dd-MM-yyyy").format(currentDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: ColorsForApp.appThemeColorPetroCustomer,
        title: const Text('Patti Book Entry',
          style: TextStyle(fontSize: 15),),
        actions: [
          Center(child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(formatDate.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AdatTextField.textFieldWithBorder(null, "Patti No.", txtControllerPattiNo,TextInputType.number,true,165),
                const SizedBox(width: 2,),
                AdatTextField.textFieldWithBorder(null, formatDate.toString(), txtControllerInwDate,TextInputType.number,true,165),
              ],
            ),
            const SizedBox(height: 10,),
            AdatTextField.textFieldWithBorder(null, "Patti Account", txtControllerPattiAccount,TextInputType.number,true,double.infinity),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){
                    addEntry(context);
                  },
                  style: ElevatedButton.styleFrom(
                      primary:ColorsForApp.appThemeColorPetroCustomer,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      textStyle: const TextStyle(
                          color:Colors.white ,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  child: Text('Add',
                      style: StyleForApp.text_style_normal_14_white),
                ),
              ],
            ),
            listView(),
          ],
        ),
      ),
      bottomNavigationBar: bottomUI(),
    );
  }

  Widget listView(){
    return Expanded(
        child:ListView.builder(
            itemCount: _entriesList.length,
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title:Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(_entriesList[index].item,maxLines: 2,style: StyleForApp.text_style_normal_13_black)
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                    child: Text(_entriesList[index].lotNo,maxLines: 2,style: StyleForApp.text_style_normal_13_black,)
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                    child: Text(_entriesList[index].commodity,maxLines: 2,style: StyleForApp.text_style_normal_13_black,)
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(_entriesList[index].quantity,maxLines: 2,style: StyleForApp.text_style_normal_13_black)
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                    child: Text(_entriesList[index].commodity,maxLines: 2,style: StyleForApp.text_style_normal_13_black)
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                    child: Text(_entriesList[index].avgWT,maxLines: 2,style: StyleForApp.text_style_normal_13_black)
                                ),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(_entriesList[index].rate,maxLines: 2,style: StyleForApp.text_style_normal_13_black)
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                    child: Text(_entriesList[index].amount,maxLines: 2,style: StyleForApp.text_style_normal_13_black)
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                    child: Text(_entriesList[index].remark,maxLines: 2,style: StyleForApp.text_style_normal_13_black)
                                ),
                              ],
                            ),
                          ],
                        ) ,
                        trailing:IconButton(
                          onPressed: (){
                            setState(() {
                              _entriesList.remove(_entriesList[index]);
                            });
                          },
                          icon: const Icon(Icons.delete,color: Colors.red,),
                        ) ,
                      )
                    ],
                  ),
                ),
              );
            })
    );
  }

  addEntry(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text('Enter Details', style: StyleForApp.text_style_bold_14_black,),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerItem,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Item",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerCommodity,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Commodity",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerLotNo,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Lot No.",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerQuantity,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Quantity",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerWeight,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Weight",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerRate,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Rate",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerRemark,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Remark",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerAvgWT,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Avg Wt.",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: txtControllerAmount,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Amount",
                          labelStyle: StyleForApp.text_style_normal_14_black
                        //contentPadding: EdgeInsets.all(15.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: ColorsForApp.app_theme_color_light_drawer,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            textStyle: StyleForApp.text_style_normal_14_black),
                        child: const Text('Cancel',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        onPressed: () {
                          txtControllerPattiAccount.clear();
                          txtControllerLotNo.clear();
                          txtControllerCommodity.clear();
                          txtControllerAvgWT.clear();
                          txtControllerWeight.clear();
                          txtControllerRate.clear();
                          txtControllerAmount.clear();
                          txtControllerRemark.clear();
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 5,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary:ColorsForApp.appThemeColorPetroCustomer,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            textStyle: const TextStyle(
                                color:Colors.white ,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        child: Text('Add',
                            style: StyleForApp.text_style_normal_14_white),
                        onPressed: () {

                          setState(() {
                            _entriesList.add(AddPattiItem(
                              txtControllerItem.text,
                              txtControllerLotNo.text,
                              txtControllerCommodity.text,
                              txtControllerQuantity.text,
                              txtControllerAvgWT.text,
                              txtControllerWeight.text,
                              txtControllerRate.text,
                              txtControllerAmount.text,
                              txtControllerRemark.text,));
                            Navigator.of(context).pop();
                          });


                        },
                      ),
                    ],
                  ),
                )
              ]
          );
        });
  }

  Widget bottomUI(){
    return SizedBox(
      height: 110,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                /*Row(
                  children: [
                    const Text("Sale Amt : "),
                    Container(
                      height: 40,width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text("0.00"),
                      ),
                    ),
                  ],
                ),*/
                const SizedBox(height: 5,),
                /* Row(
                  children: [
                    Text("Freight :"),
                    Container(
                      height: 40,width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text("0.00"),
                      ),
                    ),
                  ],
                )*/
              ],
            ),
            SizedBox(width: 5,),
            Column(
              children: [
                Row(
                  children: [
                    Text("Gross Sale : "),
                    Container(
                      height: 40,width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text("0.00"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text("Expenses : "),
                    Container(
                      height: 40,width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text("0.00"),
                      ),
                    ),
                  ],
                )
              ],
            )

          ],
        ),
      ),
    );
  }

}


class AddPattiItem{
  final String item;
  final String lotNo;
  final String commodity;
  final String quantity;
  final String avgWT;
  final String Weight;
  final String rate;
  final String amount;
  final String remark;

  AddPattiItem(
      this.item,this.lotNo, this.commodity, this.quantity, this.avgWT, this.Weight,
      this.rate,this.amount,this.remark);

}
