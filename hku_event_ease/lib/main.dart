import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hku_event_ease/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'list_view.dart';
import 'grid_view.dart';

const String appTitle = 'HKU EventEase';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light),
        textTheme: TextTheme(
          displayLarge: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.oswald(fontSize: 30, fontStyle: FontStyle.normal),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),
      home: const HomePage(title: appTitle),
    );
  }
}