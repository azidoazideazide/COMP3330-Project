import 'package:flutter/material.dart';

import 'event_search_bar.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  final List<String> items = List.generate(100, (index) => 'Event ${index + 1}');

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
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          EventSearchBar(),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.event),
                  title: Text(items[index]),
                  onTap: () {
                  // Handle list item tap
                  _showImageInfo(context, 'Event ${index + 1}');
                  },
                );
              },
            )
          ),
        ],
      ),
    );
  }
}