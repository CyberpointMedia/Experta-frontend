class VerifyOtpRequestModel {
  String? phoneNo;
  String? otp;

  VerifyOtpRequestModel({this.phoneNo, this.otp});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNo'] = phoneNo;
    data['otp'] = otp;
    return data;
  }
}
 