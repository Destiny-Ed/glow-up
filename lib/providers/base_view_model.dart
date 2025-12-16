import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  void setLoading(bool loading) {
    _isLoading = loading;
    _update();
  }

  void setError(String? message) {
    _errorMessage = message;
    _update();
  }

  void clearError() {
    _errorMessage = null;
    _update();
  }

  void _update() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
