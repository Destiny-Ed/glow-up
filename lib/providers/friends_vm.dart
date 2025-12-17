import 'package:glow_up/models/user_model.dart';
import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/services/user_service.dart';

class FriendsViewModel extends BaseViewModel {
  late UserService _userService;
  late String uid;
  List<UserModel> friends = [];
  List<UserModel> pendingRequests = [];
  List<UserModel> searchResults = [];

  String searchQuery = '';

  void initialize(String userId) {
    uid = userId;
    _userService = UserService(uid);
    loadAll();
  }

  Future<void> loadAll() async {
    setLoading(true);
    await Future.wait([loadFriends(), loadPendingRequests()]);
    setLoading(false);
  }

  Future<void> loadFriends() async {
    final currentUser = await _userService.getCurrentUser();
    if (currentUser.friendUids.isEmpty) return;

    final friendUids = currentUser.friendUids;

    if (friendUids.isEmpty) {
      friends = [];
      return;
    }

    friends = await _userService.getUsersByUids(friendUids);
    notifyListeners();
  }

  Future<void> loadPendingRequests() async {
    final currentUser = await _userService.getCurrentUser();
    if (currentUser.pendingRequestUids.isEmpty) return;

    final requestUids = currentUser.pendingRequestUids;

    if (requestUids.isEmpty) {
      pendingRequests = [];
      return;
    }

    pendingRequests = await _userService.getUsersByUids(requestUids);
    notifyListeners();
  }

  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      searchResults = [];
      searchQuery = '';
      notifyListeners();
      return;
    }

    searchQuery = query;
    setLoading(true);
    searchResults = await _userService.searchUsers(query);
    setLoading(false);
  }

  Future<void> acceptRequest(String requesterUid) async {
    await _userService.acceptFriendRequest(requesterUid);
    await loadAll();
  }

  Future<void> declineRequest(String requesterUid) async {
    await _userService.declineFriendRequest(requesterUid);
    await loadAll();
  }

  Future<bool> sendFriendRequest(String targetUid) async {
    try {
      setLoading(true);
      await _userService.sendFriendRequest(targetUid);
      await loadAll();
      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to send friend request');
      setLoading(false);
      return false;
    }
  }
}
