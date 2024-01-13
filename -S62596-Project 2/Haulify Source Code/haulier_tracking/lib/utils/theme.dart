/*
Author: Nuha Nordin
Project: Haulify
File: theme.dart
*/
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData getCurrentTheme() {
    return _isDarkMode ? darkTheme : lightTheme;
  }
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 181, 234, 120),
  primarySwatch: Colors.lightGreen,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final ThemeData darkTheme = ThemeData(
  primaryColor: const Color.fromARGB(255, 181, 234, 120),
  primarySwatch: Colors.lightGreen,
  brightness: Brightness.dark,
);
