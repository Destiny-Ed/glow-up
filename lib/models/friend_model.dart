class FriendModel {
  final String id;
  final String name;
  final String username;
  final String avatarUrl;
  final String? timeStamp;

  FriendModel({
    required this.id,
    required this.name,
    required this.username,
    required this.avatarUrl,
    this.timeStamp,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      avatarUrl: json['avatarUrl'],
      timeStamp: json['timeStamp'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatarUrl': avatarUrl,
      'timeStamp': timeStamp,
    };
  }
}
