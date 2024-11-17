// lib/event_list.dart

import 'package:flutter/material.dart';
import '../models/list_view_item.dart';
import '../models/favorite_item.dart';
import '../pages/details_page.dart';
import '../services/api_service.dart';
import '../widgets/tag_widget.dart'; // Import the TagWidget
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EventList extends StatefulWidget {
  final bool displayFavorites;
  final String searchQuery;
  final String selectedTag;

  EventList({
    this.displayFavorites = false,
    this.searchQuery = '',
    this.selectedTag = '',
  });

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final ApiService apiService = ApiService();
  List<ListViewItem> _allEventItems = [];
  List<ListViewItem> _filteredEventItems = [];
  List<FavoriteItem> _favoriteItems = [];
  bool _isLoading = true;

  final Map<String, Color> _tags = {
    'Sports': Colors.blueAccent,
    'Seminars': Colors.greenAccent,
    'Workshops': Colors.orangeAccent,
    'Clubs': Colors.purpleAccent,
    'Music': Colors.redAccent,
    'Networking': Colors.green,
    'Technology': Colors.cyanAccent,
    'Arts': Colors.pinkAccent,
  };

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _fetchEvents();
  }

  @override
  void didUpdateWidget(EventList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.selectedTag != widget.selectedTag ||
        oldWidget.displayFavorites != widget.displayFavorites) {
      _applyFilters();
    }
  }

  Future<void> _fetchEvents() async {
    final events = await apiService.fetchListViewItems();
    setState(() {
      _allEventItems = events;
      _applyFavorites();
      _applyFilters();
      _isLoading = false;
    });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteEvents = prefs.getString('favoriteEvents');
    if (favoriteEvents != null) {
      final List<dynamic> favoriteList = jsonDecode(favoriteEvents);
      setState(() {
        _favoriteItems = favoriteList.map((e) => FavoriteItem.fromJson(e)).toList();
      });
    } else {
      setState(() {
        _favoriteItems = [];
      });
    }
  }

  void _applyFavorites() {
    for (var item in _allEventItems) {
      item.isFavorite = _favoriteItems.any((fav) => fav.eventId == item.eventId);
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredEventItems = _allEventItems.where((item) {
        final matchesQuery = widget.searchQuery.isEmpty ||
            item.eventName.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
            item.tagName.toLowerCase().contains(widget.searchQuery.toLowerCase());
        final matchesTag = widget.selectedTag.isEmpty ||
            item.tagName.toLowerCase() == widget.selectedTag.toLowerCase();
        final matchesFavorite = !widget.displayFavorites || item.isFavorite;
        return matchesQuery && matchesTag && matchesFavorite;
      }).toList();
    });
  }

  Future<void> _toggleFavorite(ListViewItem item, {bool applyFilters = true}) async {
    setState(() {
      item.isFavorite = !item.isFavorite;
      if (item.isFavorite) {
        _favoriteItems.add(FavoriteItem(eventId: item.eventId));
      } else {
        _favoriteItems.removeWhere((fav) => fav.eventId == item.eventId);
      }
      if (applyFilters) {
        _applyFilters();
      }
    });
    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = _favoriteItems.map((e) => e.toJson()).toList();
    prefs.setString('favoriteEvents', jsonEncode(favorites));
  }

  void _navigateToDetailsPage(BuildContext context, String eventId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(imageId: eventId),
      ),
    );
    // After returning from DetailsPage, reload favorites and apply them
    await _loadFavorites();
    setState(() {
      _applyFavorites();
      _applyFilters();
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_filteredEventItems.isEmpty) {
      return Center(child: Text('No events found.'));
    }
    return ListView.builder(
      itemCount: _filteredEventItems.length,
      itemBuilder: (BuildContext context, int index) {
        final eventItem = _filteredEventItems[index];
        final tagColor = _tags[eventItem.tagName] ?? Colors.grey;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                color: Colors.grey[200],
                child: InkWell(
                  onTap: () {
                    _navigateToDetailsPage(context, eventItem.eventId);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image.network Widget
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            eventItem.coverPhotoLink,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[300],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        // Event Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                eventItem.eventName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${eventItem.organizerName}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${_formatDateTime(eventItem.startDateTime)}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              TagWidget(
                                tag: eventItem.tagName,
                                color: tagColor,
                                isSelected: false, // Set to true if needed
                                onTap: () {
                                  // Optional: Handle tag tap if necessary
                                },
                              ),
                              
                            ],
                          ),
                          
                        ),
                        // Favorite IconButton
                        IconButton(
                          icon: Icon(
                            eventItem.isFavorite ? Icons.favorite : Icons.favorite_border,
                          ),
                          color: eventItem.isFavorite ? Colors.red : Colors.grey,
                          onPressed: () => _toggleFavorite(eventItem, applyFilters: !widget.displayFavorites),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}