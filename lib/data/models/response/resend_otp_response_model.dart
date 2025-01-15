class ResendOtpResponseModel {
  String? status;
  Data? data;

  ResendOtpResponseModel({this.status, this.data});

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponseModel(
      status: json['status'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  String? otp;
  int? resendCount;

  Data({this.otp, this.resendCount});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(otp: json['otp'], resendCount: json['resendCount']);
  }
}
