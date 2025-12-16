// viewmodels/post_viewmodel.dart

import 'dart:io';

import 'package:glow_up/models/post_model.dart';
import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/services/post_service.dart';
import 'package:glow_up/services/storage_service.dart';

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

  void initialize(String uid) {
    uid = uid;
    _postService = PostService(uid);
    setLoading(false);
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
      );

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
  Future<void> firePost(String postId) async {
    try {
      await _postService.firePost(postId);
    } catch (e) {
      setError('Vote failed');
    }
  }

  /// Check if current user can post today
  Future<bool> canPostToday() async {
    final hasPosted = await _postService.canUserPostToday(
      _postService.currentUid,
    );
    return !hasPosted;
  }

  @override
  void dispose() {
    // Streams auto-close via Firestore
    super.dispose();
  }
}
