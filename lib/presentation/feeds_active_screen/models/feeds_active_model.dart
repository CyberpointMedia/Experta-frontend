import 'dart:convert';

FeedsActiveModel feedsActiveModelFromJson(String str) =>
    FeedsActiveModel.fromJson(json.decode(str));

String feedsActiveModelToJson(FeedsActiveModel data) =>
    json.encode(data.toJson());

class FeedsActiveModel {
  final String status;
  final List<Datum> data;

  FeedsActiveModel({
    required this.status,
    required this.data,
  });

  factory FeedsActiveModel.fromJson(Map<String, dynamic> json) =>
      FeedsActiveModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final String type;
  final String id;
  final String formattedDate;
  final String image;
  final String caption;
  final PostedBy postedBy;
  final List<PostedBy> likes;
  List<Comment> comments;
  int totalLikes;
  int totalComments;

  Datum({
    required this.type,
    required this.id,
    required this.formattedDate,
    required this.image,
    required this.caption,
    required this.postedBy,
    required this.likes,
    required this.comments,
    required this.totalLikes,
    required this.totalComments,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        type: json["type"],
        id: json["id"],
        formattedDate: json["formattedDate"],
        image: json["image"],
        caption: json["caption"],
        postedBy: PostedBy.fromJson(json["postedBy"]),
        likes:
            List<PostedBy>.from(json["likes"].map((x) => PostedBy.fromJson(x))),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
        totalLikes: json["totalLikes"],
        totalComments: json["totalComments"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "formattedDate": formattedDate,
        "image": image,
        "caption": caption,
        "postedBy": postedBy.toJson(),
        "likes": List<dynamic>.from(likes.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "totalLikes": totalLikes,
        "totalComments": totalComments,
      };
}

class Comment {
  String comment;
  final String formattedDate;
  final String id;
  final DateTime createdAt;
  final PostedBy user;

  Comment({
    required this.comment,
    required this.formattedDate,
    required this.id,
    required this.createdAt,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        comment: json["comment"],
        formattedDate: json["formattedDate"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        user: PostedBy.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "formattedDate": formattedDate,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class PostedBy {
  final String id;
  final bool online;
  final int rating;
  final String profilePic;
  final String displayName;
  final String industry;
  final String occupation;

  PostedBy({
    required this.id,
    required this.online,
    required this.rating,
    required this.profilePic,
    required this.displayName,
    required this.industry,
    required this.occupation,
  });

  factory PostedBy.fromJson(Map<String, dynamic> json) => PostedBy(
        id: json["id"],
        online: json["online"],
        rating: json["rating"],
        profilePic: json["profilePic"],
        displayName: json["displayName"],
        industry: json["industry"],
        occupation: json["occupation"],
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
