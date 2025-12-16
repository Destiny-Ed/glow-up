import 'dart:developer';
import 'dart:io';

import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/services/storage_service.dart';
import 'package:glow_up/services/user_service.dart';
import 'package:glow_up/models/user_model.dart';

class UserViewModel extends BaseViewModel {
  late UserService _userService;
  UserModel? _user;
  late String uid;

  UserModel? get user => _user;
  bool get isProfileComplete => _user?.isProfileComplete ?? false;

  File? _avatarImage;
  String _username = 'username';
  String _phoneNumber = '';
  String _gender = 'Select your gender';
  String _country = 'Where are you from?';
  DateTime? _birthDate;
  bool _isCheckingUsername = false;
  bool _isUsernameAvailable = true;
  String? _usernameError;

  // Getters
  File? get avatarImage => _avatarImage;
  String get username => _username;
  String get phoneNumber => _phoneNumber;
  String get gender => _gender;
  String get country => _country;
  DateTime? get birthDate => _birthDate;

  bool get isCheckingUsername => _isCheckingUsername;
  bool get isUsernameAvailable => _isUsernameAvailable;
  String? get usernameError => _usernameError;

  void initialize(String userUid) {
    uid = userUid;
    _userService = UserService(uid);
    loadUser();
  }

  // Initialize / load existing user data
  Future<void> loadUser() async {
    setLoading(true);
    try {
      _user = await _userService.getCurrentUser();

      // Pre-fill form fields if user exists
      if (_user != null) {
        _username = _user!.userName ?? '@glowup_star';
        _phoneNumber = _user!.phoneNumber ?? '';
        _gender = _user!.gender ?? 'Select your gender';
        _country = _user!.location ?? 'Where are you from?';
        _birthDate = _user!.dob;
      }
    } catch (e) {
      setError('Failed to load profile');
    }
    setLoading(false);
  }

  // Local updates (for form)
  void updateAvatar(File? image) {
    _avatarImage = image;
    setLoading(false);
  }

  void updateUsername(String value) {
    _username = value;
    setLoading(false);
  }

  void updatePhone(String value) {
    _phoneNumber = value;
    setLoading(false);
  }

  void updateGender(String value) {
    _gender = value;
    setLoading(false);
  }

  void updateCountry(String value) {
    _country = value;
    setLoading(false);
  }

  void updateBirthDate(DateTime? date) {
    _birthDate = date;
    setLoading(false);
  }

  Future<void> checkUsername(String username) async {
    if (username.isEmpty || username.length < 3) {
      _isUsernameAvailable = false;
      _usernameError = 'Username must be 2+ characters';
      setLoading(false);

      return;
    }

    _isCheckingUsername = true;
    setLoading(false);
    final lower = username.replaceFirst('@', '').toLowerCase();

    final available = await _userService.isUsernameAvailable(lower);

    _isUsernameAvailable = available;
    _usernameError = available ? null : 'Username already taken';
    _isCheckingUsername = false;
    setLoading(false);
  }

  // Save full profile
  Future<bool> saveProfile() async {
    if (!isFormValid()) {
      setError('Please complete all fields');
      return false;
    }

    if (!await _userService.isUsernameAvailable(_username)) {
      setError('Username taken');
      return false;
    }

    setLoading(true);
    try {
      // Normalize phone
      // final normalizedPhone = _normalizePhone(_phoneNumber);
      // if (normalizedPhone == null) {
      //   setError('Invalid phone number');
      //   setLoading(false);
      //   return false;
      // }

      // Upload avatar if changed (implement in StorageService)
      final String? avatarUrl = _avatarImage != null
          ? await StorageService().uploadProfilePhoto(_avatarImage!, uid)
          : _user?.profilePictureUrl;

      final updatedUser = UserModel(
        id: _user?.id ?? '',
        name: _username.replaceFirst('@', ''),
        userName: _username,
        phoneNumber: _phoneNumber,
        gender: _gender != 'Select your gender' ? _gender : null,
        location: _country != 'Where are you from?' ? _country : null,
        dob: _birthDate,
        profilePictureUrl: avatarUrl,
        email: _user?.email,
        dateCreated: _user?.dateCreated ?? DateTime.now(),
        lastActiveDate: DateTime.now(),
        streakCount: _user?.streakCount ?? 0,
        votes: _user?.votes ?? 0,
        battles: _user?.battles ?? 0,
        winDates: _user?.winDates ?? [],
        platform: Platform.operatingSystem,
        isProfilePrivate: _user?.isProfilePrivate ?? false,
        friendUids: _user?.friendUids ?? [],
        pendingRequestUids: _user?.pendingRequestUids ?? [],
        sentRequestUids: _user?.sentRequestUids ?? [],
        blockedUids: _user?.blockedUids ?? [],
      );

      await _userService.updateProfile(updatedUser);
      // Reserve
      await _userService.reserveUsername(username, uid);
      _user = updatedUser;

      clearError();
      setLoading(false);
      return true;
    } catch (e) {
      setError('Save failed: $e');
      setLoading(false);
      return false;
    }
  }

  bool isFormValid() {
    print(_username);
    print(_phoneNumber);
    print(_gender);
    print(_country);
    print(_birthDate);
    return _username.isNotEmpty &&
        _username.length > 2 &&
        _phoneNumber.isNotEmpty &&
        _gender != 'Select your gender' &&
        _country != 'Where are you from?' &&
        _birthDate != null;
  }

  // String? _normalizePhone(String raw) {
  //   final cleaned = raw.replaceAll(RegExp(r'\D'), '');
  //   if (cleaned.length == 10) return '+1$cleaned';
  //   if (cleaned.length == 11 && cleaned.startsWith('1')) return '+$cleaned';
  //   if (cleaned.startsWith('+')) return cleaned;
  //   return null;
  // }

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
