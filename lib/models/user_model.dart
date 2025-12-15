class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? platform;
  final String? profilePictureUrl;
  final String? userName;
  final String? bio;
  final String? location;
  final String? phoneNumber;
  final String? gender;
  final DateTime? dob;
  final String? profileStatus;
  final int? streakCount;
  final List<DateTime>? winDates;
  final int? votes;
  final int? battles;
  final bool? isProfilePrivate;
  final DateTime? dateCreated;
  final DateTime? lastActiveDate;
  final List<GalleryImage>? galleryImages;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.platform,
    required this.profilePictureUrl,
    required this.userName,
    required this.bio,
    required this.location,
    required this.phoneNumber,
    this.gender,
    this.dob,
    this.profileStatus,
    this.streakCount,
    this.winDates,
    this.votes,
    this.battles,
    this.isProfilePrivate,
    this.dateCreated,
    this.lastActiveDate,
    this.galleryImages,
  });

  bool get isProfileComplete {
    return name != null &&
        email != null &&
        phoneNumber != null &&
        dob != null &&
        gender != null &&
        profilePictureUrl != null &&
        userName != null &&
        bio != null &&
        location != null;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      platform: json['platform'],
      profilePictureUrl: json['profilePictureUrl'],
      userName: json['userName'],
      bio: json['bio'],
      location: json['location'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      profileStatus: json['profileStatus'],
      streakCount: json['streakCount'],
      votes: json['votes'],
      winDates: json['winDates'] != null
          ? (json['winDates'] as List)
                .map((date) => DateTime.parse(date))
                .toList()
          : null,
      battles: json['battles'],
      isProfilePrivate: json['isProfilePrivate'],
      dateCreated: json['dateCreated'] != null
          ? DateTime.parse(json['dateCreated'])
          : null,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.parse(json['lastActiveDate'])
          : null,

      galleryImages: json['galleryImages'] != null
          ? (json['galleryImages'] as List)
                .map((img) => GalleryImage.fromJson(img))
                .toList()
          : null,
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
      'bio': bio,
      'location': location,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'profileStatus': profileStatus,
      'streakCount': streakCount,
      'votes': votes,
      'battles': battles,
      'isProfilePrivate': isProfilePrivate,
      'dateCreated': dateCreated?.toIso8601String(),
      'lastActiveDate': lastActiveDate?.toIso8601String(),
      'dob': dob?.toIso8601String(),
      'winDates': winDates
          ?.map((date) => date.toIso8601String())
          .toList(),
      'galleryImages': galleryImages
          ?.map((img) => img.toJson())
          .toList(),
    };
  }
}

class GalleryImage {
  final String id;
  final String title;
  final String imageUrl;
  final DateTime uploadedAt;

  GalleryImage({
    required this.imageUrl,
    required this.uploadedAt,
    required this.id,
    required this.title,
  });

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}
