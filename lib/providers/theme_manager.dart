import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  late SharedPreferences _sharedPreferences;
  bool _darkTheme = false;
  final String key = 'themeKey';

  bool get isDark => _darkTheme;

  ThemeManager() {
    _loadTheme();
  }

  Future<void> toggleTheme() async {
    _darkTheme = !_darkTheme;
    await _saveTheme();
    notifyListeners();
  }

  Future<void> _initPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> _saveTheme() async {
    await _initPrefs();
    await _sharedPreferences.setBool(key, _darkTheme);
  }

  Future<void> _loadTheme() async {
    await _initPrefs();
    _darkTheme = _sharedPreferences.getBool(key) ?? false;
    notifyListeners();
  }
}

bool isLightTheme(BuildContext context) {
  var isLight = Theme.of(context).brightness == Brightness.light;
  return isLight;
}
