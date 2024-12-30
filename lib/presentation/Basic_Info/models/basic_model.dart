// models/user_profile.dart

class BasicProfileInfoModel {
  final String? status;
  final UserData? data;

  BasicProfileInfoModel({this.status, this.data});

  factory BasicProfileInfoModel.fromJson(Map<String, dynamic> json) {
    return BasicProfileInfoModel(
      status: json['status'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final String? id;
  final List<String>? followers;
  final List<String>? following;
  final List<String>? posts;
  final List<String>? reviews;
  final int? rating;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? displayName;
  final String? facebook;
  final String? firstName;
  final String? gender;
  final String? instagram;
  final String? lastName;
  final String? linkedin;
  final String? twitter;
  final String? username;
  final String? profilePic;
  final String? qrCode;
  final List<SocialLink>? socialLinks;

  UserData({
    this.id,
    this.followers,
    this.following,
    this.posts,
    this.reviews,
    this.rating,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.bio,
    this.dateOfBirth,
    this.displayName,
    this.facebook,
    this.firstName,
    this.gender,
    this.instagram,
    this.lastName,
    this.linkedin,
    this.twitter,
    this.username,
    this.profilePic,
    this.qrCode,
    this.socialLinks,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      followers: json['followers'] != null
          ? List<String>.from(json['followers'])
          : null,
      following: json['following'] != null
          ? List<String>.from(json['following'])
          : null,
      posts: json['posts'] != null ? List<String>.from(json['posts']) : null,
      reviews:
          json['reviews'] != null ? List<String>.from(json['reviews']) : null,
      rating: json['rating'],
      isDeleted: json['isDeleted'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      bio: json['bio'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
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
      socialLinks: json['socialLinks'] != null
          ? (json['socialLinks'] as List)
              .map((link) => SocialLink.fromJson(link))
              .toList()
          : null,
    );
  }
}

class SocialLink {
  final String? name;
  final String? link;
  final String? id;

  SocialLink({
    this.name,
    this.link,
    this.id,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      name: json['name'],
      link: json['link'],
      id: json['_id'],
    );
  }
}
