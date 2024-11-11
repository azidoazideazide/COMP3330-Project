import 'package:flutter/material.dart';
import 'services/fetch.dart';

class DetailsPage extends StatefulWidget {
  final int imageId;

  DetailsPage({required this.imageId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future<Map<String, dynamic>> _imageData;

  @override
  void initState() {
    super.initState();
    _imageData = loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _imageData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            final imageInfo = snapshot.data!;
            return ListView.builder(
              itemCount: imageInfo.length,
              itemBuilder: (context, index) {
                final key = imageInfo.keys.elementAt(index);
                final value = imageInfo[key];
                return ListTile(
                  title: Text('Image $key'),
                  subtitle: Text(value.toString()),
                );
              },
            );
          }
        },
      ),
    );
  }
}