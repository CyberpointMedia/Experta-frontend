import 'dart:ui';

import 'package:experta/widgets/custom_outlined_button.dart';
import 'package:experta/widgets/custom_phone_number.dart';
import 'package:country_pickers/country.dart';
import 'package:experta/core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/custom_text_form_field.dart';
import 'controller/signin_controller.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                tileMode: TileMode.decal,
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
                      color: appTheme.deepOrangeA20.withOpacity(0.35),
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
                  padding: const EdgeInsets.fromLTRB(10, 56, 10, 25),
                  child: Container(
                    width: 138.h,
                    height: 31.v,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffe4e4e4)),
                      color: const Color(0xffffffff),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPhoneSelected = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isPhoneSelected
                                    ? const Color(0xff171717)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'Log In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.fSize,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5.v,
                                    color: isPhoneSelected
                                        ? const Color(0xffffffff)
                                        : const Color(
                                            0xff000000), // Dark black color
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPhoneSelected = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: !isPhoneSelected
                                    ? const Color(0xff171717)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14.fSize,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5.v,
                                      color: !isPhoneSelected
                                          ? appTheme.whiteA700
                                          : appTheme
                                              .black900 // Dark black color
                                      ),
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
    );
  }

  Widget _buildInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "lbl_phone_number".tr,
          style: theme.textTheme.bodyMedium!
              .copyWith(color: Colors.black), // Set text color to black
        ),
        SizedBox(height: 3.v),
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
      textScaleFactor: 1.01,
      text: TextSpan(
        children: [
          TextSpan(
            text: "msg_by_continuing_i2".tr,
            style: theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray400,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w500,

      ),
          ),
          TextSpan(
            text: "msg_terms_conditions".tr,
            style:theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
                fontSize: 14.fSize,

        fontWeight: FontWeight.w400,
      ),
          ),
          TextSpan(
            text: "lbl".tr,
              style: theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray400,
                fontSize: 14.fSize,

        fontWeight: FontWeight.w500,

      ),
          ),
          TextSpan(
            text: "lbl_privacy_policy".tr,
           style:theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black900,
                fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
      ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContinueButton() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      } else {
        return CustomElevatedButton(
          text: "lbl_continue".tr,
          buttonStyle: controller.isPhoneNumberValid.value
              ? CustomButtonStyles.fillPrimaryTL23
              : CustomButtonStyles.fillOnError,
          buttonTextStyle: controller.isPhoneNumberValid.value
              ? CustomTextStyles.bodySmall0XFF171717
              : CustomTextStyles.titleMediumGray400,
          onPressed: controller.isPhoneNumberValid.value
              ? () => controller.loginUser(context)
              : null,
        );
      }
    });
  }

  Widget phoneTabContent() {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.87,
      child: Form(
        key: _formKey,
        child: Container(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.adaptSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 24.fSize,
                      fontWeight: FontWeight.w500,
                      height: 1.2575,
                      color: const Color(0xff171717),
                    ),
                  ),
                ),
                Text(
                  'Which part of country that you call home?',
                  style: TextStyle(
                    fontSize: 14.fSize,
                    fontWeight: FontWeight.w500,
                    height: 1.2575,
                    color: const Color(0xff95a4b7),
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
                SizedBox(height: 15.v),
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
      height: MediaQuery.of(context).size.height * 0.87,
      child: Form(
        key: _formKey1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.adaptSize),
          child: Column(
            children: [
              const SizedBox(height: 19),
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
    );
  }

  Widget _buildInputField2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "lbl_email".tr,
          style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black,
                 fontSize: 14.fSize, // Set text color to black
                fontWeight: FontWeight.w500, // Set font weight to 500
              ),  // Set text color to black
        ),
        SizedBox(height: 3.v),
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
          style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black,
                 fontSize: 14.fSize, // Set text color to black
                fontWeight: FontWeight.w500, // Set font weight to 500
              ),
        ),
        SizedBox(height: 3.v),
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
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            );
          } else {
            return CustomElevatedButton(
              text: "Sign Up".tr,
              buttonStyle: (controller.isEmailValid.value &&
                      controller.isPhoneNumberValid.value &&
                      controller.isTextValid.value)
                  ? CustomButtonStyles.fillPrimaryTL23
                  : CustomButtonStyles.fillOnError,
              buttonTextStyle: (controller.isEmailValid.value &&
                      controller.isPhoneNumberValid.value &&
                      controller.isTextValid.value)
                  ? CustomTextStyles.bodySmall0XFF171717
                  : CustomTextStyles.titleMediumGray400,
              onPressed: (controller.isEmailValid.value &&
                      controller.isPhoneNumberValid.value &&
                      controller.isTextValid.value)
                  ? () => controller.registerUser(context)
                  : null,
            );
          }
        }),
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
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black,
                 fontSize: 14.fSize, // Set text color to black
                fontWeight: FontWeight.w500, // Set font weight to 500
              ),
            ),
            SizedBox(height: 3.v),
            CustomTextFormField(
              width: 150.v,
              controller: controller.nameController,
              focusNode: controller.nameFocusNode,
              hintText: "First name".tr,
              hintStyle: CustomTextStyles.titleMediumBluegray300.copyWith(),
              textInputType: TextInputType.name,
            ),
          ],
        ),
        SizedBox(width: 15.v),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Last Name".tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black,
                fontSize: 14.fSize, // Set text color to black
                fontWeight: FontWeight.w500, // Set font weight to 500
              ),
            ),
            SizedBox(height: 3.v),
            CustomTextFormField(
              width: 166.v,
              controller: controller.passwordController,
              focusNode: controller.passwordFocusNode,
              hintText: "Last name".tr,
              hintStyle: CustomTextStyles.titleMediumBluegray300.copyWith(),
              textInputType: TextInputType.name,
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildOrcontinuewithsocial() {
  return Row(
    children: [
      const Expanded(
        child: Divider(
          thickness: 2, // Adjust thickness as needed
        ),
      ),
      SizedBox(width: 15.adaptSize), // Add space between divider and text
       Text(
        'Or continue with social',
       style:theme.textTheme.bodySmall!.copyWith(
        fontSize: 12.fSize,
        color: appTheme.black900,
        fontWeight: FontWeight.w500,
      ),
      ),
      SizedBox(width: 15.adaptSize), // Add space between text and divider
      const Expanded(
        child: Divider(
          thickness: 1, // Adjust thickness as needed
        ),
      ),
    ],
  );
}

Widget _buildContinueWithGoogle() {
  return SizedBox(
    height: 52.v, // Match the height with the "Sign Up" button
    width:
        double.infinity, // Set width to fill the available space like "Sign Up"
    child: CustomOutlinedButton(
      text: "msg_continue_with_google".tr,
      leftIcon: Container(
        margin: EdgeInsets.only(right: 10.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgGoogle,
          height: 24.adaptSize,
          width: 24.adaptSize,
        ),
      ),
      buttonStyle: CustomButtonStyles.outlineGray, // Set button style
      buttonTextStyle: CustomTextStyles.titleSmallGray900, // Set text style
      buttonColor: appTheme.googlee,
    ),
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
        left: 0.h,
        right: 0.h,
        // bottom: 155.v,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10.v),
          _buildContinueWithGoogle(),
          SizedBox(height: 10.v),
          _buildContinueWithFacebook(),
          SizedBox(height: 10.v),
          _buildContinueWithApple(),
        ],
      ),
    ),
  );
}
