class LoginResponseModel {
  String? status;
  UserData? data;

  LoginResponseModel({this.status, this.data});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  String? firstName;
  String? lastName;
  String? otp;
  // Add other fields as necessary

  UserData({this.firstName, this.lastName, this.otp});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        firstName: json['firstName'],
        lastName: json['lastName'],
        otp: json['otp'],
      );
}
