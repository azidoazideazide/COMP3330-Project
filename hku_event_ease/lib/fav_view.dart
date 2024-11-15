import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'details_page.dart';
import 'models/list_view_item.dart';

class FavView extends StatefulWidget {
  const FavView({Key? key}) : super(key: key);

  @override
  State<FavView> createState() => _FavViewState();
}

class _FavViewState extends State<FavView> {
  late Future<List<ListViewItem>> _favoriteItems;

  @override
  void initState() {
    super.initState();
    _favoriteItems = _loadFavorites();
  }

  Future<List<ListViewItem>> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteJson = prefs.getString('favoriteEvents') ?? '[]';
    final List<dynamic> favoriteList = jsonDecode(favoriteJson);
    
    // Parse the favorite items from JSON
    return favoriteList
        .map((json) => ListViewItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  void _navigateToDetailsPage(BuildContext context, String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(imageId: eventId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Events'),
      ),
      body: Center(
        child: FutureBuilder<List<ListViewItem>>(
          future: _favoriteItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No favorite events found'));
            } else {
              final favoriteItems = snapshot.data!;
              return ListView.builder(
                itemCount: favoriteItems.length,
                itemBuilder: (BuildContext context, int index) {
                  final eventItem = favoriteItems[index];
                  return ListTile(
                    leading: Icon(Icons.event),
                    title: Text(eventItem.eventName),
                    subtitle: Text('${eventItem.tagName} - ${eventItem.startDateTime}'),
                    trailing: Icon(
                      Icons.favorite,
                      color: Colors.red,
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
    );
  }
}
