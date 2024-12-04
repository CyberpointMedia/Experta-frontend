import 'dart:developer';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/account_details_settings/email_verify/controller_email.dart';
import 'package:experta/presentation/account_details_settings/email_verify/email_verify.dart';
import 'package:experta/widgets/custom_toast_message.dart';

class AccountDetailsController extends GetxController {
  final String? email = PrefUtils().getEmail();
  final String? name = PrefUtils().getProfileName();
  final String? mob = PrefUtils().getbasic();
  final TextEditingController textField1 = TextEditingController();
  final TextEditingController textField2 = TextEditingController();
  final TextEditingController textField3 = TextEditingController();
  final TextEditingController textField4 = TextEditingController();
  final TextEditingController textField5 = TextEditingController();
  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();
  final FocusNode focus3 = FocusNode();
  final FocusNode focus4 = FocusNode();
  final FocusNode focus5 = FocusNode();
  final RxString selectedGender = ''.obs;
  final ApiService _apiService = ApiService();

  String? emailChangeOTP;
  String? errorMessage;
  RxBool isLoading = false.obs;

  Future<void> initiateEmailChange(
      String newEmail, BuildContext context) async {
    isLoading.value = true;

    try {
      final response = await _apiService.initiateEmailChange(newEmail);

      if (response['status'] == 'success') {
        CustomToast().showToast(
          context: context,
          message: "Otp sent to your requested email",
          isSuccess: true,
        );
        Get.off(
          () => const VerifyEmailScreen(),
          arguments: {
            'newEmail': newEmail,
          },
          binding: BindingsBuilder(() {
            Get.put(VerifyEmailController());
          }),
        );
      } else if (response['status'] == 'failed') {
        CustomToast().showToast(
          context: context,
          message: "Email is same as old email, please change the email",
          isSuccess: false,
        );
        emailChangeOTP = null;
        errorMessage = response['error']['errorMessage'];
      }
    } catch (e) {
      CustomToast().showToast(
        context: context,
        message: "Email is same as old email, please change the email",
        isSuccess: false,
      );
      emailChangeOTP = null;
      errorMessage = "An error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeUsername(String newUsername, BuildContext context) async {
    try {
      final response = await _apiService.changeUsername(newUsername);

      if (response['success']) {
        CustomToast().showToast(
          context: context,
          message: "Username changed successfully",
          isSuccess: true,
        );
        Get.back();
      } else {
        throw Exception(response['message'] ?? 'Failed to change username');
      }
    } catch (e, stackTrace) {
      CustomToast().showToast(
        context: context,
        message: "Failed to change username",
        isSuccess: false,
      );
      log("Error: $e, $stackTrace");
    }
  }

  @override
  void onClose() {
    textField1.dispose();
    textField2.dispose();
    textField3.dispose();
    textField4.dispose();
    textField5.dispose();
    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    focus4.dispose();
    focus5.dispose();
    super.onClose();
  }
}
