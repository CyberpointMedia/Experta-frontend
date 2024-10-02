import 'dart:ui';

import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:experta/widgets/custom_outlined_button.dart';
import 'package:experta/core/app_export.dart';
import 'controller/onboarding_controller.dart';

// ignore_for_file: must_be_immutable
class OnboardingScreen extends GetWidget<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.maxFinite,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 596.v,
                width: 343.h,
                child: _buildRectangle(),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 500,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 131,
                  vertical: 207,
                ),
                decoration: AppDecoration
                    .gradientOnPrimaryContainerToOnPrimaryContainer,
              ),
            ),
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
            Positioned(
              right: 270,
              top: 50,
              child: Opacity(
                opacity: 0.2,
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
                          color: appTheme.yellow6001e.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 270,
              top: 350,
              child: Opacity(
                opacity: 0.2,
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
                          color: appTheme.yellow6001e.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white,
                height: 450.v,
                child: Column(
                  children: [
                    Text(
  "msg_sign_up_or_log_in".tr,
  style: CustomTextStyles.bodyLargeGray900.copyWith(
    fontWeight: FontWeight.w400, // Setting font weight to 400
  ),
),

                    SizedBox(height: 15.v),
                    _buildLoginOption(),
                    const Spacer(),
                    Container(
                      width: 334.h,
                      margin: EdgeInsets.only(bottom: 51.v),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "msg_by_clicking_the2".tr,
                              style: CustomTextStyles.bodyMediumff95a4b7,
                            ),
                            TextSpan(
                              text: "msg_terms_of_service".tr,
                              style: CustomTextStyles.titleSmallff171717,
                            ),
                            TextSpan(
                              text: "msg_and_acknowledged".tr,
                              style: CustomTextStyles.bodyMediumff95a4b7,
                            ),
                            TextSpan(
                              text: "lbl_privacy_policy".tr,
                              style: CustomTextStyles.titleSmallff171717,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildRectangle() {
    // Define a list of image paths. Replace these with your actual image paths.
    final List<String> imagePaths = [
      ImageConstant.imgRectangle101,
      ImageConstant.imgRectangle102,
      ImageConstant.imgRectangle103,
      ImageConstant.imgRectangle104,
      ImageConstant.imgRectangle105,
      ImageConstant.imgRectangle106,
      ImageConstant.imgRectangle107,
      ImageConstant.imgRectangle108,
    ];

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 182.v, left: 10, right: 10),
        child: StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 6,
          itemCount: imagePaths.length,
          itemBuilder: (BuildContext context, int index) {
            return CustomImageView(
              imagePath: imagePaths[index],
              // height: 271.v,
              // width: 144.h,
              radius: BorderRadius.circular(15.h),
            );
          },
          staggeredTileBuilder: (int index) => const StaggeredTile.fit(2),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildContinueWithPhoneemail() {
    return CustomOutlinedButton(
      height: 52.v,
      text: "msg_continue_with_phone_email".tr,
      leftIcon: Container(
        margin: EdgeInsets.only(right: 10.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgSmartphone,
          height: 24.adaptSize,
          width: 24.adaptSize,
        ),
      ),
      buttonStyle: CustomButtonStyles.outlineGray,
      buttonTextStyle: CustomTextStyles.titleSmallGray900,
      onPressed: () {
        Get.toNamed(AppRoutes.signinPage);
      },
    );
  }

  /// Section Widget
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

  /// Section Widget
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
            _buildContinueWithPhoneemail(),
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
}
