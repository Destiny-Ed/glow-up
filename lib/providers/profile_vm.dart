import 'package:glow_up/providers/base_view_model.dart';
import 'package:glow_up/services/post_service.dart';
import 'package:glow_up/models/post_model.dart';

class ProfileViewModel extends BaseViewModel {
  late String uid;
  late PostService _postService;
  List<PostModel> myPosts = [];

  void initialize(String userUid) {
    uid = userUid;
    _postService = PostService(uid);
    setLoading(false);
  }

  void listenToMyPosts() {
    _postService.getMyPostsStream().listen((posts) {
      myPosts = posts;
      notifyListeners();
    });
  }
}
