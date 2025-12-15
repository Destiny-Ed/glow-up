import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/services/user_service.dart';
import 'package:glow_up/models/user_model.dart';

class UserViewModel extends BaseViewModel {
  late UserService _userService;
  UserModel? _user;
  late String uid;

  UserModel? get user => _user;
  bool get isProfileComplete => _user?.isProfileComplete ?? false;

  void initialize(String userUid) {
    uid = userUid;
    _userService = UserService(uid);
    loadUser();
  }

  Future<void> loadUser() async {
    setLoading(true);
    try {
      _user = await _userService.getCurrentUser();
    } catch (e) {
      setError('Failed to load profile');
    }
    setLoading(false);
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    setLoading(true);
    try {
      await _userService.updateProfile(updatedUser);
      _user = updatedUser;
    } catch (e) {
      setError('Update failed');
    }
    setLoading(false);
  }

  Future<void> makeProfilePrivate(bool isPrivate) async {
    if (_user == null) return;
    setLoading(true);
    try {
      final updated = _user!.copyWith(isProfilePrivate: isPrivate);
      await _userService.updateProfile(updated);
      _user = updated;
    } catch (e) {
      setError('Failed to update privacy');
    }
    setLoading(false);
  }
}
