import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditProfileSettings extends StatefulWidget {
  const EditProfileSettings({super.key});

  @override
  State<EditProfileSettings> createState() => _EditProfileSettingsState();
}

class _EditProfileSettingsState extends State<EditProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_buildAppBar(), _buildBasicSettings()],
          )
        ],
      ),
    );
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
        title: AppbarSubtitleSix(text: "Edit Profile"));
  }

  /// Section Widget
  Widget _buildBasicSettings() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: EdgeInsets.only(right: 16.h, left: 16, top: 50),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.v),
                  Container(
                      decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                          color: Colors.transparent,
                          borderRadius: BorderRadiusStyle.roundedBorder20),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.basicProfile);
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
                                                "assets/images/settings/Information.svg")),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.h,
                                            top: 13.v,
                                            bottom: 10.v),
                                        child: Text("Basic Info",
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
                            Get.toNamed(AppRoutes.professionalInfo);
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
                                                "assets/images/settings/Brief.svg",
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15.h,
                                              top: 13.v,
                                              bottom: 10.v),
                                          child: Text("Professional Info",
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
                                          imagePath:
                                              "assets/images/settings/Vector.svg",
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.h,
                                            top: 13.v,
                                            bottom: 10.v),
                                        child: Text("Additional Info",
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
                        Padding(
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
                                        padding: EdgeInsets.all(10.h),
                                        decoration:
                                            IconButtonStyleHelper.fillGreenTL24,
                                        child: CustomImageView(
                                          imagePath:
                                              "assets/images/settings/Union.svg",
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.h,
                                            top: 13.v,
                                            bottom: 10.v),
                                        child: Text("Call Setting",
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
                      ]))
                ])));
  }

  onTapArrowLeft() {
    Get.back();
  }
}
