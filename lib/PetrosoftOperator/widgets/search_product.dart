import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ProductCustomDelegate extends SearchDelegate<String> {
  ProductCustomDelegate({required List vehicleList})
      : this.vehicleList = vehicleList ;
  final List vehicleList;

  // CustomDelegate( {required List<String> vehicleList});

  get vehicleList1 => this.vehicleList;

  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(
          icon: Icon(Icons.chevron_left), onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    var listToShow;
    if (query.isNotEmpty)
      listToShow = vehicleList.where((e) =>
          e['item_desc'].toLowerCase().contains(query.toLowerCase())).toList();
    else
      listToShow = vehicleList;
    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var searchValue = listToShow[i]['item_desc'];
        return ListTile(
          title: Text(searchValue),
          onTap: () {
          //  double.parse(rateController).toStringAsFixed(2).toString()
            UT.m["Selected_item_rate"] = listToShow[i]['pl_rate'];
            UT.m["Selected_item_code"] = listToShow[i]['item_code'];
            close(context, searchValue);
          },
        );
      },
    );
  }
}
