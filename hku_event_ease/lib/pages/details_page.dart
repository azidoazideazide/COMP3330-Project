import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import '../services/api_service.dart';
import '../models/detail_view_item.dart';
import '../models/favorite_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  PageController _pageController = PageController();
  int _currentIndex = 0; // Tracks the current index for the PageView

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
        _isFavorite = favoriteItems.any(
            (item) => item.eventId == widget.imageId && item.isFavorite);
      });
    }
  }

  Future<void> _toggleFavorite(DetailViewItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteEvents = prefs.getString('favoriteEvents');
    List<FavoriteItem> favoriteItems = favoriteEvents != null
        ? (jsonDecode(favoriteEvents) as List)
            .map((e) => FavoriteItem.fromJson(e))
            .toList()
        : [];

    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      favoriteItems.add(FavoriteItem(eventId: item.eventId));
    } else {
      favoriteItems.removeWhere((fav) => fav.eventId == item.eventId);
    }

    await prefs.setString(
        'favoriteEvents', jsonEncode(favoriteItems.map((e) => e.toJson()).toList()));
  }

  void _addEvent(DetailViewItem eventInfo) {
    final event = Event(
      title: eventInfo.eventName,
      description:
          '${eventInfo.organizerName}, ${eventInfo.venue}',
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
            final eventInfo = snapshot.data!;
            // Assuming only one image; adjust if multiple images are available
            final List<String> imageUrls = [eventInfo.coverPhotoLink];
            // If DetailViewItem has multiple images, populate imageUrls accordingly
            // e.g., final List<String> imageUrls = eventInfo.imageUrls;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 60.0), // Space for the favorite icon
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Display
                      Container(
                        width: double.infinity,
                        child: imageUrls.length > 1
                            ? Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  PageView.builder(
                                    controller: _pageController,
                                    itemCount: imageUrls.length,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentIndex = index;
                                      });
                                    },
                                    itemBuilder: (context, index) {
                                      return Image.network(
                                        imageUrls[index],
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) return child;
                                          return Center(
                                              child: CircularProgressIndicator(
                                            value: progress.expectedTotalBytes != null
                                                ? progress.cumulativeBytesLoaded /
                                                    progress.expectedTotalBytes!
                                                : null,
                                          ));
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Center(child: Icon(Icons.broken_image));
                                        },
                                      );
                                    },
                                  ),
                                  if (imageUrls.length > 1)
                                    Positioned(
                                      bottom: 10,
                                      child: SmoothPageIndicator(
                                        controller: _pageController,
                                        count: imageUrls.length,
                                        effect: ExpandingDotsEffect(
                                          activeDotColor: Colors.white,
                                          dotColor: Colors.white54,
                                          dotHeight: 8,
                                          dotWidth: 8,
                                          expansionFactor: 3,
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            : Image.network(
                                imageUrls.first,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Center(
                                      child: CircularProgressIndicator(
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes!
                                        : null,
                                  ));
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(child: Icon(Icons.broken_image));
                                },
                              ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eventInfo.eventName,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Organizer: ${eventInfo.organizerName}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Venue: ${eventInfo.venue}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Start Time: ${DateFormat('dd MMM yyyy, hh:mm a').format(eventInfo.startDateTime)}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'End Time: ${DateFormat('dd MMM yyyy, hh:mm a').format(eventInfo.endDateTime)}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Description: ${eventInfo.description}',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => _addEvent(eventInfo),
                              icon: Icon(Icons.calendar_today),
                              label: Text('Add Event to Calendar'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 12.0),
                                textStyle:
                                    TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                            // Add more event details or remarks here if needed
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Favorite Icon fixed at the bottom center
                Positioned(
                  bottom: 16.0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: () => _toggleFavorite(eventInfo),
                      backgroundColor: _isFavorite ? Colors.red : Colors.blue,
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                      ),
                      tooltip: _isFavorite ? 'Unfavorite' : 'Favorite',
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}