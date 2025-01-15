class UserProfile {
  String email;
  String phoneNo;
  bool block;
  bool isVerified;
  BasicInfo basicInfo;
  Pricing pricing;

  UserProfile({
    required this.email,
    required this.phoneNo,
    required this.block,
    required this.isVerified,
    required this.basicInfo,
    required this.pricing,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      block: json['block'] ?? false,
      isVerified: json['isVerified'] ?? false,
      basicInfo: BasicInfo.fromJson(json['basicInfo'] ?? {}),
      pricing: Pricing.fromJson(json['pricing'] ?? {}),
    );
  }
}

class BasicInfo {
  String id;
  String firstName;
  String lastName;
  String bio;
  String displayName;
  String facebook;
  String instagram;
  String linkedin;
  String twitter;
  int rating;

  BasicInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.displayName,
    required this.facebook,
    required this.instagram,
    required this.linkedin,
    required this.twitter,
    required this.rating,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      bio: json['bio'] ?? '',
      displayName: json['displayName'] ?? '',
      facebook: json['facebook'] ?? '',
      instagram: json['instagram'] ?? '',
      linkedin: json['linkedin'] ?? '',
      twitter: json['twitter'] ?? '',
      rating: json['rating'] ?? 0,
    );
  }
}

class Pricing {
  String id;
  int audioCallPrice;
  int messagePrice;
  int videoCallPrice;

  Pricing({
    required this.id,
    required this.audioCallPrice,
    required this.messagePrice,
    required this.videoCallPrice,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      id: json['_id'] ?? '',
      audioCallPrice: json['audioCallPrice'] ?? 0,
      messagePrice: json['messagePrice'] ?? 0,
      videoCallPrice: json['videoCallPrice'] ?? 0,
    );
  }
}
