import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  List<GridViewItem> _filteredEventItems = [];
  String _searchQuery = '';

  void _filterEvents(String query) {
    setState(() {
      _searchQuery = query;
      _pendingEventItems.then((items) {
        _filteredEventItems = items.where((item) {
          return item.eventName.toLowerCase().contains(query.toLowerCase()) ||
              item.tagName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    });
  }

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
          EventSearchBar(onSearch: _filterEvents),
          Expanded(
            child: FutureBuilder(
                future: _pendingEventItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No events found'));
                  } else {
                    final eventItems = _searchQuery.isEmpty
                        ? snapshot.data!
                        : _filteredEventItems;
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 3,
                      itemCount: eventItems.length,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          child: GestureDetector(
                            onTap: () {
                              _navigateToDetailsPage(
                                  context, eventItems[index].eventId);
                            },
                            child:
                                Image.network(eventItems[index].coverPhotoLink),
                          ),
                        );
                      },
                      staggeredTileBuilder: (index) => StaggeredTile.count(
                          eventItems[index].crossAxisCount,
                          eventItems[index].mainAxisCount),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
