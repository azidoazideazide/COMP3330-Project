import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import '../services/api_service.dart';
import '../models/detail_view_item.dart';
import '../models/favorite_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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

  // Controllers for Image PageView and Details PageView
  final PageController _imagePageController = PageController();
  final PageController _detailsPageController = PageController();

  // Current indices for Image and Details PageViews
  int _imageCurrentIndex = 0;
  int _detailsCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    _imageData = apiService.fetchDetailViewItem(widget.imageId);
    _loadFavoriteStatus();
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    _detailsPageController.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteEvents = prefs.getString('favoriteEvents');
    if (favoriteEvents != null) {
      final List<dynamic> favoriteList = jsonDecode(favoriteEvents);
      final favoriteItems =
          favoriteList.map((e) => FavoriteItem.fromJson(e)).toList();
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

    await prefs.setString('favoriteEvents',
        jsonEncode(favoriteItems.map((e) => e.toJson()).toList()));
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

  // Helper widget to build combined date and time page
  Widget _buildCombinedDateTimePage(DateTime start, DateTime end) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Start: ${DateFormat('EEEE, d MMMM, y hh:mm a').format(start)}',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'End: ${DateFormat('EEEE, d MMMM, y hh:mm a').format(end)}',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper widget to build detail pages (Venue and Organizer)
  Widget _buildDetailPage(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style:
                TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            detail,
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper widget to build the horizontally scrollable section
  Widget _buildScrollableDetailsSection(DetailViewItem eventInfo) {
    return Container(
      height: 250, // Set height for the rectangular area
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
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
            controller: _detailsPageController,
            onPageChanged: (index) {
              setState(() {
                _detailsCurrentIndex = index;
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      DateFormat('EEEE, d MMMM, y').format(eventInfo.startDateTime),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Time',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '${DateFormat('h:mm a').format(eventInfo.startDateTime)} - ${DateFormat('h:mm a').format(eventInfo.endDateTime)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Venue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25, // Increased font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      eventInfo.venue,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // Increased font size
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Organizer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25, // Increased font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      eventInfo.organizerName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18, // Increased font size
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // SmoothPageIndicator positioned at the top center
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _detailsPageController,
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
          if (_detailsCurrentIndex > 0)
          Positioned(
            left: 8,
            bottom: 12,
            child: GestureDetector(
              onTap: _detailsCurrentIndex > 0
                  ? () {
                      _detailsPageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white54,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          if (_detailsCurrentIndex < 2)
          Positioned(
            right: 8,
            bottom: 12,
            child: GestureDetector(
              onTap: _detailsCurrentIndex < 2
                  ? () {
                      _detailsPageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white54,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.arrow_forward,
                    color:  Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        child: Container(
                          width: double.infinity, // Adjust height as needed
                          child: imageUrls.length > 1
                              ? Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    PageView.builder(
                                      controller: _imagePageController,
                                      itemCount: imageUrls.length,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _imageCurrentIndex = index;
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(16.0),
                                          child: Image.network(
                                            imageUrls[index],
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (context, child, progress) {
                                              if (progress == null) return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: progress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? progress
                                                              .cumulativeBytesLoaded /
                                                          progress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Center(
                                                  child: Icon(Icons.broken_image,
                                                      size: 50, color: Colors.grey));
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    if (imageUrls.length > 1)
                                      Positioned(
                                        bottom: 10,
                                        child: SmoothPageIndicator(
                                          controller: _imagePageController,
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
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Image.network(
                                    imageUrls.first,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    loadingBuilder:
                                        (context, child, progress) {
                                      if (progress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? progress.cumulativeBytesLoaded /
                                                  progress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return Center(
                                          child: Icon(Icons.broken_image,
                                              size: 50, color: Colors.grey));
                                    },
                                  ),
                                ),
                        ),
                      ),
                      // Scrollable Details Section
                      _buildScrollableDetailsSection(eventInfo),
                      // Description Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Description:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                eventInfo.description,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Add to Calendar Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _addEvent(eventInfo),
                          icon: Icon(Icons.calendar_today),
                          label: Text('Add Event to Calendar'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            textStyle: TextStyle(
                                fontSize: 16, color: Colors.white),
                            minimumSize: Size(double.infinity, 48), // Full width
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Register Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            final url = Uri.parse(eventInfo.registerLink);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Could not launch registration link')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 12.0),
                            textStyle: TextStyle(
                                fontSize: 16, color: Colors.white),
                            minimumSize: Size(150, 48), // Adjust width as needed
                          ),
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      // Additional content if any
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
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
              ],
            );
          }
        },
      ),
    );
  }
}