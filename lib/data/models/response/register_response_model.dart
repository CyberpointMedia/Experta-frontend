

class RegisterResponseModel {
  String? status;
  UserData? data;

  RegisterResponseModel({this.status, this.data});

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      status: json['status'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNo;
  String? otp;

  UserData({this.firstName, this.lastName, this.email, this.phoneNo, this.otp});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNo: json['phoneNo'],
      otp: json['otp'],
      // Add other fields as necessary
    );
  }
}
