import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Field to track the current theme mode
  bool _isDarkMode = false;

  // Getter for the current theme mode
  bool get isDarkMode => _isDarkMode;

  // Method to toggle the theme mode
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners about the state change
  }

  // Getter for the current theme data
  ThemeData get themeData {
    return _isDarkMode
        ? ThemeData.dark().copyWith(
            primaryColor: Colors.blueGrey,
            accentColor: Colors.teal,
          )
        : ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            accentColor: Colors.orange,
          );
  }
}