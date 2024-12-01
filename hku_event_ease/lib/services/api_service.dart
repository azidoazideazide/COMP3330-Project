
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/list_view_item.dart';
import '../models/detail_view_item.dart';
import '../models/grid_view_item.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'https://hku-eventease-backend.azurewebsites.net/api/events'});

  Future<List<ListViewItem>> fetchListViewItems() async {
    List<dynamic> eventData;

    final events = await http.get(Uri.parse('$baseUrl/list'));
    if (events.statusCode == 200) {
      eventData = jsonDecode(events.body);
    } else {
      throw Exception('Failed to fetch data from $baseUrl/list');
    }
    return eventData.map((e) => ListViewItem.fromJson(e)).toList();
  }

  Future<DetailViewItem> fetchDetailViewItem(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/detail?eventId=$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      data['endDateTime'] = data['endDateTime'] ??
          DateTime.parse(data['startDateTime'])
              .add(Duration(hours: 1))
              .toIso8601String();
              return DetailViewItem.fromJson(data);
    } else {
      throw Exception('Failed to fetch data from $baseUrl/detail?eventId=$id');
    }
  }

  Future<List<GridViewItem>> fetchGridViewItems() async {
    List<dynamic> eventData;

    final events = await http.get(Uri.parse('$baseUrl/grid'));
    if (events.statusCode == 200) {
      eventData = jsonDecode(events.body);

    } else {
      throw Exception('Failed to fetch data from $baseUrl/grid');
    }
    // combine eventData and coverPhotoData by eventId
      // calculate crossAxisCount and mainAxisCount
      for (var event in eventData) {
            int crossAxisCount;
            double mainAxisCount;
            double aspectRatio =
                event['coverPhotoWidth'] / event['coverPhotoHeight'];
            if (aspectRatio >= 2) {
              crossAxisCount = 2;
              mainAxisCount = 1;
            } else if (aspectRatio <= 0.5) {
              crossAxisCount = 1;
              mainAxisCount = 2;
            } else {
              crossAxisCount = 1;
              mainAxisCount = 1;
            }
            event['crossAxisCount'] = crossAxisCount;
            event['mainAxisCount'] = mainAxisCount;
            event.remove('coverPhotoWidth');
            event.remove('coverPhotoHeight');
      }
      return eventData.map((e) => GridViewItem.fromJson(e)).toList();
  }

}