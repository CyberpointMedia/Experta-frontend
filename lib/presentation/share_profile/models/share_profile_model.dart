class ShareProfileResponse {
  final String? status;
  final ShareProfileData? data;

  ShareProfileResponse({this.status, this.data});

  factory ShareProfileResponse.fromJson(Map<String, dynamic> json) {
    return ShareProfileResponse(
      status: json['status'] as String?,
      data:
          json['data'] != null ? ShareProfileData.fromJson(json['data']) : null,
    );
  }
}

class ShareProfileData {
  final String? qrCode;
  final ProfileData? profileData;

  ShareProfileData({this.qrCode, this.profileData});

  factory ShareProfileData.fromJson(Map<String, dynamic> json) {
    return ShareProfileData(
      qrCode: json['qrCode'] as String?,
      profileData: json['profileData'] != null
          ? ProfileData.fromJson(json['profileData'])
          : null,
    );
  }
}

class ProfileData {
  final String? id;
  final String? name;
  final String? title;
  final String? profilePic;
  final String? industry;
  final String? occupation;

  ProfileData({
    this.id,
    this.name,
    this.title,
    this.profilePic,
    this.industry,
    this.occupation,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] as String?,
      name: json['name'] as String?,
      title: json['title'] as String?,
      profilePic: json['profilePic'] as String?,
      industry: json['industry'] as String?,
      occupation: json['occupation'] as String?,
    );
  }
}
