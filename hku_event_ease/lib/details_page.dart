import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'services/api_service.dart';
import 'models/detail_view_item.dart';
import 'models/favorite_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DetailsPage extends StatefulWidget {
  final String imageId;

  DetailsPage({required this.imageId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<DetailViewItem> _imageData;
  final ApiService apiService = ApiService();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _imageData = apiService.fetchDetailViewItem(widget.imageId);
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteEvents = prefs.getString('favoriteEvents');
    if (favoriteEvents != null) {
      final List<dynamic> favoriteList = jsonDecode(favoriteEvents);
      final favoriteItems = favoriteList.map((e) => FavoriteItem.fromJson(e)).toList();
      setState(() {
        _isFavorite = favoriteItems.any((item) => item.eventId == widget.imageId && item.isFavorite);
      });
    }
  }

  Future<void> _toggleFavorite(DetailViewItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteEvents = prefs.getString('favoriteEvents');
    List<FavoriteItem> favoriteItems = favoriteEvents != null
        ? (jsonDecode(favoriteEvents) as List).map((e) => FavoriteItem.fromJson(e)).toList()
        : [];

    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      favoriteItems.add(FavoriteItem(eventId: item.eventId));
    } else {
      favoriteItems.removeWhere((fav) => fav.eventId == item.eventId);
    }

    await prefs.setString('favoriteEvents', jsonEncode(favoriteItems.map((e) => e.toJson()).toList()));
  }

  void _addEvent(DetailViewItem eventInfo) {
    final event = Event(
      title: eventInfo.eventName,
      description: '${eventInfo.organizerName}, ${eventInfo.venue}',
      location: eventInfo.venue,
      startDate: eventInfo.startDateTime,
      endDate: eventInfo.endDateTime,
      iosParams: IOSParams(reminder: Duration(hours: 1)),
      androidParams: AndroidParams(emailInvites: []),
    );

    Add2Calendar.addEvent2Cal(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: FutureBuilder<DetailViewItem>(
        future: _imageData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          } else {
            final imageInfo = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(imageInfo.coverPhotoLink),
                  SizedBox(height: 20),
                  Text(
                    imageInfo.eventName,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Organizer: ${imageInfo.organizerName}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Venue: ${imageInfo.venue}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Start Time: ${imageInfo.startDateTime}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'End Time: ${imageInfo.endDateTime}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _addEvent(imageInfo),
                    child: Text('Add Event to Calendar'),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => _toggleFavorite(imageInfo),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}