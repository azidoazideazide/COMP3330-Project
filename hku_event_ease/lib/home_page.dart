import 'package:flutter/material.dart';

import 'grid_view.dart';
import 'list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

enum ViewType { grid, list }

class _HomePageState extends State<HomePage> {
  ViewType _currentView = ViewType.grid;

  void _selectView(ViewType view) {
    setState(() {
      _currentView = view;
    });
    Navigator.of(context).pop(); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    Widget pageBody;
    switch (_currentView) {
      case ViewType.grid:
        pageBody = const GridViewPage();
        break;
      case ViewType.list:
        pageBody = const ListViewPage();
        break;
    }

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
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
          ],
        ),
      ),
      body: pageBody,
    );
  }
}