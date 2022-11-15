
import 'package:petrosoft_india/common/Classes/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CustomDelegate extends SearchDelegate<String> {
  final String ListType;
  CustomDelegate({required List commonList,  required this.ListType})
      : this.commonList = commonList ;
  final List commonList;

  // CustomDelegate( {required List<String> vehicleList});
  get ListType1=>ListType;
  get vehicleList1 => commonList;

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

    dynamic listToShow;
    if (query.isNotEmpty) {
      listToShow = commonList.where((e) =>
          e['name'].toLowerCase().contains(query.toLowerCase())).toList();
    } else {
      listToShow = commonList;
    }
    print("ListType==>$ListType1");
    if(ListType1=="pumpList"){
      return ListView.builder(
        itemCount: listToShow.length,
        itemBuilder: (_, i) {
          var searchValue = listToShow[i]['pump_name'];
          return ListTile(
            title: Text(searchValue),
            onTap: () {
              UT.m["Selected_pump_no"]=listToShow[i]['pump_no'];
              close(context, listToShow[i]['pump_name']);
            },
          );
        },
      );
    }else if(ListType1=="CustomerList"){

      return ListView.builder(
        itemCount: listToShow.length,
        itemBuilder: (_, i) {
          var searchValue = listToShow[i]['name'];
          return ListTile(
            title: Text(searchValue),
            onTap: () {
              UT.m["Selected_ACCNO"] = listToShow[i]['acno'];
              UT.m["Selected_pager"]=listToShow[i]['pager'];
              print("selected cust mobile>${UT.m["Selected_pager"]}");

              close(context, listToShow[i]['name']);
            },
          );
        },
      );
    }
    else if(ListType1=="BankList"){
     // UT.m["Selected_ACCNO"]='';
      return ListView.builder(
        itemCount: listToShow.length,
        itemBuilder: (_, i) {
        //  print("listToShow-->${listToShow}");
          var searchValue = listToShow[i]['name'];
          return ListTile(
            title: Text(searchValue),
            onTap: () {

              UT.m["Selected_bankno"] = listToShow[i]['acno'];

              UT.m["Selected_pager"]=listToShow[i]['pager'];
              close(context, listToShow[i]['name']);
            },
          );
        },
      );
    }
    else if(ListType=="itemList"){
      return ListView.builder(
        itemCount: listToShow.length,
        itemBuilder: (_, i) {
          //  print("listToShow-->${listToShow}");
          var searchValue = listToShow[i]['item_desc'];
          return ListTile(
            title: Text(searchValue),
            onTap: () {

              UT.m["Selected_ItemCode"] = listToShow[i]['item_code'];

              close(context, listToShow[i]['item_desc']);
            },
          );
        },
      );
    }
    else if(ListType=="cashierList"){
      return ListView.builder(
        itemCount: listToShow.length,
        itemBuilder: (_, i) {
          //  print("listToShow-->${listToShow}");
          var searchValue = listToShow[i]['name'];
          return ListTile(
            title: Text(searchValue),
            onTap: () {

              UT.m["Selected_cashierAcNo"] = listToShow[i]['acno'];

              close(context, listToShow[i]['name']);
            },
          );
        },
      );
    }
    else {
      return ListView.builder(
        itemCount: listToShow.length,
        itemBuilder: (_, i) {
          //  print("listToShow-->${listToShow}");
          var searchValue = listToShow[i]['name'];
          return ListTile(
            title: Text(searchValue),
            onTap: () {

              UT.m["Selected_ACCNO"] = listToShow[i]['acno'];

              UT.m["Selected_pager"]=listToShow[i]['pager'];
              close(context, listToShow[i]['name']);
            },
          );
        },
      );
    }

  }
}
