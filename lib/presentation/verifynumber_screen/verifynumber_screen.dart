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
        resizeToAvoidBottomInset: true, // This allows the UI to resize when the keyboard is shown
        body: Stack(
          children: [
            // Positioned(
            //   left: 205,
            //   top: 50,
            //   child: ImageFiltered(
            //     imageFilter: ImageFilter.blur(
            //       sigmaX: 40,
            //       sigmaY: 40,
            //     ),
            //     child: Align(
            //       child: SizedBox(
            //         width: 252,
            //         height: 252,
            //         child: Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(126),
            //             color: appTheme.deepOrangeA20,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                // Makes sure the content is scrollable when the keyboard is up
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(top: 20.adaptSize, bottom: 20.adaptSize),
                      child: CustomAppBar(
                        height: 20.adaptSize,
                        leadingWidth: 25.adaptSize,
                        leading: AppbarLeadingImage(
                          imagePath: ImageConstant.imgIcon,
                          margin: const EdgeInsets.only(left: 10),
                          onTap: () {
                            onTapIcon();
                          },
                        ),
                      ),
                    ),
                    _buildOtpView(),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: 16.h,
            right: 16.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.v, // Ensures padding when the keyboard is shown
          ),
          child: _buildContinue(),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildOtpView() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 10),
            child: Text(
              "msg_we_just_sent_you".tr,
              style: theme.textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(left: 25.adaptSize, bottom: 20.adaptSize),
            child: Builder(
              builder: (context) {
                // Extract the phone number from the controller
                String phoneNumber = controller.phoneNumberController.text;

                // Define the country code
                String countryCode = "+91"; // You can dynamically get this if needed

                // Define the masked number
                String maskedNumber = phoneNumber.length > 3
                    ? "$countryCode ${"*" * (phoneNumber.length - 3)} ${phoneNumber.substring(phoneNumber.length - 3)}"
                    : phoneNumber; // If phoneNumber is less than 3 digits, show it as is

                return RichText(
                  text: TextSpan(
                    style: theme.textTheme.titleSmall,
                    children: [
                      TextSpan(
                        text: "${"msg_enter_the_security".tr} ", // Main text
                      ),
                      TextSpan(
                        text: maskedNumber, // Masked phone number
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, // Bold the number
                          color: Colors.black, // Optional: change color
                        ),
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
            )),
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
                  TextSpan(
                    text: "lbl_resend_code".tr,
                    style: CustomTextStyles.titleSmallGilroyff171717,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        controller.resendOtp(controller.phoneNumberController.text);

                        // Optionally, show feedback to the user
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

  /// Section Widget
  Widget _buildContinue() {
    return Obx(() => CustomElevatedButton(
      isDisabled: controller.complete.value == false,
      text: "lblcontinue".tr,
      buttonTextStyle: CustomTextStyles.bodySmallffffffff,
      onPressed: controller.complete.value
          ? () {
              controller.verifyOtp();
            }
          : null,
    ));
  }

  /// Navigates to the previous screen.
  onTapIcon() {
    Get.back();
  }
}
