import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme {
  Green,
  Blue,
  Orange,
}

class AppConfigProvider extends ChangeNotifier {
  String appLanguage = 'en';
  AppTheme appTheme = AppTheme.Green;
  ThemeMode themeMode = ThemeMode.system; // Add themeMode property

  Future<void> changeLanguage(String newLanguage) async {
    if (appLanguage == newLanguage) return;
    appLanguage = newLanguage;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', appLanguage);
    notifyListeners();
  }

  Future<void> changeTheme(AppTheme newTheme) async {
    if (appTheme == newTheme) return;
    appTheme = newTheme;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme', newTheme.index);
    notifyListeners();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('theme');
    if (themeIndex != null) {
      appTheme = AppTheme.values[themeIndex];
    }
    final savedThemeMode = prefs.getString('themeMode');
    if (savedThemeMode != null) {
      themeMode = ThemeMode.values.firstWhere(
              (element) => element.toString() == savedThemeMode,
          orElse: () => ThemeMode.system);
    }
    notifyListeners();
  }

  Future<void> changeThemeMode(ThemeMode newThemeMode) async {
    if (themeMode == newThemeMode) return;
    themeMode = newThemeMode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', newThemeMode.toString());
    notifyListeners();
  }
}
