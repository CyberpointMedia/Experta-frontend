import 'dart:io';
import 'dart:ui';

import 'package:experta/widgets/custom_outlined_button.dart';
import 'package:experta/widgets/custom_phone_number.dart';
import 'package:country_pickers/country.dart';
import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/no_internet_connection_error_widget.dart';
import 'package:flutter/gestures.dart';
import 'controller/signin_controller.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SigninController controller = Get.put(SigninController());
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GetBuilder<SigninController>(
        init: SigninController(),
        builder: (controller) {
          return 
          
          controller.isInternetConnected.value?
          
          Stack(
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
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15,
                  ),
                  child: phoneTabContent(),
                ),
              ),
            ],
          )
       
       :NoInternetConnectionErrorWidget();
       
       
        }
      ),
    );
  }

  Widget _buildInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("lbl_phone_number".tr, style: theme.textTheme.titleMedium),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "msg_by_continuing_i2".tr,
              style: theme.textTheme.titleSmall!.copyWith(
                  color: appTheme.blueGray300,
                  fontSize: 14.fSize,
                  fontWeight: FontWeight.w300),
            ),
            TextSpan(
              text: "msg_terms_conditions".tr,
              style: theme.textTheme.titleSmall!.copyWith(
                color: appTheme.black900,
              ),
              recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Navigate to Terms & Conditions page
                
              },
            ),
            TextSpan(
              text: " and ".tr,
              style: theme.textTheme.titleSmall!.copyWith(
                  color: appTheme.blueGray300, fontWeight: FontWeight.w300),
            ),
            TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                
              },
              text: "lbl_privacy_policy".tr,
              style: theme.textTheme.titleSmall!.copyWith(
                color: appTheme.black900,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
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
          isDisabled: false,
          text: "Continue",
          buttonStyle:
               CustomButtonStyles.fillPrimaryTL23
             ,
          buttonTextStyle:
             CustomTextStyles.bodySmall0XFF171717
           ,
          onPressed:  () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  controller.loginUser(context);
                }
              ,
        );

        //un comment if you need validated botton.

        // return CustomElevatedButton(
        //   isDisabled: controller.isPhoneNumberValid.value ? false : true,
        //   text: "Continue",
        //   buttonStyle: controller.isPhoneNumberValid.value
        //       ? CustomButtonStyles.fillPrimaryTL23
        //       : CustomButtonStyles.fillOnError,
        //   buttonTextStyle: controller.isPhoneNumberValid.value
        //       ? CustomTextStyles.bodySmall0XFF171717
        //       : CustomTextStyles.titleMediumGray400,
        //   onPressed: controller.isPhoneNumberValid.value
        //       ? () {
        //           FocusManager.instance.primaryFocus?.unfocus();
        //           controller.loginUser(context);
        //         }
        //       : null,
        // );
      }
    });
  }

  Widget phoneTabContent() {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.85,
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
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontSize: 24.fSize),
                  ),
                ),
                Text('Which part of country that you call home?',
                    style: theme.textTheme.titleSmall),
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
}

Widget _buildOrcontinuewithsocial() {
  return Row(
    children: [
      const Expanded(
        child: Divider(
          thickness: 2,
        ),
      ),
      SizedBox(width: 15.adaptSize),
      Text(
        'Or continue with social',
        style: theme.textTheme.bodySmall!.copyWith(
          fontSize: 12.fSize,
          color: appTheme.black900,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(width: 15.adaptSize),
      const Expanded(
        child: Divider(
          thickness: 1,
        ),
      ),
    ],
  );
}

Widget _buildContinueWithGoogle() {
  return SizedBox(
    height: 52.v,
    width: double.infinity,
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
      buttonStyle: CustomButtonStyles.outlineGray,
      buttonTextStyle: CustomTextStyles.titleSmallGray900,
      buttonColor: appTheme.googlee,
    ),
  );
}

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
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10.v),
        _buildContinueWithGoogle(),
        SizedBox(height: 10.v),
        _buildContinueWithFacebook(),
        SizedBox(height: 10.v),
        Platform.isIOS ? _buildContinueWithApple() : const SizedBox.shrink(),
      ],
    ),
  );
}
