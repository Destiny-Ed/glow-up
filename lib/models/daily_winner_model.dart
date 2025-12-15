class DailyWinnerModel {
  final String date; // "2025-12-15"
  final String winnerUserId;
  final String winnerPostId;
  final int fireVotes;
  final int totalPostsToday;
  final DateTime processedAt;
  final String? reelUrl; // Generated video reel

  DailyWinnerModel({
    required this.date,
    required this.winnerUserId,
    required this.winnerPostId,
    required this.fireVotes,
    required this.totalPostsToday,
    required this.processedAt,
    this.reelUrl,
  });

  factory DailyWinnerModel.fromJson(Map<String, dynamic> json) {
    return DailyWinnerModel(
      date: json['date'],
      winnerUserId: json['winnerUserId'],
      winnerPostId: json['winnerPostId'],
      fireVotes: json['fireVotes'],
      totalPostsToday: json['totalPostsToday'],
      processedAt: DateTime.parse(json['processedAt']),
      reelUrl: json['reelUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'winnerUserId': winnerUserId,
      'winnerPostId': winnerPostId,
      'fireVotes': fireVotes,
      'totalPostsToday': totalPostsToday,
      'processedAt': processedAt.toIso8601String(),
      'reelUrl': reelUrl,
    };
  }
}
