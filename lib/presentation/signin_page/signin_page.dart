import 'dart:ui';

import 'package:experta/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:experta/widgets/custom_phone_number.dart';
import 'package:country_pickers/country.dart';
import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:experta/core/app_export.dart';
import 'package:flutter/widgets.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/signin_controller.dart';

class SigninPage extends StatefulWidget {
  SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  final SigninController controller = Get.put(SigninController());
  bool isPhoneSelected = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned(
              left: 270,
              top: 50,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 60,
                  sigmaY: 60,
                ),
                child: Align(
                  child: SizedBox(
                    width: 252,
                    height: 252,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(126),
                        color: appTheme.deepOrangeA20.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 25),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      width: 175,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffe4e4e4)),
                        color: const Color(0xffffffff),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isPhoneSelected = true;
                              });
                            },
                            child: Container(
                              // phoneYN3 (8:10266)
                              width: 80,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: isPhoneSelected
                                    ? const Color(0xff171717)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  'Log In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    color: isPhoneSelected
                                        ? const Color(0xffffffff)
                                        : appTheme.blueGray300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isPhoneSelected = false;
                              });
                            },
                            child: Container(
                              width: 80,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: !isPhoneSelected
                                    ? const Color(0xff171717)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(150),
                              ),
                              child: Center(
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    color: !isPhoneSelected
                                        ? const Color(0xffffffff)
                                        : appTheme.blueGray300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isPhoneSelected,
                    child: phoneTabContent(),
                  ),
                  Visibility(
                    visible: !isPhoneSelected,
                    child: emailTabContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "lbl_phone_number".tr,
          style: theme.textTheme.titleSmall,
        ),
        SizedBox(height: 6.v),
        Obx(
          () => CustomPhoneNumber(
            country: controller.selectedCountry.value,
            controller: controller.phoneNumberController,
            onTap: (Country value) {
              controller.selectedCountry.value = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTermsText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "msg_by_continuing_i2".tr,
            style: CustomTextStyles.bodyMediumff95a4b7,
          ),
          TextSpan(
            text: "msg_terms_conditions".tr,
            style: CustomTextStyles.titleSmallff171717,
          ),
          TextSpan(
            text: "lbl".tr,
            style: CustomTextStyles.bodyMediumff95a4b7,
          ),
          TextSpan(
            text: "lbl_privacy_policy".tr,
            style: CustomTextStyles.titleSmallff171717,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContinueButton() {
    return Obx(() => CustomElevatedButton(
          text: "lbl_continue".tr,
          buttonStyle: controller.isPhoneNumberValid.value
              ? CustomButtonStyles.yellow900
              : CustomButtonStyles.fillOnError,
          buttonTextStyle: controller.isPhoneNumberValid.value
              ? CustomTextStyles.bodySmallffffffff
              : CustomTextStyles.titleMediumGray400,
          onPressed: controller.isPhoneNumberValid.value
              ? () => controller.loginUser(context)
              : null,
        ));
  }

  Widget phoneTabContent() {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Form(
        key: _formKey,
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                  child: const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      height: 1.2575,
                      color: Color(0xff171717),
                    ),
                  ),
                ),
                const Text(
                  'Which part of country that you call home?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.2575,
                    color: Color(0xff95a4b7),
                  ),
                ),
                const SizedBox(height: 29),
                _buildInputField(),
                const SizedBox(height: 18),
                _buildContinueButton(),
                const SizedBox(height: 25),
                _buildOrcontinuewithsocial(),
                SizedBox(height: 15.v),
                _buildLoginOption(),
                const Spacer(),
                _buildTermsText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailTabContent() {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        key: _formKey1,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 29),
                _buildFirstName(),
                SizedBox(height: 15.v),
                _buildInputField2(),
                SizedBox(height: 15.v),
                _buildInputField1(),
                const SizedBox(height: 18),
                _buildContinueButton2(),
                const SizedBox(height: 25),
                _buildOrcontinuewithsocial(),
                SizedBox(height: 15.v),
                _buildLoginOption(),
                const Spacer(),
                _buildTermsText(),
                SizedBox(height: 15.v),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "lbl_email".tr,
          style: theme.textTheme.titleSmall,
        ),
        SizedBox(height: 6.v),
        CustomTextFormField(
          controller: controller.emailController,
          focusNode: controller.emailFocusNode,
          hintText: "lbl_your_email".tr,
          hintStyle: CustomTextStyles.titleMediumBluegray300,
          textInputType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || (!isValidEmail(value, isRequired: true))) {
              return "err_msg_please_enter_valid_email".tr;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildInputField1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "lbl_phone_number".tr,
          style: theme.textTheme.titleSmall,
        ),
        SizedBox(height: 6.v),
        Obx(
          () => CustomPhoneNumber(
            country: controller.selectedCountry.value,
            controller: controller.phoneNumberController,
            onTap: (Country value) {
              controller.selectedCountry.value = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton2() {
    return Column(
      children: [
        Obx(() => CustomElevatedButton(
              text: "Sign Up".tr,
              buttonStyle: controller.isEmailValid.value
                  ? CustomButtonStyles.yellow900
                  : CustomButtonStyles.fillOnError,
              buttonTextStyle: controller.isEmailValid.value
                  ? CustomTextStyles.bodySmallffffffff
                  : CustomTextStyles.titleMediumGray400,
              onPressed: controller.isEmailValid.value
                  ? () => controller.registerUser(context)
                  : null,
            )),
        Obx(() {
          if (controller.errorMessage.isNotEmpty) {
            return Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            );
          }
          return Container();
        }),
      ],
    );
  }

  Widget _buildFirstName() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "First Name".tr,
              style: theme.textTheme.titleSmall,
            ),
            SizedBox(height: 6.v),
            CustomTextFormField(
              width: 150,
              controller: controller.nameController,
              focusNode: controller.nameFocusNode,
              hintText: "First Name".tr,
              hintStyle: CustomTextStyles.titleMediumBluegray300,
              textInputType: TextInputType.name,
            ),
          ],
        ),
        SizedBox(width: 20.v),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Last Name".tr,
              style: theme.textTheme.titleSmall,
            ),
            SizedBox(height: 6.v),
            CustomTextFormField(
              width: 150,
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
              hintText: "Last Name".tr,
              hintStyle: CustomTextStyles.titleMediumBluegray300,
              textInputType: TextInputType.name,
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildOrcontinuewithsocial() {
  return const Row(
    children: [
      Expanded(
        child: Divider(
          thickness: 2, // Adjust thickness as needed
        ),
      ),
      Text(
        'Or continue with social',
        style: TextStyle(color: Colors.black),
      ),
      Expanded(
        child: Divider(
          thickness: 2, // Adjust thickness as needed
        ),
      ),
    ],
  );
}

Widget _buildContinueWithGoogle() {
  return CustomOutlinedButton(
    height: 52.v,
    text: "msg_continue_with_google".tr,
    leftIcon: Container(
      margin: EdgeInsets.only(right: 10.h),
      child: CustomImageView(
        imagePath: ImageConstant.imgGoogle,
        height: 24.adaptSize,
        width: 24.adaptSize,
      ),
    ),
    buttonStyle: CustomButtonStyles.outlineGray,
    buttonTextStyle: CustomTextStyles.titleSmallGray900,
    buttonColor: appTheme.googlee,
  );
}

/// Section Widget
Widget _buildContinueWithFacebook() {
  return CustomOutlinedButton(
    height: 52.v,
    text: "msg_continue_with_facebook".tr,
    leftIcon: Container(
      margin: EdgeInsets.only(right: 10.h),
      child: CustomImageView(
        imagePath: ImageConstant.imgFacebook,
        height: 24.adaptSize,
        width: 24.adaptSize,
      ),
    ),
    buttonStyle: CustomButtonStyles.outlineGray,
    buttonTextStyle: CustomTextStyles.titleSmallGray900,
    buttonColor: appTheme.facebokk,
  );
}

/// Section Widget
Widget _buildContinueWithApple() {
  return CustomOutlinedButton(
    height: 52.v,
    text: "msg_continue_with_apple".tr,
    leftIcon: Container(
      margin: EdgeInsets.only(right: 10.h),
      child: CustomImageView(
        imagePath: ImageConstant.imgSocialIcon,
        height: 24.adaptSize,
        width: 24.adaptSize,
      ),
    ),
    buttonStyle: CustomButtonStyles.outlineGray,
    buttonTextStyle: CustomTextStyles.titleSmallGray900,
    buttonColor: Colors.black,
  );
}

Widget _buildLoginOption() {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: EdgeInsets.only(
        left: 16.h,
        right: 16.h,
        // bottom: 155.v,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15.v),
          _buildContinueWithGoogle(),
          SizedBox(height: 15.v),
          _buildContinueWithFacebook(),
          SizedBox(height: 15.v),
          _buildContinueWithApple(),
        ],
      ),
    ),
  );
}
