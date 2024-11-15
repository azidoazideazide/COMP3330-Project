import 'package:flutter/material.dart';

import 'event_search_bar.dart';
import 'models/list_view_item.dart';
import 'api_service.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  late Future<List<ListViewItem>> _pendingEventItems;
  final ApiService apiService = ApiService();
  List<ListViewItem> _filteredEventItems = [];
  String _searchQuery = '';

  // Will be removed when the navigation to deatail view is done
  // now use to showcase each item is clickable
  void _showImageInfo(BuildContext context, String imageInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Image Info'),
          content: Text(imageInfo),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // do the API data fetching at the start of init this page
    _pendingEventItems = apiService.fetchListViewItems();
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
  
  // Scroll all the way to the return ListTile part 
  // ListTile part deal with layout of each event item in list view
  // TODO:
  //    1. the compoenet needs to be finalized
  //    2. the onTap() needs to link with the detailed view 
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          // Not sure if the search bar should be separated from the generation of this viewPage
          // since not sure if there will be difference of its mechanism between listView and gridView 
          EventSearchBar(onSearch: _filterEvents),
          Expanded(
            child: FutureBuilder<List<ListViewItem>>(
              future: _pendingEventItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No events found'));
                }
                else {
                  final eventItems = _searchQuery.isEmpty ? snapshot.data! : _filteredEventItems;
                  return ListView.builder(
                    itemCount: eventItems.length,

                    // This is actually a loop
                    itemBuilder: (BuildContext context, int index) {
                      final eventItem = eventItems[index];

                      // Later further finalize the component of a list view item
                      return ListTile(
                        leading: Icon(Icons.event),
                        title: Text(eventItem.eventName),
                        subtitle: Text('${eventItem.tagName} - ${eventItem.startDateTime}'),
                        
                        // Later Implement and link to a detailed view
                        onTap:() {
                          _showImageInfo(context, "Later Implement");
                        }
                      );
                    }
                  );
                }
              }
            ),
          ),
        ],
      )
    );
  }
}