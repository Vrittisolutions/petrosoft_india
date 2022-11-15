
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AreaCustomDelegate extends SearchDelegate<String> {

  AreaCustomDelegate({required List commonList,})
      : this.commonList = commonList ;
  final List commonList;

  // CustomDelegate( {required List<String> vehicleList});

  get vehicleList1 => this.commonList;

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
      listToShow = commonList.where((e) =>
          e['city'].toLowerCase().contains(query.toLowerCase())).toList();
    else
      listToShow = commonList;
    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var searchValue = listToShow[i]['city'];
        return ListTile(
          title: Text(searchValue),
          onTap: () {
            UT.m["Selected_area_acno"]=listToShow[i]['acno'];
            close(context, listToShow[i]['city']);
          },
        );
      },
    );
  }
}
