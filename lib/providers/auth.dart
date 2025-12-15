import 'package:flutter/material.dart';
import 'package:glow_up/services/auth_service.dart';

class AuthenticationProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  final _authService = AuthService();

  Future<void> signIn(String method) async {
    await Future.delayed(const Duration(seconds: 2));
    _isAuthenticated = true;
    notifyListeners();
  }

  void signOut() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
