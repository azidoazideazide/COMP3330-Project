import 'package:flutter/material.dart';
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
          SingleChildScrollView(
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