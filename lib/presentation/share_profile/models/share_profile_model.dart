class ShareProfileResponse {
  final String status;
  final ShareProfileData data;

  ShareProfileResponse({required this.status, required this.data});

  factory ShareProfileResponse.fromJson(Map<String, dynamic> json) {
    return ShareProfileResponse(
      status: json['status'],
      data: ShareProfileData.fromJson(json['data']),
    );
  }
}

class ShareProfileData {
  final String qrCode;
  final ProfileData profileData;

  ShareProfileData({required this.qrCode, required this.profileData});

  factory ShareProfileData.fromJson(Map<String, dynamic> json) {
    return ShareProfileData(
      qrCode: json['qrCode'],
      profileData: ProfileData.fromJson(json['profileData']),
    );
  }
}

class ProfileData {
  final String id;
  final String name;
  final String title;
  final String profilePic;
  final String industry;
  final String occupation;

  ProfileData({
    required this.id,
    required this.name,
    required this.title,
    required this.profilePic,
    required this.industry,
    required this.occupation,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      profilePic: json['profilePic'],
      industry: json['industry'],
      occupation: json['occupation'],
    );
  }
}
