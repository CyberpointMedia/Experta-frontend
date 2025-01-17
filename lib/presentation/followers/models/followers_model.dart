// followers_and_following.dart
class FollowersAndFollowing {
  String? id;
  String? email;
  String? phoneNo;
  bool? block;
  bool? isVerified;
  BasicInfo? basicInfo;
  List<dynamic>? education;
  List<dynamic>? workExperience;
  bool online;

  FollowersAndFollowing({
    required this.id,
    required this.email,
    required this.phoneNo,
    required this.block,
    required this.isVerified,
    required this.basicInfo,
    required this.education,
    required this.workExperience,
    required this.online,
  });

  factory FollowersAndFollowing.fromJson(Map<String, dynamic> json) {
    return FollowersAndFollowing(
      id: json['id'] as String?,
      email: json['email'] as String?,
      phoneNo: json['phoneNo'] as String?,
      block: json['block'] as bool?,
      isVerified: json['isVerified'] as bool?,
      basicInfo: json['basicInfo'] != null ? BasicInfo.fromJson(json['basicInfo'] as Map<String, dynamic>) : null,
      education: json['education'] as List<dynamic>?,
      workExperience: json['workExperience'] as List<dynamic>?,
      online: json['online'] as bool? ?? false,
    );
  }
}

class BasicInfo {
  String? id;
  String? firstName;
  String? lastName;
  String? displayName;
  String? bio;
  String? profilePic;
  String? facebook;
  String? instagram;
  String? linkedin;
  String? twitter;

  BasicInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.displayName,
    required this.bio,
    required this.profilePic,
    required this.facebook,
    required this.instagram,
    required this.linkedin,
    required this.twitter,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      displayName: json['displayName'] as String?,
      bio: json['bio'] as String?,
      profilePic: json['profilePic'] as String?,
      facebook: json['facebook'] as String?,
      instagram: json['instagram'] as String?,
      linkedin: json['linkedin'] as String?,
      twitter: json['twitter'] as String?,
    );
  }
}
