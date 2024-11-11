import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/list_view_item.dart';

class ApiService {
  final String baseUrl;
  // will be changed to real one later on
  // real one will then be put in .env ?
  ApiService({this.baseUrl = 'http://<IPV4>:8000'}); //please enter your own ipv4

  Future<List<ListViewItem>> fetchListViewItems() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));

    if(response.statusCode == 200){
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ListViewItem.fromJson(e)).toList();
    } 
    else {
      throw Exception('Failed to fetch data from $baseUrl/events');
    }
  }

  // Future<List<GridViewItem>> fetchGridViewItems() async
  // }

  // Future<DetailViewItem> fetchDetailViewItem() async{
  //}
}