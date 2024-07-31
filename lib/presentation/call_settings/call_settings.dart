import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_icon_button.dart';

class CallSettings extends StatefulWidget {
  const CallSettings({super.key});

  @override
  State<CallSettings> createState() => _CallSettingsState();
}

class _CallSettingsState extends State<CallSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAppBar(),
              _buildSettingsOptions(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundBlur() {
    return Positioned(
      left: 270,
      top: 50,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
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
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: onTapArrowLeft,
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Call Controls"),
    );
  }

  Widget _buildSettingsOptions() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 50),
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
                  _buildSettingsOption(
                    title: "Set Availability",
                    iconPath: ImageConstant.avail,
                    iconDecoration: IconButtonStyleHelper.fillPrimary,
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderBL20),
                    onTap: () => Get.offAndToNamed(AppRoutes.setAvailability),
                  ),
                  _buildSettingsOption(
                    title: "Set Pricing",
                    iconPath: ImageConstant.price,
                    iconDecoration: IconButtonStyleHelper.fillGreenTL24,
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderL20),
                    onTap: () => Get.offAndToNamed(AppRoutes.setPricing),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required String title,
    required String iconPath,
    required BoxDecoration iconDecoration,
    required Decoration decoration,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 16.v),
          decoration: decoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconButton(
                height: 44.adaptSize,
                width: 44.adaptSize,
                padding: EdgeInsets.all(6.h),
                decoration: iconDecoration,
                child: CustomImageView(imagePath: iconPath),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.h, top: 13.v, bottom: 10.v),
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: appTheme.gray900,
                  ),
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
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
