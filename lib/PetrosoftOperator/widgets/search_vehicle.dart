import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class VehicleCustomDelegate extends SearchDelegate<String> {
  VehicleCustomDelegate({required List vehicleList})
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
          e['veh_no'].toLowerCase().contains(query.toLowerCase())).toList();
    else
      listToShow = vehicleList;
    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        var searchValue = listToShow[i]['veh_no'];
        return ListTile(
          title: Text(searchValue),
          onTap: () {
            UT.m["Selected_veh_no"] = listToShow[i]['veh_no'];
            close(context, searchValue);
          },
        );
      },
    );
  }
}
