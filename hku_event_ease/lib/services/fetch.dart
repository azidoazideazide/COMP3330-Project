
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> loadJsonData() async {
  // Load the JSON file from the assets
  String jsonString = await rootBundle.loadString('assets/dummy_data/data.json');
  // Decode the JSON string into a Map\
  return json.decode(jsonString);
}