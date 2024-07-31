import 'dart:convert';

FollowersAndFollowing followersAndFollowingFromJson(String str) =>
    FollowersAndFollowing.fromJson(json.decode(str));

String followersAndFollowingToJson(FollowersAndFollowing data) =>
    json.encode(data.toJson());

class FollowersAndFollowing {
  final String status;
  final Data data;

  FollowersAndFollowing({
    required this.status,
    required this.data,
  });

  factory FollowersAndFollowing.fromJson(Map<String, dynamic> json) =>
      FollowersAndFollowing(
        status: json["status"] ?? '',
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  final List<Follow> followers;
  final List<Follow> following;

  Data({
    required this.followers,
    required this.following,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        followers: json["followers"] != null
            ? List<Follow>.from(
                json["followers"].map((x) => Follow.fromJson(x)))
            : [],
        following: json["following"] != null
            ? List<Follow>.from(
                json["following"].map((x) => Follow.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "followers": List<dynamic>.from(followers.map((x) => x.toJson())),
        "following": List<dynamic>.from(following.map((x) => x.toJson())),
      };
}

class Follow {
  final String id;
  final bool online;
  final int rating;
  final String profilePic;
  final String displayName;
  final String industry;
  final String occupation;

  Follow({
    required this.id,
    required this.online,
    required this.rating,
    required this.profilePic,
    required this.displayName,
    required this.industry,
    required this.occupation,
  });

  factory Follow.fromJson(Map<String, dynamic> json) => Follow(
        id: json["id"] ?? '',
        online: json["online"] ?? false,
        rating: json["rating"] ?? 0,
        profilePic: json["profilePic"] ?? '',
        displayName: json["displayName"] ?? '',
        industry: json["industry"] ?? '',
        occupation: json["occupation"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "online": online,
        "rating": rating,
        "profilePic": profilePic,
        "displayName": displayName,
        "industry": industry,
        "occupation": occupation,
      };
}
