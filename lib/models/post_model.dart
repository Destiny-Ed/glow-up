class PostModel {
  final String id;
  final String userId;
  final String imageUrl;
  final String? caption;
  final List<String> hashtags;
  final DateTime timestamp;
  final String? challenge;
  final int fireCount;
  final int likesCount;
  final bool hasPosted;

  PostModel({
    required this.id,
    required this.userId,
    required this.imageUrl,
    this.caption,
    this.hashtags = const [],
    required this.timestamp,
    this.challenge,
    this.fireCount = 0,
    this.likesCount = 0,
    this.hasPosted = true,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      caption: json['caption'],
      hashtags: List<String>.from(json['hashtags'] ?? []),
      timestamp: DateTime.parse(json['timestamp']),
      challenge: json['challenge'],
      fireCount: json['fireCount'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
      hasPosted: json['hasPosted'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'caption': caption,
      'hashtags': hashtags,
      'timestamp': timestamp.toIso8601String(),
      'challenge': challenge,
      'fireCount': fireCount,
      'likesCount': likesCount,
      'hasPosted': hasPosted,
    };
  }
}
