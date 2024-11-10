import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final int imageId;

  DetailsPage({required this.imageId});

  @override
  Widget build(BuildContext context) {
    // Simulate fetching data
    final imageInfo = 'Details for Image $imageId';

    return Scaffold(
      appBar: AppBar(
        title: Text('Image Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/$imageId.jpg'),
            SizedBox(height: 20),
            Text(
              imageInfo,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}