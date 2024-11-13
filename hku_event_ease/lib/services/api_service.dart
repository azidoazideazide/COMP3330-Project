import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/list_view_item.dart';
import '../models/detail_view_item.dart';
import '../models/grid_view_item.dart';

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
      final photosResponse = await http.get(Uri.parse('$baseUrl/coverPhotos'));
      if (photosResponse.statusCode == 200) {
      List<dynamic> photosData = jsonDecode(photosResponse.body);
      for (var photo in photosData) {
        if (photo['eventId'] == id) {
          data['coverPhotoLink'] = photo['coverPhotoLink'];
          break;
        }
      }
      } else {
        throw Exception('Failed to fetch photos from $baseUrl/coverPhotos');
      }
      return DetailViewItem.fromJson(data);
    } else {
      throw Exception('Failed to fetch data from $baseUrl/event/$id');
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