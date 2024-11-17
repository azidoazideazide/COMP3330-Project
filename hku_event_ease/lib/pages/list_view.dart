import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../event_search_bar.dart';
import '../event_list.dart';
import '../widgets/tag_widget.dart';

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
            child: Row(
              children: _selectedTag.isEmpty
                  ? _tags.entries.map((entry) => TagWidget(
                        tag: entry.key,
                        color: entry.value,
                        isSelected: false,
                        onTap: () => _filterByTag(entry.key),
                      )).toList()
                  : [
                      TagWidget(
                        tag: _selectedTag,
                        color: _tags[_selectedTag]!,
                        isSelected: true,
                        onTap: _resetTagFilter,
                      ),
                    ],
            ),
          ),
          ),
            Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
              DateFormat('EEEE, d MMMM, y').format(DateTime.now()),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
}