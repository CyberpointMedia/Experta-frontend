import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_pin_code_text_field.dart';
import 'package:flutter/gestures.dart';
import 'controller/verifynumber_controller.dart';

class VerifynumberScreen extends GetWidget<VerifynumberController> {
  const VerifynumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned(
              left: 205,
              top: 50,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  tileMode: TileMode.decal,
                  sigmaX: 40,
                  sigmaY: 40,
                ),
                child: Align(
                  child: SizedBox(
                    width: 252,
                    height: 252,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(126),
                        color: appTheme.deepOrangeA20.withOpacity(0.35),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildAppBar(),
                _buildOtpView(),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: 16.h,
            right: 16.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.v,
          ),
          child: _buildContinue(),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      height: 65,
      leadingWidth: 45,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  Widget _buildOtpView() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              "msg_we_just_sent_you".tr,
              style: theme.textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.adaptSize, bottom: 20.adaptSize),
            child: Builder(
              builder: (context) {
                String phoneNumber = controller.phoneNumberController.text;
                String countryCode = "+91";
                String maskedNumber = phoneNumber.length > 3
                    ? "$countryCode ${"*" * (phoneNumber.length - 3)} ${phoneNumber.substring(phoneNumber.length - 3)}"
                    : phoneNumber;

                return RichText(
                  text: TextSpan(
                    style: theme.textTheme.titleSmall,
                    children: [
                      TextSpan(
                        text: "${"msg_enter_the_security".tr} ",
                        style: theme.textTheme.displayMedium!
                            .copyWith(color: appTheme.gray400),
                      ),
                      TextSpan(
                        text: maskedNumber,
                        style: theme.textTheme.displayMedium!
                            .copyWith(color: appTheme.gray400),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Obx(() => CustomPinCodeTextField(
                  context: Get.context!,
                  controller: controller.otpController.value,
                  onChanged: (value) {
                    controller.complete.value = value.length == 6;
                  },
                  enablePinAutofill: true,
                )),
          ),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "msg_didn_t_receive_the2".tr,
                    style: theme.textTheme.titleSmall!
                        .copyWith(color: appTheme.gray400),
                  ),
                  const TextSpan(text: " "),
                  TextSpan(
                    text: "lbl_resend_code".tr,
                    style: CustomTextStyles.titleSmallGilroyff171717,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        controller
                            .resendOtp(controller.phoneNumberController.text);
                        Get.snackbar(
                          'OTP Resent',
                          'A new security code has been sent to your phone number.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinue() {
    return Obx(() => CustomElevatedButton(
          isDisabled: !controller.complete.value,
          text: "lblcontinue".tr,
          buttonTextStyle: CustomTextStyles.bodySmall0XFF171717,
          onPressed: controller.complete.value
              ? () {
                  controller.verifyOtp();
                }
              : null,
        ));
  }

  void onTapIcon() {
    Get.back();
  }
}
