import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/settings_log_out_dialog/controller/settings_log_out_controller.dart';
import 'package:experta/presentation/settings_log_out_dialog/settings_log_out_dialog.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'controller/setting_controller.dart';

class SettingScreen extends GetWidget<SettingController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
            width: SizeUtils.width,
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.only(bottom: 5.v),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.v),
                          _buildAppBar(),
                          _buildShareProfile(),
                          SizedBox(height: 16.v),
                          Padding(
                              padding: EdgeInsets.only(left: 16.h),
                              child: Text("lbl_basic_settings".tr,
                                  style: CustomTextStyles
                                      .titleMediumBluegray30018)),
                          SizedBox(height: 12.v),
                          _buildShield1(),
                          SizedBox(height: 16.v),
                          Padding(
                              padding: EdgeInsets.only(left: 16.h),
                              child: Text("lbl_basic_settings".tr,
                                  style: CustomTextStyles
                                      .titleMediumBluegray30018)),
                          SizedBox(height: 12.v),
                          _buildInfo1()
                        ])))));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
        height: 40.h,
        leadingWidth: 40.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
            margin: EdgeInsets.only(left: 16.h),
            onTap: () {
              onTapArrowLeft();
            }),
        centerTitle: true,
        title: AppbarSubtitleSix(text: "lbl_settings".tr));
  }

  /// Section Widget
  Widget _buildBasicSettings() {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
            padding: EdgeInsets.only(right: 16.h, top: 10.v),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("lbl_basic_settings".tr,
                      style: CustomTextStyles.titleMediumBluegray30018),
                  SizedBox(height: 12.v),
                  Container(
                      decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                          color: Colors.transparent,
                          borderRadius: BorderRadiusStyle.roundedBorder20),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.accountSetting);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.h, vertical: 16.v),
                              decoration: AppDecoration.fillOnPrimaryContainer
                                  .copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.customBorderBL20),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconButton(
                                        height: 44.adaptSize,
                                        width: 44.adaptSize,
                                        padding: EdgeInsets.all(6.h),
                                        decoration:
                                            IconButtonStyleHelper.fillPrimary,
                                        child: CustomImageView(
                                            imagePath:
                                                "assets/images/account.svg")),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.h,
                                            top: 13.v,
                                            bottom: 10.v),
                                        child: Text("msg_account_settings".tr,
                                            style: theme.textTheme.titleMedium!
                                                .copyWith(
                                                    color: appTheme.gray900))),
                                    const Spacer(),
                                    CustomImageView(
                                        imagePath:
                                            ImageConstant.imgArrowRightGray900,
                                        height: 24.adaptSize,
                                        width: 24.adaptSize,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.v))
                                  ])),
                        ),
                        GestureDetector(
                          onTap: () {
                            onTapmybooking();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.h, vertical: 16.v),
                                decoration:
                                    AppDecoration.fillOnPrimaryContainer,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomIconButton(
                                          height: 44.adaptSize,
                                          width: 44.adaptSize,
                                          padding: EdgeInsets.all(6.h),
                                          decoration: IconButtonStyleHelper
                                              .fillDeepPurple,
                                          child: CustomImageView(
                                            imagePath:
                                                "assets/images/Calendar.svg",
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.h,
                                              top: 13.v,
                                              bottom: 10.v),
                                          child: Text("lbl_my_booking".tr,
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                      color:
                                                          appTheme.gray900))),
                                      const Spacer(),
                                      CustomImageView(
                                          imagePath: ImageConstant
                                              .imgArrowRightGray900,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.v))
                                    ])),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.payment);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.h, vertical: 16.v),
                                decoration:
                                    AppDecoration.fillOnPrimaryContainer,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomIconButton(
                                          height: 44.adaptSize,
                                          width: 44.adaptSize,
                                          padding: EdgeInsets.all(8.h),
                                          decoration: IconButtonStyleHelper
                                              .fillGreenTL24,
                                          child: CustomImageView(
                                            imagePath: ImageConstant.wallet,
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.h,
                                              top: 13.v,
                                              bottom: 10.v),
                                          child: Text("lbl_payment".tr,
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                      color:
                                                          appTheme.gray900))),
                                      const Spacer(),
                                      CustomImageView(
                                          imagePath: ImageConstant
                                              .imgArrowRightGray900,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.v))
                                    ])),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.h, vertical: 16.v),
                              decoration: AppDecoration.fillOnPrimaryContainer,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconButton(
                                        height: 44.adaptSize,
                                        width: 44.adaptSize,
                                        padding: EdgeInsets.all(10.h),
                                        decoration:
                                            IconButtonStyleHelper.fillOrange,
                                        child: CustomImageView(
                                          imagePath: "assets/images/camera.svg",
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.h,
                                            top: 13.v,
                                            bottom: 10.v),
                                        child: Text("msg_recorded_sessions".tr,
                                            style: theme.textTheme.titleMedium!
                                                .copyWith(
                                                    color: appTheme.gray900))),
                                    const Spacer(),
                                    CustomImageView(
                                        imagePath:
                                            ImageConstant.imgArrowRightGray900,
                                        height: 24.adaptSize,
                                        width: 24.adaptSize,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.v))
                                  ])),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.bank);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.h, vertical: 16.v),
                                decoration: AppDecoration.fillOnPrimaryContainer
                                    .copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.customBorderL20),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomIconButton(
                                          height: 44.adaptSize,
                                          width: 44.adaptSize,
                                          padding: EdgeInsets.all(6.h),
                                          decoration: IconButtonStyleHelper
                                              .fillGrayTL22,
                                          child: CustomImageView(
                                            imagePath:
                                                "assets/images/verifyaccount.svg",
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.h,
                                              top: 13.v,
                                              bottom: 10.v),
                                          child: Text("lbl_verify_account".tr,
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                      color:
                                                          appTheme.gray900))),
                                      const Spacer(),
                                      CustomImageView(
                                          imagePath: ImageConstant
                                              .imgArrowRightGray900,
                                          height: 24.adaptSize,
                                          width: 24.adaptSize,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.v))
                                    ])),
                          ),
                        ),
                      ]))
                ])));
  }

  /// Section Widget
  Widget _buildShareProfile() {
    return Container(
        height: 595.v,
        width: 359.h,
        margin: EdgeInsets.only(left: 16.h),
        child: Stack(alignment: Alignment.topLeft, children: [
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
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin:
                      EdgeInsets.only(top: 71.v, right: 16.h, bottom: 436.v),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.h, vertical: 17.v),
                  decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder20),
                  child: Row(children: [
                    (controller.imagePath != "")? CustomImageView(
                              imagePath: controller.imagePath,
                              height: 48.adaptSize,
                              width: 48.adaptSize,
                              radius: BorderRadius.circular(24.h),
                              alignment: Alignment.center):CustomImageView(
                              imagePath: 'assets/images/image_not_found.png',
                              height: 48.adaptSize,
                              width: 48.adaptSize,
                              radius: BorderRadius.circular(24.h),
                              alignment: Alignment.center),
                    Padding(
                        padding: EdgeInsets.only(left: 15.h),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.name.toString(),
                                  style: CustomTextStyles.titleMediumSemiBold),
                              SizedBox(height: 4.v),
                              GestureDetector(
                                  onTap: () {
                                    // onTapEditProfile();
                                    Get.toNamed(
                                      AppRoutes.editProfileSetting,
                                    );
                                  },
                                  child: Row(children: [
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 1.v),
                                        child: Text("lbl_edit_profile".tr,
                                            style: theme.textTheme.bodyMedium)),
                                    CustomImageView(
                                        imagePath: ImageConstant.imgArrowRight,
                                        height: 18.adaptSize,
                                        width: 18.adaptSize,
                                        margin: EdgeInsets.only(left: 3.h))
                                  ]))
                            ])),
                    const Spacer(),
                    CustomElevatedButton(
                        height: 34.v,
                        width: 84.h,
                        text: "lbl_share_profile".tr,
                        margin: EdgeInsets.symmetric(vertical: 7.v),
                        buttonStyle: CustomButtonStyles.fillGreen,
                        buttonTextStyle: CustomTextStyles.labelLargeGray900)
                  ]))),
          _buildBasicSettings()
        ]));
  }

  /// Section Widget
  Widget _buildShield1() {
    return Align(
        alignment: Alignment.center,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            decoration: AppDecoration.fillOnPrimaryContainer
                .copyWith(color: Colors.transparent),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.security);
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 16.v),
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderBL20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconButton(
                              height: 44.adaptSize,
                              width: 44.adaptSize,
                              padding: EdgeInsets.all(6.h),
                              decoration: IconButtonStyleHelper.fillGreenTL24,
                              child: CustomImageView(
                                imagePath: "assets/images/Insurance.svg",
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 15.h, top: 13.v, bottom: 10.v),
                              child: Text("msg_security_privacy".tr,
                                  style: theme.textTheme.titleMedium!
                                      .copyWith(color: appTheme.gray900))),
                          const Spacer(),
                          CustomImageView(
                              imagePath: ImageConstant.imgArrowRightGray900,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              margin: EdgeInsets.symmetric(vertical: 10.v))
                        ])),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 16.v),
                    decoration: AppDecoration.fillOnPrimaryContainer,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconButton(
                              height: 44.adaptSize,
                              width: 44.adaptSize,
                              padding: EdgeInsets.all(6.h),
                              decoration: IconButtonStyleHelper
                                  .fillPrimaryContainerTL22,
                              child: CustomImageView(
                                imagePath: "assets/images/Ringing.svg",
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 15.h, top: 13.v, bottom: 10.v),
                              child: Text("msg_notification_settings".tr,
                                  style: theme.textTheme.titleMedium!
                                      .copyWith(color: appTheme.gray900))),
                          const Spacer(),
                          CustomImageView(
                              imagePath: ImageConstant.imgArrowRightGray900,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              margin: EdgeInsets.symmetric(vertical: 10.v))
                        ])),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 16.v),
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderL20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconButton(
                              height: 44.adaptSize,
                              width: 44.adaptSize,
                              padding: EdgeInsets.all(6.h),
                              decoration: IconButtonStyleHelper.fillYellowE,
                              child: CustomImageView(
                                imagePath: "assets/images/Star.svg",
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 15.h, top: 13.v, bottom: 10.v),
                              child: Text("msg_referral_program".tr,
                                  style: theme.textTheme.titleMedium!
                                      .copyWith(color: appTheme.gray900))),
                          const Spacer(),
                          CustomImageView(
                              imagePath: ImageConstant.imgArrowRightGray900,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              margin: EdgeInsets.symmetric(vertical: 10.v))
                        ])),
              ),
            ])));
  }

  /// Section Widget
  Widget _buildInfo1() {
    return Align(
        alignment: Alignment.center,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                color: Colors.transparent,
                borderRadius: BorderRadiusStyle.roundedBorder20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.aboutus);
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 16.v),
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderBL20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconButton(
                              height: 44.adaptSize,
                              width: 44.adaptSize,
                              padding: EdgeInsets.all(6.h),
                              decoration: IconButtonStyleHelper.fillDeepPurple,
                              child: CustomImageView(
                                imagePath: "assets/images/Info.svg",
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 15.h, top: 13.v, bottom: 10.v),
                              child: Text("lbl_about_us".tr,
                                  style: theme.textTheme.titleMedium!
                                      .copyWith(color: appTheme.gray900))),
                          const Spacer(),
                          CustomImageView(
                              imagePath: ImageConstant.imgArrowRightGray900,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              margin: EdgeInsets.symmetric(vertical: 10.v))
                        ])),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Container(
                    padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 15.v),
                    decoration: AppDecoration.outlineGray300011,
                    child: Row(children: [
                      Container(
                          height: 44.adaptSize,
                          width: 44.adaptSize,
                          padding: EdgeInsets.all(10.h),
                          decoration: AppDecoration.fillGreen400.copyWith(
                              borderRadius: BorderRadiusStyle.circleBorder23),
                          child: CustomImageView(
                              imagePath: "assets/images/hour.svg",
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              alignment: Alignment.center)),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 15.h, top: 13.v, bottom: 10.v),
                          child: Text("lbl_support".tr,
                              style: theme.textTheme.titleMedium))
                    ])),
              ),
              GestureDetector(
                  onTap: () {
                    onTapPower();
                  },
                  child: Container(
                      padding: EdgeInsets.all(16.h),
                      decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                          borderRadius: BorderRadiusStyle.customBorderL20),
                      child: Row(children: [
                        CustomIconButton(
                            height: 44.adaptSize,
                            width: 44.adaptSize,
                            padding: EdgeInsets.all(6.h),
                            decoration:
                                IconButtonStyleHelper.fillPrimaryContainerTL22,
                            child: CustomImageView(
                              imagePath: "assets/images/Logout.svg",
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 15.h, top: 13.v, bottom: 10.v),
                            child: Text("lbl_log_out".tr,
                                style: theme.textTheme.titleMedium))
                      ])))
            ])));
  }

  onTapArrowLeft() {
    Get.back();
  }

  /// Navigates to the settingEditProfileScreen when the action is triggered.
  onTapEditProfile() {
    Get.toNamed(
      AppRoutes.editProfileSetting,
    );
  }

  /// Navigates to the settingsMyBookingUpcomingScreen when the action is triggered.
  onTapmybooking() {
    Get.toNamed(AppRoutes.mybook);
  }

  /// Navigates to the settingsVerifyAccountDefaultScreen when the action is triggered.
  onTapVerifiedUserTwo() {
    Get.toNamed(
      AppRoutes.bank,
    );
  }

  /// Navigates to the settingsNotificationsOneScreen when the action is triggered.
  onTapNotificationSettings() {
    // Get.toNamed(
    //   AppRoutes.settingsNotificationsOneScreen,
    // );
  }

  /// Navigates to the settingsNotificationsScreen when the action is triggered.
  onTapReferralProgram() {
    // Get.toNamed(
    //   AppRoutes.settingsNotificationsScreen,
    // );
  }

  /// Navigates to the settingAboutUsScreen when the action is triggered.
  onTapInfo() {
    // Get.toNamed(
    //   AppRoutes.settingAboutUsScreen,
    // );
  }

  /// Displays a dialog with the [SettingsLogOutDialog] content.
  onTapPower() {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.only(left: 0),
      content: SettingsLogOutDialog(
        Get.put(
          SettingsLogOutController(),
        ),
      ),
    ));
  }
}
