import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(NovelReaderApp());
}

class NovelReaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Novel Reader',
      theme: ThemeData(
        brightness: Brightness.dark, // Set dark theme
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.black, // Dark background
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900], // Darker app bar
        ),
        textTheme: const TextTheme(
          
          bodySmall: TextStyle(color: Colors.white),
          bodyMedium:  TextStyle(color: Colors.white70),
          bodyLarge: TextStyle(color: Colors.white), // AppBar text color
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Icons in app bar
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
