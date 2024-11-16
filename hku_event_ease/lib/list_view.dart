import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'package:intl/intl.dart';
import 'models/list_view_item.dart';
import 'event_search_bar.dart';
import 'event_list.dart';

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
    _pendingEventItems.then((items) {
      setState(() {
        _filteredEventItems = items;
      });
    });
  }

  void _filterEvents(String query) {
    setState(() {
      _searchQuery = query;
      _filteredEventItems = _filteredEventItems.where((item) {
        return item.eventName.toLowerCase().contains(query.toLowerCase()) ||
               item.tagName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _filterByTag(String tag) {
    setState(() {
      _selectedTag = tag;
      _filteredEventItems = _filteredEventItems.where((item) {
        return item.tagName.toLowerCase() == tag.toLowerCase();
      }).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Events'),
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
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                DateFormat('EEEE, d MMMM, yyyy').format(DateTime.now()),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ListViewItem>>(
                future: _pendingEventItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No events found'));
                  } else {
                    final eventItems = _searchQuery.isEmpty && _selectedTag.isEmpty
                        ? snapshot.data!
                        : _filteredEventItems;
                    return EventList(
                      eventItems: eventItems,
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
}