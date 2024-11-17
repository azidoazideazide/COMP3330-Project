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
  bool _showRemarkDetails = false; // Controls the visibility of remark details

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
        backgroundColor: Color(0xFFFFFC5),
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
            return Column(
              children: [
                // Image of the activity with rounded edges
                ClipRRect(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)), // Rounded edges
                  child: Image.network(
                    eventInfo.coverPhotoLink,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                ),
                SizedBox(height: 16),
                // Container for the horizontally scrolling section
                Container(
                  height: 300, // Set height for the rectangular area
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.green[800], // Dark green color
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                            _showRemarkDetails = false; // Hide remark details on page change
                          });
                        },
                        children: [
                          _buildCombinedDateTimePage(
                            eventInfo.startDateTime,
                            eventInfo.endDateTime,
                          ),
                          _buildDetailPage('Venue', eventInfo.venue),
                          _buildDetailPage('Remark', "Click Below"),
                        ],
                      ),
                      // SmoothPageIndicator positioned at the top center
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: 3,
                            effect: WormEffect(
                              activeDotColor: Colors.white,
                              dotColor: Colors.grey,
                              dotHeight: 8,
                              dotWidth: 8,
                              spacing: 16,
                            ),
                          ),
                        ),
                      ),
                      // Navigation arrows
                      Positioned(
                        left: 8,
                        top: 80,
                        child: GestureDetector(
                          onTap: _currentIndex > 0
                              ? () {
                                  _pageController.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.green[800],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 80,
                        child: GestureDetector(
                          onTap: _currentIndex < 2
                              ? () {
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.green[800],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Remark details when tapped
                if (_currentIndex == 2)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showRemarkDetails = !_showRemarkDetails; // Toggle visibility
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Tap to view details',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ),
                // Display remark details under the container
                if (_showRemarkDetails && _currentIndex == 2)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Here are the details of the remark. This text can be extended to provide more information about the remark.',
                      style: TextStyle(fontSize: 16, color: Colors.black), // Updated text color for visibility
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCombinedDateTimePage(DateTime startDate, DateTime endDate) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Date',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            DateFormat('EEE, MMM d, yyyy').format(startDate),
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Time',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            '${DateFormat.jm().format(startDate)} - ${DateFormat.jm().format(endDate)}',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPage(String title, String content) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}