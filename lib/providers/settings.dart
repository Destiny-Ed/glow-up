// viewmodels/settings_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:glow_up/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  late UserService _userService;
  late String uid;
  bool _battleReminders = true;
  bool _newVotesAlerts = true;
  bool _isProfilePrivate = false;
  bool _isLightTheme = false;

  bool get battleReminders => _battleReminders;
  bool get newVotesAlerts => _newVotesAlerts;
  bool get isProfilePrivate => _isProfilePrivate;
  bool get isLightTheme => _isLightTheme;

  void initialize(String uid) {
    uid = uid;
    _userService = UserService(uid);
    _loadPreferences();
  }

  set isLightTheme(bool theme) {
    _isLightTheme = theme;
    _saveThemePreference(theme);
  }

  Future<void> _saveThemePreference(bool isLight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('themeMode', isLight);
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _battleReminders = prefs.getBool('battleReminders') ?? true;
    _newVotesAlerts = prefs.getBool('newVotesAlerts') ?? true;
    _isLightTheme = prefs.getBool('themeMode') ?? true;

    // Load privacy from user doc
    final user = await _userService.getCurrentUser();
    _isProfilePrivate = user.isProfilePrivate;

    notifyListeners();
  }

  Future<void> toggleBattleReminders(bool value) async {
    _battleReminders = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('battleReminders', value);
    notifyListeners();
    // TODO: Update FCM topic subscription if using topics
  }

  Future<void> toggleNewVotesAlerts(bool value) async {
    _newVotesAlerts = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('newVotesAlerts', value);
    notifyListeners();
  }

  Future<void> toggleProfilePrivacy(bool value) async {
    _isProfilePrivate = value;
    await _userService.makeProfilePrivate(_userService.currentUid, value);
    notifyListeners();
  }
}
