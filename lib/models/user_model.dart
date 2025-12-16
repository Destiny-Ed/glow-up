class UserModel {
  final String id;
  final String? name;
  final String? email;
  final String? platform;
  final String? profilePictureUrl;
  final String? userName;
  final String? usernameLower; // For search
  final String? bio;
  final String? location;
  final String? phoneNumber;
  final String? gender;
  final DateTime? dob;
  final String? profileStatus;
  final int streakCount;
  final List<DateTime> winDates;
  final int votes;
  final int battles;
  final bool isProfilePrivate;
  final DateTime dateCreated;
  final DateTime lastActiveDate;
  // Relationships
  final List<String> friendUids;
  final List<String> pendingRequestUids; // Incoming
  final List<String> sentRequestUids; // Outgoing
  final List<String> blockedUids;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.platform,
    this.profilePictureUrl,
    this.userName,
    this.usernameLower,
    this.bio,
    this.location,
    this.phoneNumber,
    this.gender,
    this.dob,
    this.profileStatus,
    this.streakCount = 0,
    this.winDates = const [],
    this.votes = 0,
    this.battles = 0,
    this.isProfilePrivate = false,
    required this.dateCreated,
    required this.lastActiveDate,
    this.friendUids = const [],
    this.pendingRequestUids = const [],
    this.sentRequestUids = const [],
    this.blockedUids = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      platform: json['platform'],
      profilePictureUrl: json['profilePictureUrl'],
      userName: json['userName'],
      usernameLower: json['usernameLower'],
      bio: json['bio'],
      location: json['location'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      profileStatus: json['profileStatus'],
      streakCount: json['streakCount'] ?? 0,
      winDates: json['winDates'] != null
          ? (json['winDates'] as List).map((d) => DateTime.parse(d)).toList()
          : [],
      votes: json['votes'] ?? 0,
      battles: json['battles'] ?? 0,
      isProfilePrivate: json['isProfilePrivate'] ?? false,
      dateCreated: DateTime.parse(json['dateCreated']),
      lastActiveDate: DateTime.parse(json['lastActiveDate']),
      friendUids: List<String>.from(json['friendUids'] ?? []),
      pendingRequestUids: List<String>.from(json['pendingRequestUids'] ?? []),
      sentRequestUids: List<String>.from(json['sentRequestUids'] ?? []),
      blockedUids: List<String>.from(json['blockedUids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'platform': platform,
      'profilePictureUrl': profilePictureUrl,
      'userName': userName,
      'usernameLower': userName?.toLowerCase(),
      'bio': bio,
      'location': location,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dob': dob?.toIso8601String(),
      'profileStatus': profileStatus,
      'streakCount': streakCount,
      'winDates': winDates.map((d) => d.toIso8601String()).toList(),
      'votes': votes,
      'battles': battles,
      'isProfilePrivate': isProfilePrivate,
      'dateCreated': dateCreated.toIso8601String(),
      'lastActiveDate': lastActiveDate.toIso8601String(),
      'friendUids': friendUids,
      'pendingRequestUids': pendingRequestUids,
      'sentRequestUids': sentRequestUids,
      'blockedUids': blockedUids,
    };
  }

  copyWith({
    String? id,
    String? name,
    String? email,
    String? platform,
    String? profilePictureUrl,
    String? userName,
    String? usernameLower,
    String? bio,
    String? location,
    String? phoneNumber,
    String? gender,
    DateTime? dob,
    String? profileStatus,
    int? streakCount,
    List<DateTime>? winDates,
    int? votes,
    int? battles,
    bool? isProfilePrivate,
    DateTime? dateCreated,
    DateTime? lastActiveDate,
    List<String>? friendUids,
    List<String>? pendingRequestUids,
    List<String>? sentRequestUids,
    List<String>? blockedUids,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      platform: platform ?? this.platform,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      userName: userName ?? this.userName,
      usernameLower: usernameLower ?? this.usernameLower,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      profileStatus: profileStatus ?? this.profileStatus,
      streakCount: streakCount ?? this.streakCount,
      winDates: winDates ?? this.winDates,
      votes: votes ?? this.votes,
      battles: battles ?? this.battles,
      isProfilePrivate: isProfilePrivate ?? this.isProfilePrivate,
      dateCreated: dateCreated ?? this.dateCreated,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      friendUids: friendUids ?? this.friendUids,
      pendingRequestUids: pendingRequestUids ?? this.pendingRequestUids,
      sentRequestUids: sentRequestUids ?? this.sentRequestUids,
      blockedUids: blockedUids ?? this.blockedUids,
    );
  }

  bool get isProfileComplete {
    return name != null &&
        name!.isNotEmpty &&
        email != null &&
        email!.isNotEmpty &&
        profilePictureUrl != null &&
        profilePictureUrl!.isNotEmpty &&
        userName != null &&
        userName!.isNotEmpty &&
        // bio != null &&
        // bio!.isNotEmpty &&
        location != null &&
        location!.isNotEmpty &&
        phoneNumber != null &&
        phoneNumber!.isNotEmpty &&
        gender != null &&
        gender!.isNotEmpty &&
        dob != null;
  }
}

// class GalleryImage {
//   final String id;
//   final String title;
//   final String imageUrl;
//   final DateTime uploadedAt;

//   GalleryImage({
//     required this.imageUrl,
//     required this.uploadedAt,
//     required this.id,
//     required this.title,
//   });

//   factory GalleryImage.fromJson(Map<String, dynamic> json) {
//     return GalleryImage(
//       id: json['id'],
//       title: json['title'],
//       imageUrl: json['imageUrl'],
//       uploadedAt: DateTime.parse(json['uploadedAt']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'imageUrl': imageUrl,
//       'uploadedAt': uploadedAt.toIso8601String(),
//     };
//   }
// }
