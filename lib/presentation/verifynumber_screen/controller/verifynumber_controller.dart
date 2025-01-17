import 'dart:async';
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
  var timerText = '05:00'.obs;
  var isResendButtonVisible = false.obs;
  Timer? _timer;
  int _start = 300;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        isResendButtonVisible.value = true;
        _timer?.cancel();
      } else {
        _start--;
        int minutes = _start ~/ 60;
        int seconds = _start % 60;
        timerText.value =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }
    });
  }

  void verifyOtp(BuildContext context) async {
    VerifyOtpRequestModel requestModel = VerifyOtpRequestModel(
      phoneNo: phoneNumberController.text,
      otp: otpController.value.text,
    );

    try {
      VerifyOtpResponseModel? response =
          await _apiService.verifyOtp(requestModel, context);
      if (response != null && response.status == "success") {
        await prefUtils.setaddress("${response.data!.id}");
        log("hey this is your id ${response.data!.id}");
        await prefUtils.setToken("${response.token}");
        await prefUtils.setbasic("${response.data!.basicInfo}");
        log("hey this is your id ${response.data!.basicInfo}");
        await prefUtils.setMob("${response.data!.phoneNo}");
        log("hey this is your id ${response.data!.phoneNo}");
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
        dynamic responseData = await _apiService.resendOtp(phoneNumber);
        print("Response JSON: $responseData");

        if (responseData is Map<String, dynamic>) {
          String status = responseData['status'];
          var data = responseData['data'];
          if (status == "success") {
            isResendButtonVisible = false.obs;
            startTimer();
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
  void codeUpdated() {
    print("Code updated: $code");
    if (code != null) {
      print("Setting code: $code");
      otpController.value.text = code!;
      complete.value = code!.length == 6;
    }
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
    prefUtils.init();
    initSmsListener();
    var arguments = Get.arguments as List;
    phoneNumberController = arguments[0] as TextEditingController;
  }

  Future<void> initSmsListener() async {
    try {
      listenForCode(smsCodeRegexPattern: r'\d{6}');

      final String signature = await SmsAutoFill().getAppSignature;
      print("Signature: $signature");
    } catch (e) {
      print("Error initializing SMS listener: $e");
    }
  }

  @override
  void onClose() {
    SmsAutoFill().unregisterListener();
    _timer?.cancel();
    super.onClose();
  }
}
