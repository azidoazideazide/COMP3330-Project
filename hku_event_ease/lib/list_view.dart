import 'package:flutter/material.dart';
import 'event_search_bar.dart';
import 'models/list_view_item.dart';
import 'api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  late Future<List<ListViewItem>> _pendingEventItems;
  final ApiService apiService = ApiService();

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
    _loadFavorites();
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
          EventSearchBar(),
          Expanded(
            child: FutureBuilder<List<ListViewItem>>(
              future: _pendingEventItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No events found'));
                } else {
                  final eventItems = snapshot.data!;
                  return ListView.builder(
                    itemCount: eventItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final eventItem = eventItems[index];
                      return ListTile(
                        leading: Icon(Icons.event),
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
                          _showImageInfo(context, "Later Implement");
                        },
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