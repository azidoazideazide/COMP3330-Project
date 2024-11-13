import 'package:flutter/material.dart';

import 'grid_view.dart';
import 'list_view.dart';
import 'fav_view.dart';

class HomePage extends StatefulWidget {
  final String title;
  // constructor
  const HomePage({super.key, required this.title});
  

  @override
  State<HomePage> createState() => _HomePageState();
}

enum ViewType { grid, list, favorite}

class _HomePageState extends State<HomePage> {
  ViewType _currentView = ViewType.grid;

  // Used in the onTap() for each View tab in the Drawer
  void _selectView(ViewType view) {
    setState(() {
      _currentView = view;
    });
    Navigator.of(context).pop(); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {

    // this part decide which to be the body of home page
    Widget pageBody;
    switch (_currentView) {
      case ViewType.grid:
        pageBody = const GridViewPage();
        break;
      case ViewType.list:
        pageBody = const ListViewPage();
        break;
      case ViewType.favorite:
        pageBody = const FavView(); // Add FavView as an option
        break;
    }

    // This Scaffold has appBar, drawer, and body
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Drawer: Side Nav Bar
      // This Drawer has a SizedBox for title and 2 ListTile to switch ViewType
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // The tiitle box for the drawer (nav bar)
            SizedBox(
              height: 100,
              child: const DrawerHeader(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(76, 175, 80, 1)),
                child: Text(
                  'Switch Display Mode',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              title: const Text('Grid View'),
              onTap: () => _selectView(ViewType.grid),
            ),
            ListTile(
              title: const Text('List View'),
              onTap: () => _selectView(ViewType.list),
            ),
            ListTile(
              title: const Text('Favorite View'), // Add Favorite View option
              onTap: () => _selectView(ViewType.favorite),
            ),
          ],
        ),
      ),
      body: pageBody,
    );
  }
}