import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_outlined_button.dart';
// ignore: unnecessary_import
import 'package:get/get.dart';

class SecurityPrivacy extends StatefulWidget {
  const SecurityPrivacy({super.key});

  @override
  State<SecurityPrivacy> createState() => _SecurityPrivacyState();
}

class _SecurityPrivacyState extends State<SecurityPrivacy> {
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
                      color: appTheme.deepOrangeA20.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_buildAppBar(), _buildAccountSettings()],
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Security & Privacy"),
    );
  }

  Widget _buildAccountSettings() {
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
                borderRadius: BorderRadiusStyle.roundedBorder20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.block);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.h, vertical: 16.v),
                      decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderBL20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconButton(
                            height: 44.adaptSize,
                            width: 44.adaptSize,
                            padding: EdgeInsets.all(10.h),
                            decoration: IconButtonStyleHelper.fillPrimary,
                            child:
                                CustomImageView(imagePath: "assets/images/bookings/block.svg"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.h, top: 13.v, bottom: 10.v),
                            child: Text(
                              "Blocked",
                              style: theme.textTheme.titleMedium!
                                  .copyWith(color: appTheme.gray900),
                            ),
                          ),
                          const Spacer(),
                          CustomImageView(
                            imagePath: ImageConstant.imgArrowRightGray900,
                            height: 24.adaptSize,
                            width: 24.adaptSize,
                            margin: EdgeInsets.symmetric(vertical: 10.v),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDeleteAccountDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 16.v),
                        decoration:
                            AppDecoration.fillOnPrimaryContainer.copyWith(
                          borderRadius: BorderRadiusStyle.customBorderL20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              height: 44.adaptSize,
                              width: 44.adaptSize,
                              padding: EdgeInsets.all(10.h),
                              decoration: IconButtonStyleHelper
                                  .fillPrimaryContainerTL22,
                              child: CustomImageView(
                                  imagePath: ImageConstant.delete),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.h, top: 13.v, bottom: 10.v),
                              child: Text(
                                "Delete Account",
                                style: theme.textTheme.titleMedium!
                                    .copyWith(color: appTheme.gray900),
                              ),
                            ),
                            const Spacer(),
                            CustomImageView(
                              imagePath: ImageConstant.imgArrowRightGray900,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                              margin: EdgeInsets.symmetric(vertical: 10.v),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Add SVG image above the text
                CustomIconButton(
                    height: 88.adaptSize,
                    width: 88.adaptSize,
                    padding: EdgeInsets.all(20.h),
                    decoration: IconButtonStyleHelper.fillGreenTL245,
                    child: CustomImageView(
                      imagePath: ImageConstant.popup,
                    )),
                const SizedBox(height: 20.0),
                Text(
                  "Delete your account",
                  style: theme.textTheme.headlineSmall!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'You will lose all of your data by deleting your account. This action cannot be undone.',
                    style: CustomTextStyles.bodyMediumLight,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                    height: 24.0), // Increased padding between text and buttons
                CustomElevatedButton(
                  onPressed: () {
                    // Handle account deletion logic here
                  },
                  text: "Delete",
                ),
                const SizedBox(height: 12.0), // Padding between the buttons
                CustomOutlinedButton(
                  height: 56.v,
                  buttonStyle: CustomButtonStyles.outlineGrayTL23,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: "Cancel",
                ),
                const SizedBox(height: 16.0), // Padding after the buttons
              ],
            ),
          ),
        );
      },
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
