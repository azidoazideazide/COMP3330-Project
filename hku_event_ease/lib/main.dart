import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main() {
  runApp(const MyApp());
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.all(4),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Search',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'HKU EVENTEASE',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green, brightness: Brightness.light),
          textTheme: TextTheme(
            displayLarge: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
            // ···
            titleLarge: GoogleFonts.oswald(
              fontSize: 30,
              fontStyle: FontStyle.normal,
            ),
            bodyMedium: GoogleFonts.merriweather(),
            displaySmall: GoogleFonts.pacifico(),
          ),
        ),
        home: const GridViewPage(
          title: 'HKU EVENTEASE',
        ));
  }
}

class GridViewPage extends StatefulWidget {
  const GridViewPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<GridViewPage> createState() => _GridViewPageState();
}

class _GridViewPageState extends State<GridViewPage> {
  int _counter = 0;

  final List<String> items = List.generate(100, (index) => 'Item ${index + 1}');

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Remove any padding from the ListView.
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
              onTap: () {
                print("Grid View");
              },
            ),
            ListTile(
              title: const Text('List View'),
              onTap: () {
                print("List View");
              },
            ),
          ],
        ),
      ),
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
      body: Center(
        child: Column(
          children: <Widget>[
            SearchBar(),
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
      ),
    );
  }
}

// class ListViewPage extends StatefulWidget {
//   const ListViewPage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<ListViewPage> createState() => _ListViewPageState();
// }
//
// class _ListViewPageState extends State<ListViewPage> {
//   List<dynamic> _items = []; // Will hold the API data
//   bool _isLoading = true; // State to track if data is being loaded
//   bool _hasError = false; // State to track if there's an error
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchData(); // Fetch data when the page is initialized
//   }
//
//   Future<void> _fetchData() async {
//     // fetch the API
//   }
// }