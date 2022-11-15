import 'package:petrosoft_india/Classes/styleforapp.dart';
import 'package:flutter/material.dart';

class StockEntryDetails extends StatefulWidget {
  const StockEntryDetails({Key? key}) : super(key: key);

  @override
  _StockEntryDetailsState createState() => _StockEntryDetailsState();
}

class _StockEntryDetailsState extends State<StockEntryDetails> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: const Text("Stock Entry"),),
      body: Column(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 8),
            scrollDirection: Axis.vertical,
            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(

                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      // border: Border.all(),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0,left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              Expanded(child: Text("00009",style: StyleForApp.text_style_normal_13_black)),
                              Expanded(child: Text("ONION",style: StyleForApp.text_style_normal_13_black)),
                              Expanded(child: Text("MH12 833",style: StyleForApp.text_style_normal_13_black)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0.0,left: 8.0,bottom: 8.0),
                          child: Row(
                            children:  [
                              Expanded(child: Text("Recd Qty: 4460.00",style: StyleForApp.text_style_normal_13_black)),
                              Expanded(child: Text("Sold Qty:\n 4460.00",style: StyleForApp.text_style_normal_13_black)),
                              Expanded(child: Text("Balance : 1000.00",style: StyleForApp.text_style_bold_13_indigo,)),
                            ],
                          ),
                        ),
                      ],
                    )
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}