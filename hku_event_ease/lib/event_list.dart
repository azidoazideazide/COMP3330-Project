import 'package:flutter/material.dart';
import 'models/list_view_item.dart';
import 'models/favorite_item.dart';
import 'pages/details_page.dart';
import 'services/api_service.dart';
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
    _applyFavorites();
    _applyFilters();
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
      return Center(child: Text('No events found'));
    }
    return ListView.builder(
      itemCount: _filteredEventItems.length,
      itemBuilder: (BuildContext context, int index) {
        final eventItem = _filteredEventItems[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
          leading: Image.network(
            eventItem.coverPhotoLink,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          contentPadding: EdgeInsets.all(16.0),
          title: Text(
            eventItem.eventName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventItem.tagName,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 4.0),
            Text(
              _formatDateTime(eventItem.startDateTime),
              style: TextStyle(color: Colors.grey[600]),
            ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                eventItem.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
              color: eventItem.isFavorite ? Colors.red : Colors.grey,
              onPressed: () => _toggleFavorite(eventItem, applyFilters: !widget.displayFavorites),
            ),
            onTap: () {
              _navigateToDetailsPage(context, eventItem.eventId);
            },
          ),
        );
      },
    );
  }
}