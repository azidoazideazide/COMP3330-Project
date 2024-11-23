import 'package:flutter/material.dart';
import '../event_list.dart';

class FavoriteViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite View'),
      ),
      body: EventList(
        displayFavorites: true,
        searchQuery: '',
        selectedTag: '',
      ),
    );
  }
}