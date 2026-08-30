import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String themeKey = 'theme_mode';
  static const String lightMode = 'light';
  static const String darkMode = 'dark';
  static const String systemMode = 'system';

  String _currentTheme = systemMode;

  String get currentTheme => _currentTheme;

  ThemeMode get themeMode {
    switch (_currentTheme) {
      case lightMode:
        return ThemeMode.light;
      case darkMode:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> changeTheme(String theme) async {
    if (_currentTheme == theme) return;
    _currentTheme = theme;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeKey, theme);
  }

  Future<void> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentTheme = prefs.getString(themeKey) ??
        prefs.getString('theme') ??
        systemMode;
    notifyListeners();
  }
}

