// models/battle_model.dart

class BattleModel {
  final String id;
  final String creatorUid;
  final String theme;
  final String? caption;
  final Duration duration; // e.g., Duration(hours: 24)
  final DateTime startTime;
  final DateTime? endTime;
  final List<String> opponentUids; // Invited/accepted opponents
  final Map<String, String> posts; // userId: postId
  final String status; // 'pending', 'active', 'finished'
  final String? winnerUid;
  final int voteCount;

  BattleModel({
    required this.id,
    required this.creatorUid,
    required this.theme,
    this.caption,
    required this.duration,
    required this.startTime,
    this.endTime,
    this.opponentUids = const [],
    this.posts = const {},
    this.status = 'active',
    this.winnerUid,
    this.voteCount = 0,
  });

  factory BattleModel.fromJson(Map<String, dynamic> json) {
    return BattleModel(
      id: json['id'],
      creatorUid: json['creatorUid'],
      theme: json['theme'],
      caption: json['caption'],
      duration: Duration(seconds: json['durationSeconds']),
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      opponentUids: List<String>.from(json['opponentUids'] ?? []),
      posts: Map<String, String>.from(json['posts'] ?? {}),
      status: json['status'],
      winnerUid: json['winnerUid'],
      voteCount: json['voteCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creatorUid': creatorUid,
      'theme': theme,
      'caption': caption,
      'durationSeconds': duration.inSeconds,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'opponentUids': opponentUids,
      'posts': posts,
      'status': status,
      'winnerUid': winnerUid,
      'voteCount': voteCount,
    };
  }
}
