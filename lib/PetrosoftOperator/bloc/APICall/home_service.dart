import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/HomePageModel.dart';

class DataBaseService {
  Future<List<HomePageClass>> fetchData() async {
    http.Response response =
    await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
    if (response.statusCode == 200) {
      print("resss-->${response.body}");
      return (jsonDecode(response.body) as List<dynamic>)
          .map((e) => HomePageClass.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }
}