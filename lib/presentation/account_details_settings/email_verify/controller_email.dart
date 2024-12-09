// Email Verification Controller
import 'dart:async';
import 'dart:developer';
import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_toast_message.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyEmailController extends GetxController with CodeAutoFill {
  Rx<TextEditingController> otpController = TextEditingController().obs;
  late TextEditingController emailController;
  final ApiService _apiService = ApiService();
  Rx<bool> complete = false.obs;
  PrefUtils prefUtils = PrefUtils();
  var timerText = '02:00'.obs;
  var isResendButtonVisible = false.obs;
  Timer? _timer;
  int _start = 120;

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

  void verifyEmailOtp(BuildContext context, String newEmail, String otp) async {
    try {
      Map<String, dynamic> response =
          await _apiService.verifyOtpChangeEmail(newEmail, otp);

      if (response['status'] == "success") {
        CustomToast().showToast(
          context: context,
          message: "Email Set Successfully",
          isSuccess: true,
        );
        var data = response['data'];
        await prefUtils.setaddress(data['id']);
        await prefUtils.setbasic(data['basicInfo']);
        await prefUtils.setEmail(data['email']);

        Get.back();
        print("Email OTP Verified Successfully");
      } else {
        CustomToast().showToast(
          context: context,
          message: "Email OTP Verification failed",
          isSuccess: false,
        );
        print("Email OTP Verification failed");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
    prefUtils.init();

    // Retrieve the argument
    final arguments = Get.arguments as Map<String, dynamic>;
    final newEmail = arguments['newEmail'] as String;

    // Initialize the email controller with the new email
    emailController = TextEditingController(text: newEmail);
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
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
