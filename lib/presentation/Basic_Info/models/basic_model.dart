// models/user_profile.dart

class  BasicProfileInfoModel {
  final String status;
  final UserData data;

   BasicProfileInfoModel({required this.status, required this.data});

  factory  BasicProfileInfoModel.fromJson(Map<String, dynamic> json) {
    return  BasicProfileInfoModel(
      status: json['status'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final String id;
  final List<String> followers;
  final List<String> following;
  final List<String> posts;
  final List<String> reviews;
  final int rating;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String bio;
  final DateTime dateOfBirth;
  final String displayName;
  final String facebook;
  final String firstName;
  final String gender;
  final String instagram;
  final String lastName;
  final String linkedin;
  final String twitter;
  final String username;
  final String profilePic;
  final String qrCode;
  final List<SocialLink> socialLinks;

  UserData({
    required this.id,
    required this.followers,
    required this.following,
    required this.posts,
    required this.reviews,
    required this.rating,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.bio,
    required this.dateOfBirth,
    required this.displayName,
    required this.facebook,
    required this.firstName,
    required this.gender,
    required this.instagram,
    required this.lastName,
    required this.linkedin,
    required this.twitter,
    required this.username,
    required this.profilePic,
    required this.qrCode,
    required this.socialLinks,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      followers: List<String>.from(json['followers']),
      following: List<String>.from(json['following']),
      posts: List<String>.from(json['posts']),
      reviews: List<String>.from(json['reviews']),
      rating: json['rating'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      bio: json['bio'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      displayName: json['displayName'],
      facebook: json['facebook'],
      firstName: json['firstName'],
      gender: json['gender'],
      instagram: json['instagram'],
      lastName: json['lastName'],
      linkedin: json['linkedin'],
      twitter: json['twitter'],
      username: json['username'],
      profilePic: json['profilePic'],
      qrCode: json['qrCode'],
      socialLinks: (json['socialLinks'] as List)
          .map((link) => SocialLink.fromJson(link))
          .toList(),
    );
  }
}

class SocialLink {
  final String name;
  final String link;
  final String id;

  SocialLink({
    required this.name,
    required this.link,
    required this.id,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      name: json['name'],
      link: json['link'],
      id: json['_id'],
    );
  }
}
