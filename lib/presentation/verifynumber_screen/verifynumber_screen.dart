import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:experta/widgets/custom_pin_code_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'controller/verifynumber_controller.dart';

class VerifynumberScreen extends GetWidget<VerifynumberController> {
  const VerifynumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            left: 205,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
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
                      color: appTheme.deepOrangeA20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
              width: double.maxFinite,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: CustomAppBar(
                          height: 20,
                          leadingWidth: 25,
                          leading: AppbarLeadingImage(
                              imagePath: ImageConstant.imgIcon,
                              margin: const EdgeInsets.only(left: 10),
                              onTap: () {
                                onTapIcon();
                              })),
                    ),
                    _buildOtpView(),
                    const Spacer(),
                    _buildContinue()
                  ])),
        ],
      ),
    ));
  }

  /// Section Widget
  Widget _buildOtpView() {
    return SizedBox(
        // height: 252.v,
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 10),
                child: Text("msg_we_just_sent_you".tr,
                    style: theme.textTheme.headlineSmall),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, bottom: 20),
                child: Text("msg_enter_the_security".tr,
                    style: theme.textTheme.titleSmall),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Obx(() => CustomPinCodeTextField(
                    context: Get.context!,
                    controller: controller.otpController.value,
                    onChanged: (value) {
                      controller.complete.value = value.length == 6;
                    })),
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "msg_didn_t_receive_the2".tr,
                        style: CustomTextStyles.titleSmallGilroyff95a4b7,
                      ),
                      const TextSpan(text: " "),
                      // Wrap this TextSpan with GestureDetector
                      TextSpan(
                        text: "lbl_resend_code".tr,
                        style: CustomTextStyles.titleSmallGilroyff171717,
                        // Define onTap callback to call resendOtp() function
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            controller.resendOtp();
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ]));
  }

  /// Section Widget
  Widget _buildContinue() {
    return Obx(() => CustomElevatedButton(
          isDisabled: controller.complete.value == false,
          text: "lbl_continue".tr,
          margin: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 54.v),
          buttonTextStyle: CustomTextStyles.bodySmallffffffff,
          onPressed: () {
            controller.verifyOtp();
            // Get.toNamed(AppRoutes.homePage);
          },
        ));
  }

  /// Navigates to the previous screen.
  onTapIcon() {
    Get.back();
  }
}
