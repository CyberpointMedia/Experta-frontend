class LoginRequestModel {
  String? phoneNo;

  LoginRequestModel({this.phoneNo});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNo'] = this.phoneNo;
    return data;
  }
}
