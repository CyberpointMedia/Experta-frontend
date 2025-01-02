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
/// current verifynumberModelObj.
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
  int _start = 300; // Initial countdown time in seconds (5 minutes)

  /// Starts or restarts the countdown timer for OTP.
  void startTimer() {
    // Cancel the existing timer if any
    _timer?.cancel();

    // Reset the start time (in seconds)
    _start = 300; // You can change this to any time you want (e.g., 60 for 1 minute)
    
    // Start the new timer
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

  /// Verifies the OTP entered by the user.
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
        log("User ID: ${response.data!.id}");
        await prefUtils.setToken("${response.token}");
        await prefUtils.setbasic("${response.data!.basicInfo}");
        log("Basic Info: ${response.data!.basicInfo}");
        await prefUtils.setMob("${response.data!.phoneNo}");
        log("Phone Number: ${response.data!.phoneNo}");
        Get.toNamed(AppRoutes.dashboard);
        print("OTP Verified Successfully");
      } else {
        print("OTP Verification failed");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  /// Resends the OTP to the user's phone number.
  void resendOtp(String phoneNumber) async {
    if (phoneNumber.isNotEmpty) {
      try {
        dynamic responseData = await _apiService.resendOtp(phoneNumber);
        print("Response JSON: $responseData");

        String status = responseData.status;
        var data = responseData.data;
        if (status == "success") {
          isResendButtonVisible.value = false;
          startTimer(); // Restart the timer when OTP is resent
          String otp = data['otp'];
          print("OTP sent successfully to your phone number: $otp");
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
    prefUtils.init();
    initSmsListener();

    // Fetch arguments and initialize phone number controller.
    var arguments = Get.arguments as List;
    phoneNumberController = arguments[0] as TextEditingController;

    // Start the timer after initialization.
    startTimer();
  }

  /// Initializes the SMS listener.
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
