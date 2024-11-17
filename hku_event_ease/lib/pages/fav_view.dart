import 'package:flutter/material.dart';
import '../event_list.dart';

class FavoriteViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Events'),
      ),
      body: EventList(
        displayFavorites: true,
      ),
    );
  }
}