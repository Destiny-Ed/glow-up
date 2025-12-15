import 'package:glow_up/models/post_model.dart';

class BattleModel {
  final String? id;
  final String? theme;
  final String? description;
  final String? imageUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<PostUser>? participants;
  final List<PostModel>? posts;
  final DateTime? createdAt;

  BattleModel({
    this.id,
    this.theme,
    this.description,
    this.imageUrl,
    this.startDate,
    this.endDate,
    this.participants,
    this.posts,
    this.createdAt,
  });

  factory BattleModel.fromJson(Map<String, dynamic> json) {
    return BattleModel(
      id: json['id'],
      theme: json['theme'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate:
          json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      participants: json['participants'] != null
          ? (json['participants'] as List)
              .map((item) => PostUser.fromJson(item))
              .toList()
          : null,
      posts: json['posts'] != null
          ? (json['posts'] as List)
              .map((item) => PostModel.fromJson(item))
              .toList()
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'theme': theme,
      'description': description,
      'imageUrl': imageUrl,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'participants':
          participants?.map((item) => item.toJson()).toList(),
      'posts': posts?.map((item) => item.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
