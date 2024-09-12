import 'dart:developer';


import 'package:experta/data/models/request/verify_otp_request_model.dart';
import 'package:experta/data/models/response/verify_otp_response_model.dart';

import '../../../core/app_export.dart';
import '../models/verifynumber_model.dart';
import 'package:sms_autofill/sms_autofill.dart';

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
        await prefUtils.setaddress("${response.data!.id}");
        log("hey this is your id ${response.data!.id}");
        await prefUtils.setToken("${response.token}");
        await prefUtils.setbasic("${response.data!.basicInfo}");
        log("hey this is your id ${response.data!.basicInfo}");
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

void resendOtp(String phoneNumber) async {
  if (phoneNumber.isNotEmpty) {
    try {
      // Make the API call directly with phoneNumber as a string
      dynamic responseData = await _apiService.resendOtp(phoneNumber);
      print("Response JSON: $responseData");

      if (responseData is Map<String, dynamic>) {
        // Directly access the data from response
        String status = responseData['status'];
        var data = responseData['data'];
        if (status == "success") {
          // Update UI based on response
          String otp = data['otp'];
          print("OTP Resent Successfully: $otp");
        } else {
          print("OTP Resend failed");
        }
      } else {
        print("Invalid response format");
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
