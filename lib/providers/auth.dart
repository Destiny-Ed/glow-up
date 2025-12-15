// viewmodels/auth_viewmodel.dart

import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/services/auth_service.dart';
import 'package:glow_up/models/user_model.dart';
import 'package:glow_up/services/user_service.dart';

class AuthViewModel extends BaseViewModel {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  String? _currentUid;
  bool _isNewUser = false;

  UserModel? get currentUser => _currentUser;
  String? get currentUid => _currentUid;
  bool get isLoggedIn => _authService.isLoggedIn;
  bool get isNewUser => _isNewUser;

  Future<void> signInWithGoogle() async {
    setLoading(true);
    clearError();

    final result = await _authService.signInWithGoogle();

    if (result['user'] != null) {
      _isNewUser = result['isNewUser'];
      // Fetch full user if not new
      if (!_isNewUser) {
        await loadCurrentUser();
      }
    } else {
      setError('Google sign-in failed');
    }

    setLoading(false);
  }

  Future<void> signInWithApple() async {
    setLoading(true);
    clearError();

    final result = await _authService.signInWithApple();

    if (result['user'] != null) {
      _isNewUser = result['isNewUser'];
      if (!_isNewUser) {
        await loadCurrentUser();
      }
    } else {
      setError('Apple sign-in failed');
    }

    setLoading(false);
  }

  Future<void> loadCurrentUser() async {
    final uid = _authService.currentUid;
    if (uid == null) return;

    setLoading(true);
    try {
      // You'll add this to UserService
      final user = await UserService(uid).getCurrentUser();
      _currentUser = user;
      _currentUid = uid;
    } catch (e) {
      setError('Failed to load user');
    }
    setLoading(false);
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    _isNewUser = false;
    notifyListeners();
  }
}
