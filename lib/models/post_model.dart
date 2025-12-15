class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String userPlatform;
  final String userAvatarUrl;
  final String? imageUrl;
  final String? caption;
  final List<String>? hashtags;
  final DateTime? timestamp;
  final String? challenge;
  final int? likes;
  final int? fire;
  final List<PostUser>? likedBy;
  final List<String>? shares;
  final bool? hasPosted;

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPlatform,
    required this.userAvatarUrl,
    this.imageUrl,
    this.caption,
    this.hashtags,
    this.timestamp,
    this.challenge,
    this.likes,
    this.fire,
    this.likedBy,
    this.shares,
    this.hasPosted,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userPlatform: json['userPlatform'],
      userAvatarUrl: json['userAvatarUrl'],
      imageUrl: json['imageUrl'],
      caption: json['caption'],
      hashtags: List<String>.from(json['hashtags'] ?? []),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
      challenge: json['challenge'],
      likes: json['likes'],
      fire: json['fire'],
      likedBy: json['likedBy'] != null
          ? (json['likedBy'] as List)
                .map((item) => PostUser.fromJson(item))
                .toList()
          : [],
      shares: List<String>.from(json['shares'] ?? []),
      hasPosted: json['hasPosted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPlatform': userPlatform,
      'userAvatarUrl': userAvatarUrl,
      'imageUrl': imageUrl,
      'caption': caption,
      'hashtags': hashtags,
      'timestamp': timestamp?.toIso8601String(),
      'challenge': challenge,
      'likes': likes,
      'fire': fire,
      'likedBy': likedBy?.map((item) => item.toJson()).toList(),
      'shares': shares,
      'hasPosted': hasPosted,
    };
  }
}

class PostUser {
  final String userId;
  final String userName;
  final String userAvatarUrl;

  PostUser({
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
  });

  factory PostUser.fromJson(Map<String, dynamic> json) {
    return PostUser(
      userId: json['userId'],
      userName: json['userName'],
      userAvatarUrl: json['userAvatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
    };
  }
}
