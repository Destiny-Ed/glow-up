// viewmodels/post_viewmodel.dart

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glow_up/models/post_model.dart';
import 'package:glow_up/models/user_model.dart';
import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/providers/user_view_model.dart';
import 'package:glow_up/services/post_service.dart';
import 'package:glow_up/services/storage_service.dart';
import 'package:glow_up/services/user_service.dart';

class PostViewModel extends BaseViewModel {
  late PostService _postService;
  late String uid;
  List<PostModel> _todayPosts = [];
  List<PostModel> _myPosts = [];
  PostModel? _currentUserTodayPost;

  List<PostModel> get todayPosts => _todayPosts;
  List<PostModel> get myPosts => _myPosts;
  PostModel? get currentUserTodayPost => _currentUserTodayPost;
  bool get hasPostedToday => _currentUserTodayPost != null;

  Map<String, UserModel> _userCache = {};

  void initialize(String uid) {
    uid = uid;
    _postService = PostService(uid);
    setLoading(false);
  }

  Future<UserModel> getUserForPost(String userId) async {
    if (_userCache.containsKey(userId)) {
      return _userCache[userId]!;
    }
    final user = await UserService(userId).getUser(userId);
    _userCache[userId] = user;
    return user;
  }

  /// Listen to today's global feed (for HomeScreen)
  void listenToTodayFeed() {
    setLoading(true);
    _postService.getTodaysFeed().listen(
      (posts) {
        _todayPosts = posts;
        notifyListeners();
        setLoading(false);
      },
      onError: (e) {
        setError('Failed to load feed');
        setLoading(false);
      },
    );
  }

  Future<bool> hasUserFiredPost(String postId, String userId) async {
    final doc = await _postService.feed
        .doc(postId)
        .collection('fires')
        .doc(userId)
        .get();
    return doc.exists;
  }

  Future<bool> hasUserLikedPost(String postId, String userId) async {
    final doc = await _postService.feed
        .doc(postId)
        .collection('likes')
        .doc(userId)
        .get();
    return doc.exists;
  }

  void listenToFriendsFeed(UserViewModel userVm) {
    final friendUids = userVm.user?.friendUids ?? [];

    if (friendUids.isEmpty) {
      _todayPosts = [];
      notifyListeners();
      return;
    }

    setLoading(true);
    final todayStart = Timestamp.fromDate(
      DateTime.now().copyWith(hour: 0, minute: 0, second: 0),
    );

    _postService.feed
        .where('userId', whereIn: friendUids)
        .where('timestamp', isGreaterThanOrEqualTo: todayStart)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
          _todayPosts = snapshot.docs
              .map(
                (doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList();
          notifyListeners();
          setLoading(false);
        });
  }

  /// Listen to current user's all posts (for Profile Gallery & Trophy Room)
  void listenToMyPosts() {
    setLoading(true);
    _postService
        .getUserPostsStream(_postService.currentUid)
        .listen(
          (posts) {
            _myPosts = posts;

            // Find today's post if exists
            final today = DateTime.now();
            final todayStart = DateTime(today.year, today.month, today.day);
            _currentUserTodayPost = posts.firstWhere(
              (post) => post.timestamp.isAfter(todayStart),
              orElse: () => PostModel(
                id: "",
                userId: "",
                imageUrl: "",
                timestamp: DateTime.now(),
              ),
            );

            notifyListeners();
            setLoading(false);
          },
          onError: (e) {
            setError('Failed to load your posts');
            setLoading(false);
          },
        );
  }

  /// Upload a new daily post
  Future<bool> uploadTodayPost({
    required File image,
    String? caption,
    List<String> hashtags = const [],
    String? challenge,
  }) async {
    if (hasPostedToday) {
      setError('You already posted today!');
      return false;
    }

    setLoading(true);
    try {
      final String imageUrl = await StorageService().uploadPostImage(image);

      final newPost = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _postService.currentUid,
        imageUrl: imageUrl,
        caption: caption,
        hashtags: hashtags,
        timestamp: DateTime.now(),
        challenge: challenge,
        fireCount: 0,
        likesCount: 0,
      );

      log(newPost.toJson().toString());

      await _postService.addPost(newPost);
      setLoading(false);
      return true;
    } catch (e) {
      setError('Upload failed: $e');
      setLoading(false);
      return false;
    }
  }

  /// Fire a post (vote)
  Future<void> firePost(String postId, String postOwnerId) async {
    try {
      await _postService.firePost(postId, postOwnerId);
    } catch (e) {
      setError('Vote failed');
    }
  }

  Future<void> likePost(String postId) async {
    try {
      await _postService.likePost(postId);
    } catch (e) {
      setError('Vote failed');
    }
  }

  /// Check if current user can post today
  Future<bool> canPostToday() async {
    final canUserPost = await _postService.canUserPostToday(
      _postService.currentUid,
    );
    return canUserPost;
  }

  @override
  void dispose() {
    // Streams auto-close via Firestore
    super.dispose();
  }
}
