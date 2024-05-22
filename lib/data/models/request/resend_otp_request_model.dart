class ResendOtpRequestModel {
  String? phoneNo;

  ResendOtpRequestModel({this.phoneNo});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNo'] = phoneNo;
    return data;
  }
}
