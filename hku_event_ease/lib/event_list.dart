import 'package:flutter/material.dart';
import 'models/list_view_item.dart';
import 'details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EventList extends StatefulWidget {
  final List<ListViewItem> eventItems;

  EventList({required this.eventItems});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<ListViewItem> _favoriteItems = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteEvents = prefs.getString('favoriteEvents');
    if (favoriteEvents != null) {
      final List<dynamic> favoriteList = jsonDecode(favoriteEvents);
      setState(() {
        _favoriteItems = favoriteList.map((e) => ListViewItem.fromJson(e)).toList();
        // Update the favorite status in eventItems
        for (var item in widget.eventItems) {
          item.isFavorite = _favoriteItems.any((fav) => fav.eventId == item.eventId);
        }
      });
    }
  }

  Future<void> _toggleFavorite(ListViewItem item) async {
    setState(() {
      item.isFavorite = !item.isFavorite;
      if (item.isFavorite) {
        _favoriteItems.add(item);
      } else {
        _favoriteItems.removeWhere((i) => i.eventId == item.eventId);
      }
    });
    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = _favoriteItems.map((e) => e.toJson()).toList();
    prefs.setString('favoriteEvents', jsonEncode(favorites));
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
    return ListView.builder(
      itemCount: widget.eventItems.length,
      itemBuilder: (BuildContext context, int index) {
        final eventItem = widget.eventItems[index];
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
}