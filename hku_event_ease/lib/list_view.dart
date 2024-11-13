import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List View'),
      ),
      body: FutureBuilder<List<ListViewItem>>(
        future: _pendingEventItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.eventName),
                  subtitle: Text('${item.tagName} - ${item.startDateTime}'),
                  onTap: () {
                    _navigateToDetailsPage(context, item.eventId);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}