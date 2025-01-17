import 'package:experta/data/apiClient/api_service.dart';
import 'package:experta/data/models/request/resend_otp_request_model.dart';
import 'package:experta/data/models/request/verify_otp_request_model.dart';
import 'package:experta/data/models/response/resend_otp_response_model.dart';
import 'package:experta/data/models/response/verify_otp_response_model.dart';

import '../../../core/app_export.dart';
import '../models/verifynumber_model.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter/material.dart';

/// A controller class for the VerifynumberScreen.
///
/// This class manages the state of the VerifynumberScreen, including the
/// current verifynumberModelObj
class VerifynumberController extends GetxController with CodeAutoFill {
  Rx<TextEditingController> otpController = TextEditingController().obs;
  late TextEditingController phoneNumberController;
  Rx<VerifynumberModel> verifynumberModelObj = VerifynumberModel().obs;
  final ApiService _apiService = ApiService();
  Rx<bool> complete = false.obs;
  PrefUtils prefUtils = PrefUtils();

  @override
  void codeUpdated() {
    otpController.value.text = code ?? '';
  }

  void verifyOtp() async {
    VerifyOtpRequestModel requestModel = VerifyOtpRequestModel(
      phoneNo: phoneNumberController.text,
      otp: otpController.value.text,
    );

    try {
      VerifyOtpResponseModel? response =
          await _apiService.verifyOtp(requestModel);
      if (response != null && response.status == "success") {
        await prefUtils.setToken("${response.token}");
        // Handle success response
        Get.toNamed(AppRoutes.dashboard);
        print("OTP Verified Successfully");
      } else {
        print("OTP Verification failed");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  void resendOtp() async {
    final phoneNumber = phoneNumberController.text;
    if (phoneNumber.isNotEmpty) {
      ResendOtpRequestModel requestModel = ResendOtpRequestModel(
        phoneNo: phoneNumber,
      );
      try {
        dynamic responseData = await _apiService.resendOtp(requestModel);
        print("Response JSON: $responseData");
        ResendOtpResponseModel? response =
            ResendOtpResponseModel.fromJson(responseData);
        if (response != null && response.status == "success") {
          // Update UI based on response
          print("OTP Resent Successfully: ${response.data?.otp}");
        } else {
          print("OTP Resend failed");
        }
      } catch (e) {
        print("Exception occurred: $e");
      }
    } else {
      print("Phone number is empty");
    }
  }

  @override
  void onInit() {
    super.onInit();
    prefUtils.init();
    listenForCode();
    var arguments = Get.arguments as List;
    phoneNumberController = arguments[0] as TextEditingController;
    otpController.value.text = arguments[1] as String;
  }
}
