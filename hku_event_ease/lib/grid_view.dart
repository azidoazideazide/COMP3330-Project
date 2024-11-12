import 'package:flutter/material.dart';

import 'event_search_bar.dart';
import 'models/grid_view_item.dart';
import 'api_service.dart';

class GridViewPage extends StatefulWidget {
  const GridViewPage({super.key});

  @override
  State<GridViewPage> createState() => _GridViewPageState();
}

class _GridViewPageState extends State<GridViewPage> {
  late Future<List<GridViewItem>> _pendingEventItems;
  final ApiService apiService = ApiService();

  // placeholder function. Should be replaced by a show event detail page
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
    _pendingEventItems = apiService.fetchGridViewItems();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          EventSearchBar(),
          Expanded(
              child: GridView.builder(
            itemCount: 20,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  _showImageInfo(context, 'Image ${index + 1}');
                },
                child: Image.asset(
                  'assets/images/${index + 1}.jpg',
                  fit: BoxFit.cover,
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
