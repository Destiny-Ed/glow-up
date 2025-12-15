import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isLightTheme = false;
  bool get isLightTheme => _isLightTheme;
  set isLightTheme(bool theme) {
    _isLightTheme = theme;
    notifyListeners();
  }
}