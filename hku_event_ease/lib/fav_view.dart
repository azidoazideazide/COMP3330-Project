import 'package:flutter/material.dart';
import 'models/list_view_item.dart';
import 'event_list.dart';
import 'services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteViewPage extends StatefulWidget {
  @override
  _FavoriteViewPageState createState() => _FavoriteViewPageState();
}

class _FavoriteViewPageState extends State<FavoriteViewPage> {
  final ApiService apiService = ApiService();
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite View'),
      ),
      body: _favoriteItems.isEmpty
          ? Center(child: Text('No favorite items found'))
          : EventList(
              eventItems: _favoriteItems,
            ),
    );
  }
}