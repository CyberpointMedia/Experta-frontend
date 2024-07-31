

class VerifyOtpResponseModel {
  String? status;
  String? token;
  UserData? data;

  VerifyOtpResponseModel({this.status, this.token, this.data});

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      status: json['status'],
      token: json['token'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNo;
  bool? isVerified;
  String? id;

  UserData(
      {this.firstName,
      this.lastName,
      this.email,
      this.phoneNo,
      this.isVerified,
      this.id});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNo: json['phoneNo'],
      isVerified: json['isVerified'],
      id:json['id'],
    );
  }
}
