import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'details_page.dart';
import 'services/api_service.dart';
import 'models/list_view_item.dart';

class ListViewPage extends StatefulWidget {
  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  late Future<List<ListViewItem>> _pendingEventItems;
  final ApiService apiService = ApiService();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _pendingEventItems = apiService.fetchListViewItems();
  }

  void _navigateToDetailsPage(BuildContext context, String imageId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(imageId: imageId),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    String formattedDate = DateFormat('d MMM y').format(dateTime);
    String formattedTime = DateFormat('HH:mm').format(dateTime);
    return '$formattedDate - $formattedTime';
  }

  List<ListViewItem> _searchItems(List<ListViewItem> items, String query) {
    return items.where((item) =>
        item.eventName.toLowerCase().contains(query.toLowerCase())).toList();
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ListViewItem>>(
              future: _pendingEventItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data found'));
                } else {
                  final items = _searchItems(snapshot.data!, _searchQuery);
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        color: Colors.grey[200],
                        child: InkWell(
                          onTap: () {
                            _navigateToDetailsPage(context, item.eventId);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.event),
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
                                          fontWeight: FontWeight.bold
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
                                    ],
                                  ),
                                ),
                                Icon(Icons.favorite_border),
                              ],
                            ),
                          ),
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
    );
  }
}