import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  final String? status;
  final Data? data;

  ProfileModel({
    this.status,
    this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json["status"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  final String? email;
  final String? phoneNo;
  final int? resendCount;
  final dynamic otp;
  final dynamic otpExpiry;
  final bool? block;
  final bool? isVerified;
  final UserBasicInfo? basicInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserPricing? pricing;
  final UserExpertise? expertise;
  final IndustryOccupation? industryOccupation;
  final List<UserEducation>? education;
  final List<UserWorkExperience>? workExperience;
  final UserLanguage? language;
  final UserInterest? interest;
  final List<String>? availability;
  final bool? online;
  final String? id;
  final int? noOfBooking;
  final List<String>? blockedUsers;
  final bool? isFollowing;
  final bool? isBlocked;

  Data({
    this.email,
    this.phoneNo,
    this.resendCount,
    this.otp,
    this.otpExpiry,
    this.block,
    this.isVerified,
    this.basicInfo,
    this.createdAt,
    this.updatedAt,
    this.pricing,
    this.expertise,
    this.industryOccupation,
    this.education,
    this.workExperience,
    this.language,
    this.interest,
    this.availability,
    this.online,
    this.id,
    this.noOfBooking,
    this.blockedUsers,
    this.isFollowing,
    this.isBlocked,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        phoneNo: json["phoneNo"],
        resendCount: json["resendCount"],
        otp: json["otp"],
        otpExpiry: json["otpExpiry"],
        block: json["block"],
        isVerified: json["isVerified"],
        basicInfo: json["basicInfo"] != null
            ? UserBasicInfo.fromJson(json["basicInfo"])
            : null,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        pricing: json["pricing"] != null
            ? UserPricing.fromJson(json["pricing"])
            : null,
        expertise: json["expertise"] != null
            ? UserExpertise.fromJson(json["expertise"])
            : null,
        industryOccupation: json["industryOccupation"] != null
            ? IndustryOccupation.fromJson(json["industryOccupation"])
            : null,
        education: json["education"] != null
            ? List<UserEducation>.from(
                json["education"].map((x) => UserEducation.fromJson(x)))
            : null,
        workExperience: json["workExperience"] != null
            ? List<UserWorkExperience>.from(json["workExperience"]
                .map((x) => UserWorkExperience.fromJson(x)))
            : null,
        language: json["language"] != null
            ? UserLanguage.fromJson(json["language"])
            : null,
        interest: json["intereset"] != null
            ? UserInterest.fromJson(json["intereset"])
            : null,
        availability: json["availability"] != null
            ? List<String>.from(json["availability"].map((x) => x))
            : null,
        online: json["online"],
        id: json["_id"],
        noOfBooking: json['noOfBooking'],
        blockedUsers: json['blockedUsers'] != null
            ? List<String>.from(json['blockedUsers'])
            : null,
        isFollowing: json['isFollowing'],
        isBlocked: json['isBlocked'],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phoneNo": phoneNo,
        "resendCount": resendCount,
        "otp": otp,
        "otpExpiry": otpExpiry,
        "block": block,
        "isVerified": isVerified,
        "basicInfo": basicInfo?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "pricing": pricing?.toJson(),
        "expertise": expertise?.toJson(),
        "industryOccupation": industryOccupation?.toJson(),
        "education": education != null
            ? List<dynamic>.from(education!.map((x) => x.toJson()))
            : null,
        "workExperience": workExperience != null
            ? List<dynamic>.from(workExperience!.map((x) => x.toJson()))
            : null,
        "language": language?.toJson(),
        "intereset": interest?.toJson(),
        "availability": availability != null
            ? List<dynamic>.from(availability!.map((x) => x))
            : null,
        "online": online,
        "_id": id,
        'noOfBooking': noOfBooking,
        'blockedUsers':
            blockedUsers != null ? List<dynamic>.from(blockedUsers!) : null,
        'isFollowing': isFollowing,
        'isBlocked': isBlocked,
      };
}

class UserBasicInfo {
  final String? id;
  final String? firstName;
  final String? lastName;
  final List<dynamic>? followers;
  final List<dynamic>? following;
  final List<Post>? posts; // Changed from List<String> to List<Post>
  final int? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? bio;
  final String? displayName;
  final String? facebook;
  final String? instagram;
  final String? linkedin;
  final String? twitter;
  final List<Review>? reviews;
  final String? profilePic;

  UserBasicInfo({
    this.id,
    this.firstName,
    this.lastName,
    this.followers,
    this.following,
    this.posts,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.bio,
    this.displayName,
    this.facebook,
    this.instagram,
    this.linkedin,
    this.twitter,
    this.reviews,
    this.profilePic,
  });

  factory UserBasicInfo.fromJson(Map<String, dynamic> json) => UserBasicInfo(
        id: json["_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        followers: json["followers"] != null
            ? List<dynamic>.from(json["followers"].map((x) => x))
            : null,
        following: json["following"] != null
            ? List<dynamic>.from(json["following"].map((x) => x))
            : null,
        posts: json["posts"] != null
            ? List<Post>.from(json["posts"].map((x) => Post.fromJson(x)))
            : null,
        rating: json["rating"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
        bio: json["bio"],
        displayName: json["displayName"],
        facebook: json["facebook"],
        instagram: json["instagram"],
        linkedin: json["linkedin"],
        twitter: json["twitter"],
        reviews: json['reviews'] != null
            ? List<Review>.from(json['reviews'].map((x) => Review.fromJson(x)))
            : null,
        profilePic: json["profilePic"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "followers": followers != null
            ? List<dynamic>.from(followers!.map((x) => x))
            : null,
        "following": following != null
            ? List<dynamic>.from(following!.map((x) => x))
            : null,
        "posts": posts != null
            ? List<dynamic>.from(posts!.map((x) => x.toJson()))
            : null,
        "rating": rating,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "bio": bio,
        "displayName": displayName,
        "facebook": facebook,
        "instagram": instagram,
        "linkedin": linkedin,
        "twitter": twitter,
        'reviews': reviews != null
            ? List<dynamic>.from(reviews!.map((x) => x.toJson()))
            : null,
        "profilePic": profilePic,
      };

  int getTotalFollowers() {
    return followers?.length ?? 0;
  }

  // Method to calculate total number of following
  int getTotalFollowing() {
    return following?.length ?? 0;
  }

  List<Map<String, dynamic>> getSocialMediaLinks() {
    List<Map<String, dynamic>> socialMediaLinks = [];

    if (facebook != null && facebook!.isNotEmpty) {
      socialMediaLinks.add({
        'icon': FontAwesomeIcons.facebook,
        'link': facebook!,
        'name': "facebook"
      });
    }
    if (instagram != null && instagram!.isNotEmpty) {
      socialMediaLinks.add({
        'icon': FontAwesomeIcons.instagram,
        'link': instagram!,
        'name': "instagram",
      });
    }
    if (linkedin != null && linkedin!.isNotEmpty) {
      socialMediaLinks.add({
        'icon': FontAwesomeIcons.linkedin,
        'link': linkedin!,
        'name': "linkedin"
      });
    }
    if (twitter != null && twitter!.isNotEmpty) {
      socialMediaLinks.add({
        'icon': FontAwesomeIcons.twitter,
        'link': twitter!,
        'name': "twitter",
      });
    }

    return socialMediaLinks;
  }
}

class Post {
  final String? id;
  final String? image;
  final String? caption;
  final String? postedBy;
  final List<String>? likes;
  final String? type;
  final List<Comment>? comments;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? location; // Added location field

  Post({
    this.id,
    this.image,
    this.caption,
    this.postedBy,
    this.likes,
    this.type,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.location, // Added location field
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["_id"],
        image: json["image"],
        caption: json["caption"],
        postedBy: json["postedBy"],
        likes: json["likes"] != null
            ? List<String>.from(json["likes"].map((x) => x))
            : null,
        type: json["type"],
        comments: json["comments"] != null
            ? List<Comment>.from(
                json["comments"].map((x) => Comment.fromJson(x)))
            : null,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
        location: json["location"], // Added location field
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "image": image,
        "caption": caption,
        "postedBy": postedBy,
        "likes":
            likes != null ? List<dynamic>.from(likes!.map((x) => x)) : null,
        "type": type,
        "comments": comments != null
            ? List<dynamic>.from(comments!.map((x) => x.toJson()))
            : null,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "location": location, // Added location field
      };
}

class Comment {
  final String? comment;
  final String? user;
  final String? id;
  final DateTime? createdAt;

  Comment({
    this.comment,
    this.user,
    this.id,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        comment: json["comment"],
        user: json["user"],
        id: json["_id"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "user": user,
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class UserEducation {
  final String? id;
  final String? degree;
  final String? schoolCollege;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  UserEducation({
    this.id,
    this.degree,
    this.schoolCollege,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory UserEducation.fromJson(Map<String, dynamic> json) => UserEducation(
        id: json["_id"],
        degree: json["degree"],
        schoolCollege: json["schoolCollege"],
        startDate: json["startDate"] != null
            ? DateTime.parse(json["startDate"])
            : null,
        endDate:
            json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "degree": degree,
        "schoolCollege": schoolCollege,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class UserExpertise {
  final String? id;
  final int? v;
  final DateTime? createdAt;
  final List<UserExpertise>? expertise;
  final DateTime? updatedAt;
  final String? name;
  final String? industry;

  UserExpertise({
    this.id,
    this.v,
    this.createdAt,
    this.expertise,
    this.updatedAt,
    this.name,
    this.industry,
  });

  factory UserExpertise.fromJson(Map<String, dynamic> json) => UserExpertise(
        id: json["_id"],
        v: json["__v"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        expertise: json["expertise"] != null
            ? List<UserExpertise>.from(
                json["expertise"].map((x) => UserExpertise.fromJson(x)))
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        name: json["name"],
        industry: json["industry"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "__v": v,
        "createdAt": createdAt?.toIso8601String(),
        "expertise": expertise != null
            ? List<dynamic>.from(expertise!.map((x) => x.toJson()))
            : null,
        "updatedAt": updatedAt?.toIso8601String(),
        "name": name,
        "industry": industry,
      };
}

class UserInterest {
  final String? id;
  final int? v;
  final DateTime? createdAt;
  final List<Interest>? interest;
  final DateTime? updatedAt;

  UserInterest({
    this.id,
    this.v,
    this.createdAt,
    this.interest,
    this.updatedAt,
  });

  factory UserInterest.fromJson(Map<String, dynamic> json) => UserInterest(
        id: json["_id"],
        v: json["__v"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        interest: json["intereset"] != null
            ? List<Interest>.from(
                json["intereset"].map((x) => Interest.fromJson(x)))
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "__v": v,
        "createdAt": createdAt?.toIso8601String(),
        "intereset": interest != null
            ? List<dynamic>.from(interest!.map((x) => x.toJson()))
            : null,
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Interest {
  final String? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Interest({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
        id: json["_id"],
        name: json["name"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class IndustryOccupation {
  final String? id;
  final int? v;
  final List<String>? achievements;
  final String? certificate;
  final DateTime? createdAt;
  final UserExpertise? industry;
  final Occupation? occupation; // Changed from UserExpertise to Occupation
  final String? registrationNumber;
  final DateTime? updatedAt;

  IndustryOccupation({
    this.id,
    this.v,
    this.achievements,
    this.certificate,
    this.createdAt,
    this.industry,
    this.occupation, // Changed from UserExpertise to Occupation
    this.registrationNumber,
    this.updatedAt,
  });

  factory IndustryOccupation.fromJson(Map<String, dynamic> json) =>
      IndustryOccupation(
        id: json["_id"],
        v: json["__v"],
        achievements: json["achievements"] != null
            ? List<String>.from(json["achievements"].map((x) => x))
            : null,
        certificate: json["certificate"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        industry: json["industry"] != null
            ? UserExpertise.fromJson(json["industry"])
            : null,
        occupation: json["occupation"] != null
            ? Occupation.fromJson(json["occupation"])
            : null, // Changed from UserExpertise to Occupation
        registrationNumber: json["registrationNumber"],
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "__v": v,
        "achievements": achievements != null
            ? List<dynamic>.from(achievements!.map((x) => x))
            : null,
        "certificate": certificate,
        "createdAt": createdAt?.toIso8601String(),
        "industry": industry?.toJson(),
        "occupation":
            occupation?.toJson(), // Changed from UserExpertise to Occupation
        "registrationNumber": registrationNumber,
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Occupation {
  final String? id;
  final String? name;
  final String? industry;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Occupation({
    this.id,
    this.name,
    this.industry,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Occupation.fromJson(Map<String, dynamic> json) => Occupation(
        id: json["_id"],
        name: json["name"],
        industry: json["industry"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "industry": industry,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class UserLanguage {
  final String? id;
  final String? user;
  final List<UserExpertise>? language;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  UserLanguage({
    this.id,
    this.user,
    this.language,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory UserLanguage.fromJson(Map<String, dynamic> json) => UserLanguage(
        id: json["_id"],
        user: json["user"],
        language: json["language"] != null
            ? List<UserExpertise>.from(
                json["language"].map((x) => UserExpertise.fromJson(x)))
            : null,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user": user,
        "language": language != null
            ? List<dynamic>.from(language!.map((x) => x.toJson()))
            : null,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class UserPricing {
  final String? id;
  final int? v;
  final int? audioCallPrice;
  final int? messagePrice;
  final int? videoCallPrice;

  UserPricing({
    this.id,
    this.v,
    this.audioCallPrice,
    this.messagePrice,
    this.videoCallPrice,
  });

  factory UserPricing.fromJson(Map<String, dynamic> json) => UserPricing(
        id: json["_id"],
        v: json["__v"],
        audioCallPrice: json["audioCallPrice"],
        messagePrice: json["messagePrice"],
        videoCallPrice: json["videoCallPrice"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "__v": v,
        "audioCallPrice": audioCallPrice,
        "messagePrice": messagePrice,
        "videoCallPrice": videoCallPrice,
      };
}

class UserWorkExperience {
  final String? id;
  final String? jobTitle;
  final String? companyName;
  final bool? isCurrentlyWorking;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  UserWorkExperience({
    this.id,
    this.jobTitle,
    this.companyName,
    this.isCurrentlyWorking,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory UserWorkExperience.fromJson(Map<String, dynamic> json) =>
      UserWorkExperience(
        id: json["_id"],
        jobTitle: json["jobTitle"],
        companyName: json["companyName"],
        isCurrentlyWorking: json["isCurrentlyWorking"],
        startDate: json["startDate"] != null
            ? DateTime.parse(json["startDate"])
            : null,
        endDate:
            json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "jobTitle": jobTitle,
        "companyName": companyName,
        "isCurrentlyWorking": isCurrentlyWorking,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class Review {
  final String? id;
  final String? review;
  final String? reviewer;
  final String? profilePic;
  final int? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? formattedDate;
  final int? v;

  Review({
    this.id,
    this.review,
    this.reviewer,
    this.profilePic,
    this.rating,
    this.createdAt,
    this.updatedAt,
    this.formattedDate,
    this.v,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["_id"],
        review: json["review"],
        reviewer: json["reviewerName"],
        profilePic: json["profilePic"],
        rating: json["rating"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        formattedDate: json['formattedDate'],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "review": review,
        "reviewerName": reviewer,
        "profilePic": profilePic,
        "rating": rating,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "formattedDate": formattedDate,
        "__v": v,
      };
}
