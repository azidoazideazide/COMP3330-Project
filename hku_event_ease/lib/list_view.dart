import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Widget _buildTag(String tag, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _filterByTag(tag);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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

  String _formatDateTime(DateTime dateTime) {
    String formattedDate = DateFormat('d MMM y').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return '$formattedDate - $formattedTime';
  }

  Future<void> _toggleFavorite(ListViewItem item) async {
    setState(() {
      item.isFavorite = !item.isFavorite;
    });
    await _saveFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteEventsJson = prefs.getString('favoriteEvents');

    if (favoriteEventsJson != null) {
      final favoriteEvents = json.decode(favoriteEventsJson) as List<dynamic>;

      setState(() {
        _pendingEventItems = _pendingEventItems.then((eventItems) {
          return eventItems.map((item) {
            item.isFavorite = favoriteEvents.contains(item.eventId);
            return item;
          }).toList();
        });
      });
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteEvents = await _pendingEventItems.then((eventItems) {
      return eventItems.where((item) => item.isFavorite).map((item) => item.eventId).toList();
    });

    await prefs.setString('favoriteEvents', json.encode(favoriteEvents));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HKU EVENTEASE'),
        actions: [
          IconButton(
            icon: Icon(Icons.sports),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.work),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.school),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            EventSearchBar(onSearch: _filterEvents),
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
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No events found'));
                  } else {
                    final eventItems = _searchQuery.isEmpty && _selectedTag.isEmpty
                        ? snapshot.data!
                        : _filteredEventItems;
                    return ListView.builder(
                      itemCount: eventItems.length,
                      itemBuilder: (context, index) {
                        final item = eventItems[index];
                        final tagColor = _tags[item.tagName] ?? Colors.grey;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
                          child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                color: Colors.grey[200],
                                child: InkWell(
                                  onTap: () {
                                    _navigateToDetailsPage(context, item.eventId);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            item.isFavorite ? Icons.favorite : Icons.favorite_border,
                                          ),
                                          color: item.isFavorite ? Colors.red : Colors.grey,
                                          onPressed: () => _toggleFavorite(item),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.eventName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Color(0xFF006400),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                '${item.organizerName}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${_formatDateTime(item.startDateTime)}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              
                                              
                                              
                                          
                                            
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                                decoration: BoxDecoration(
                                                  color: tagColor,
                                                  borderRadius: BorderRadius.circular(20.0),
                                                ),
                                                child: Text(
                                                  item.tagName,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}