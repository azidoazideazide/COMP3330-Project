import 'package:flutter/material.dart';
import 'details_page.dart';
import 'event_search_bar.dart';
import 'models/grid_view_item.dart';
import 'services/api_service.dart';

class GridViewPage extends StatefulWidget {
  const GridViewPage({super.key});

  @override
  State<GridViewPage> createState() => _GridViewPageState();
}

class _GridViewPageState extends State<GridViewPage> {
  late Future<List<GridViewItem>> _pendingEventItems;
  final ApiService apiService = ApiService();

  // placeholder function. Should be replaced by a show event detail page
  void _navigateToDetailsPage(BuildContext context, String eventId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(imageId: eventId),
      ),
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
              child: FutureBuilder(
                  future: _pendingEventItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No events found'));
                    } else {
                      final eventItems = snapshot.data!;
                      return GridView.builder(
                        itemCount: eventItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final eventItem = eventItems[index];

                          return GestureDetector(
                            // Later Implement and link to a detailed view
                            onTap: () {
                              _navigateToDetailsPage(context, eventItem.eventId);
                            },

                            child: Image.network(eventItem.coverPhotoLink,
                                fit: BoxFit.contain),
                          );
                        },
                      );
                    }
                  })),
        ],
      ),
    );
  }
}
