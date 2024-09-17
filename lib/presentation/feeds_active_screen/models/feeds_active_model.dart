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
        status: json["status"] ?? '',
        data: json["data"] != null
            ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
            : [],
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
        type: json["type"] ?? '',
        id: json["id"] ?? '',
        formattedDate: json["formattedDate"] ?? '',
        image: json["image"] ?? '',
        caption: json["caption"] ?? '',
        postedBy: json["postedBy"] != null
            ? PostedBy.fromJson(json["postedBy"])
            : PostedBy.empty(),
        likes: json["likes"] != null
            ? List<PostedBy>.from(json["likes"].map((x) => PostedBy.fromJson(x)))
            : [],
        comments: json["comments"] != null
            ? List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x)))
            : [],
        totalLikes: json["totalLikes"] ?? 0,
        totalComments: json["totalComments"] ?? 0,
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
        comment: json["comment"] ?? '',
        formattedDate: json["formattedDate"] ?? '',
        id: json["_id"] ?? '',
        createdAt: json["createdAt"] !=null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
        user: json["user"] != null
            ? PostedBy.fromJson(json["user"])
            : PostedBy.empty(),
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
        id: json["id"] ?? '',
        online: json["online"] ?? false,
        rating: json["rating"] ?? 0,
        profilePic: json["profilePic"] ?? '',
        displayName: json["displayName"] ?? '',
        industry: json["industry"] ?? '',
        occupation: json["occupation"] ?? '',
      );

  factory PostedBy.empty() => PostedBy(
        id: '',
        online: false,
        rating: 0,
        profilePic: '',
        displayName: '',
        industry: '',
        occupation: '',
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

class Reason {
  final String id;
  final String reason;

  Reason({required this.id, required this.reason});

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(
      id: json['_id'] ?? '',
      reason: json['reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'reason': reason,
    };
  }
}

class Report {
  final String reportedItem;
  final String itemType;
  final String reason;
  final String comment;

  Report({
    required this.reportedItem,
    required this.itemType,
    required this.reason,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'reportedItem': reportedItem,
      'itemType': itemType,
      'reason': reason,
      'comment': comment,
    };
  }
}
