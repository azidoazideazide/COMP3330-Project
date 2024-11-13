import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/list_view_item.dart';
import '../models/detail_view_item.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'http://10.0.2.2:8000'});

  Future<List<ListViewItem>> fetchListViewItems() async {
    final response = await http.get(Uri.parse('$baseUrl/events'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ListViewItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch data from $baseUrl/events');
    }
  }

  Future<DetailViewItem> fetchDetailViewItem(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/event/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      data['endDateTime'] = data['endDateTime'] ?? DateTime.parse(data['startDateTime']).add(Duration(hours: 1)).toIso8601String();
      return DetailViewItem.fromJson(data);
    } else {
      throw Exception('Failed to fetch data from $baseUrl/event/$id');
    }
  }
}