import 'package:flutter/material.dart';
import '../event_search_bar.dart';
import '../event_list.dart';

class ListViewPage extends StatefulWidget {
  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
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

  void _filterEvents(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _filterByTag(String tag) {
    setState(() {
      _selectedTag = tag;
    });
  }

  void _resetTagFilter() {
    setState(() {
      _selectedTag = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List View'),
      ),
      body: Column(
        children: <Widget>[
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
            child: EventList(
              searchQuery: _searchQuery,
              selectedTag: _selectedTag,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag, Color color) {
    return GestureDetector(
      onTap: () {
        if (_selectedTag == tag) {
          _resetTagFilter();
        } else {
          _filterByTag(tag);
        }
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
              Icon(
                Icons.cancel,
                color: Colors.white,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}