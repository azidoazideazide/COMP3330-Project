import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'services/api_service.dart';
import 'models/detail_view_item.dart';

class DetailsPage extends StatefulWidget {
  final String imageId;

  DetailsPage({required this.imageId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<DetailViewItem> _imageData;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _imageData = apiService.fetchDetailViewItem(widget.imageId);
  }

  void _addEvent(DetailViewItem eventInfo) {
    final event = Event(
      title: eventInfo.eventName,
      description: '${eventInfo.organizerName}, ${eventInfo.venue}',
      location: eventInfo.venue,
      startDate: eventInfo.startDateTime,
      endDate: DateTime.now().add(Duration(hours: 1)),
      iosParams: IOSParams(
        reminder: Duration(hours: 1),
        url: 'https://www.example.com',
      ),
      androidParams: AndroidParams(
        emailInvites: ['example@example.com'],
      ),
    );

    Add2Calendar.addEvent2Cal(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Details'),
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
                  Image.asset('assets/images/1.jpg'),
                  SizedBox(height: 20),
                  Text(
                    'Details for Image ${widget.imageId}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Title: ${imageInfo.eventName}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description: ${imageInfo.organizerName}',
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _addEvent(imageInfo),
                    child: Text('Add Event to Calendar'),
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