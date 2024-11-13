//import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/list_view_item.dart';
import 'models/grid_view_item.dart';

class ApiService {
  final String baseUrl;
  // will be changed to real one later on
  // real one will then be put in .env ?
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

  Future<List<GridViewItem>> fetchGridViewItems() async {
    List<dynamic> eventData;
    List<dynamic> coverPhotoData;

    final events = await http.get(Uri.parse('$baseUrl/events'));
    if (events.statusCode == 200) {
      eventData = jsonDecode(events.body);
    } else {
      throw Exception('Failed to fetch data from $baseUrl/events');
    }

    final coverPhotos = await http.get(Uri.parse('$baseUrl/coverPhotos'));
    if (coverPhotos.statusCode == 200) {
      coverPhotoData = jsonDecode(coverPhotos.body);
    } else {
      throw Exception('Failed to fetch data from $baseUrl/coverPhotos');
    }

    // combine eventData and coverPhotoData by eventId
    for (var event in eventData) {
      for (var coverPhoto in coverPhotoData) {
        if (event['eventId'] == coverPhoto['eventId']) {
          event['coverPhotoLink'] = coverPhoto['coverPhotoLink'];
          break;
        }
      }
    }

    return eventData.map((e) => GridViewItem.fromJson(e)).toList();
  }

  // Future<DetailViewItem> fetchDetailViewItem() async{
  //}
}
