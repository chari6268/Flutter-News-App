import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    accentColor: Colors.orange,
    appBarTheme: AppBarTheme(color: Colors.blue),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.blueGrey,
    accentColor: Colors.teal,
    appBarTheme: AppBarTheme(color: Colors.blueGrey),
  );
}