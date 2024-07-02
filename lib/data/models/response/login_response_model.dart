class LoginResponseModel {
  final String status;
  final UserData data;

  LoginResponseModel({  required this.status,   required this.data});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final String? email;
  final String? phoneNo;
  final int? resendCount;
  final String? otp;
  final DateTime? otpExpiry;
  final bool? block;
  final bool? isVerified;
  final String? basicInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? pricing;
  final String? expertise;
  final List<String>? education;
  final List<String>? workExperience;
  final String id;

  UserData({
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
      this.education,
      this.workExperience,
     required this.id,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      email: json['email'],
      phoneNo: json['phoneNo'],
      resendCount: json['resendCount'],
      otp: json['otp'],
      otpExpiry: DateTime.parse(json['otpExpiry']),
      block: json['block'],
      isVerified: json['isVerified'],
      basicInfo: json['basicInfo'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      pricing: json['pricing'],
      expertise: json['expertise'],
      education: List<String>.from(json['education']),
      workExperience: List<String>.from(json['workExperience']),
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phoneNo': phoneNo,
      'resendCount': resendCount,
      'otp': otp,
      'otpExpiry': otpExpiry!.toIso8601String(),
      'block': block,
      'isVerified': isVerified,
      'basicInfo': basicInfo,
      'createdAt': createdAt!.toIso8601String(),
      'updatedAt': updatedAt!.toIso8601String(),
      'pricing': pricing,
      'expertise': expertise,
      'education': education,
      'workExperience': workExperience,
      'id': id,
    };
  }
}
