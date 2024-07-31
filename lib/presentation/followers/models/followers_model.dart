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
  final String id;
  final List<Follow> followers;
  final List<Follow> following;

  Data({
    required this.id,
    required this.followers,
    required this.following,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"] ?? '',
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
        "_id": id,
        "followers": List<dynamic>.from(followers.map((x) => x.toJson())),
        "following": List<dynamic>.from(following.map((x) => x.toJson())),
      };
}

class Follow {
  final String profileName;
  final String profilePic;
  final String industryName;
  final String id;

  Follow({
    required this.profileName,
    required this.profilePic,
    required this.industryName,
     required this.id,
  });

  factory Follow.fromJson(Map<String, dynamic> json) => Follow(
        profileName: json["basicInfo"]?["firstName"] ?? '',
        profilePic: json["basicInfo"]?["profilePic"] ?? '',
        industryName: json["industryOccupation"]?["industry"]?["name"] ?? '',
        id:json["id"] ?? ''
      );

  Map<String, dynamic> toJson() => {
        "profileName": profileName,
        "profilePic": profilePic,
        "industryName": industryName,
        "id":id
      };
}
