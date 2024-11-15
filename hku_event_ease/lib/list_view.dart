import 'package:flutter/material.dart';
import 'details_page.dart';
import 'services/api_service.dart';
import 'models/list_view_item.dart';
import 'event_search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ListViewPage extends StatefulWidget {
  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  late Future<List<ListViewItem>> _pendingEventItems;
  final ApiService apiService = ApiService();
  List<ListViewItem> _filteredEventItems = [];
  String _searchQuery = '';
  String _selectedTag = '';

  final Map<String, Color> _tags = {
    'Sports': Colors.blueAccent,
    'Seminars': Colors.greenAccent,
    'Workshops': Colors.orangeAccent,
    'Clubs': Colors.purpleAccent,
    'Music': Colors.redAccent,
    'Networking': Colors.green,
    'Technology': Colors.cyanAccent,
    'Art': Colors.pinkAccent,
  };

  @override
  void initState() {
    super.initState();
    _pendingEventItems = apiService.fetchListViewItems();
    _loadFavorites();
    _pendingEventItems.then((items) {
      setState(() {
        _filteredEventItems = items;
      });
    });
  }

  void _navigateToDetailsPage(BuildContext context, String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(imageId: eventId),
      ),
    );
  }

  void _filterEvents(String query) {
    setState(() {
      _searchQuery = query;
      _pendingEventItems.then((items) {
        _filteredEventItems = items.where((item) {
          return item.eventName.toLowerCase().contains(query.toLowerCase()) ||
                 item.tagName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    });
  }

  void _filterByTag(String tag) {
    setState(() {
      _selectedTag = tag;
      _pendingEventItems.then((items) {
        _filteredEventItems = items.where((item) {
          return item.tagName.toLowerCase() == tag.toLowerCase();
        }).toList();
      });
    });
  }

  void _resetTagFilter() {
    setState(() {
      _selectedTag = '';
      _pendingEventItems.then((items) {
        _filteredEventItems = items;
      });
    });
  }

  // Method to build the tag widgets
  Widget _buildTag(String tag, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _filterByTag(tag);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tag,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              if (_selectedTag == tag)
                GestureDetector(
                  onTap: () {
                    _resetTagFilter();
                  },
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

      // Toggle favorite status and store it
  Future<void> _toggleFavorite(ListViewItem item) async {
    setState(() {
      item.isFavorite = !item.isFavorite;
    });
    await _saveFavorites();
  }

  // Save favorite items to SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = _pendingEventItems.then((items) =>
        items.where((item) => item.isFavorite).map((e) => e.toJson()).toList());
    prefs.setString('favoriteEvents', jsonEncode(await favorites));
    //debug
    //print("Saved favorites: ${prefs.getString('favoriteEvents')}");
  }

  // Load favorite items from SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteJson = prefs.getString('favoriteEvents') ?? '[]';
    final List<dynamic> favoriteList = jsonDecode(favoriteJson);
    final favoriteItems = favoriteList.map((json) => ListViewItem.fromJson(json)).toList();
    //debug
    //print("Loaded favorites: $favoriteItems");

    // Wait for _pendingEventItems to complete and get the list of items
    final eventItems = await _pendingEventItems;

    setState(() {
      for (var item in favoriteItems) {
        // Find the index of the favorite item in the fetched list
        final index = eventItems.indexWhere((e) => e.eventName == item.eventName);
        if (index != -1) eventItems[index].isFavorite = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List View'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            EventSearchBar(onSearch: _filterEvents),
            // Tags Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _selectedTag.isEmpty
                    ? _tags.entries.map((entry) => _buildTag(entry.key, entry.value)).toList()
                    : [_buildTag(_selectedTag, _tags[_selectedTag]!)],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ListViewItem>>(
                future: _pendingEventItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No events found'));
                  } else {
                    final eventItems = _searchQuery.isEmpty && _selectedTag.isEmpty
                        ? snapshot.data!
                        : _filteredEventItems;
                    return ListView.builder(
                      itemCount: eventItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final eventItem = eventItems[index];
                        return ListTile(
                          title: Text(eventItem.eventName),
                          subtitle: Text('${eventItem.tagName} - ${eventItem.startDateTime}'),
                          trailing: IconButton(
                          icon: Icon(
                            eventItem.isFavorite ? Icons.favorite : Icons.favorite_border,
                          ),
                          color: eventItem.isFavorite ? Colors.red : Colors.grey,
                          onPressed: () => _toggleFavorite(eventItem),
                        ),
                          onTap: () {
                            _navigateToDetailsPage(context, eventItem.eventId);
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}