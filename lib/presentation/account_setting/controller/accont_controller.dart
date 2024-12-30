import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/account_setting/models/accont_model.dart';

class AccountSettingController extends GetxController{

  Rx<AccontSettingModel> acountSettingModelObject = AccontSettingModel().obs;
}

class UserAccountResponse {
  final String status;
  final UserAccountData data;

  UserAccountResponse({required this.status, required this.data});

  factory UserAccountResponse.fromJson(Map<String, dynamic> json) {
    return UserAccountResponse(
      status: json['status'],
      data: UserAccountData.fromJson(json['data']),
    );
  }
}

class UserAccountData {
  final String email;
  final String phoneNo;
  final String username;

  UserAccountData({
    required this.email,
    required this.phoneNo,
    required this.username,
  });

  factory UserAccountData.fromJson(Map<String, dynamic> json) {
    return UserAccountData(
      email: json['email'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      username: json['username'] ?? '',
    );
  }
}
