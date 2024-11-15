import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/account_details_settings/account_details.dart';
import 'package:experta/widgets/custom_icon_button.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  void navigateToSettingsDetail(String keyword) {
    Get.to(() => const DynamicSettingsPage(), arguments: {'keyword': keyword});
  }

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
        margin: EdgeInsets.only(
          left: 16.h,
        ),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Account Settings"),
    );
  }

  Widget _buildAccountSettings() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
            right: 16.h, left: 16, top: 7), // Adjusted top padding to 7
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
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                  onTap: () {
                    navigateToSettingsDetail('Username');
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.h, vertical: 16.v),
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderBL20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconButton(
                          height: 44.adaptSize,
                          width: 44.adaptSize,
                          padding: EdgeInsets.all(6.h),
                          decoration: IconButtonStyleHelper.fillPrimary,
                          child: CustomImageView(imagePath: ImageConstant.user),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 15.h, top: 13.v, bottom: 10.v),
                          child: Text(
                            "Username",
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
                    navigateToSettingsDetail('Birthday');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
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
                            padding: EdgeInsets.all(6.h),
                            decoration: IconButtonStyleHelper.fillDeepPurple,
                            child: CustomImageView(
                                imagePath: ImageConstant.birthday),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.h, top: 13.v, bottom: 10.v),
                            child: Text(
                              "Birthday",
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
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.changegender); // Navigate to raise ticket
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
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
                            padding: EdgeInsets.all(6.h),
                            decoration: IconButtonStyleHelper.fillGreenTL24,
                            child: CustomImageView(
                                imagePath: ImageConstant.gender),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.h, top: 13.v, bottom: 10.v),
                            child: Text(
                              "Gender",
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
                GestureDetector(
                  onTap: () {
                    navigateToSettingsDetail('Change Email');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
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
                            decoration: IconButtonStyleHelper.fillOrange,
                            child:
                                CustomImageView(imagePath: ImageConstant.email),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.h, top: 13.v, bottom: 10.v),
                            child: Text(
                              "Change Email",
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
                GestureDetector(
                  onTap: () {
                    navigateToSettingsDetail('Phone Number');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.h, vertical: 16.v),
                      decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderL20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconButton(
                            height: 44.adaptSize,
                            width: 44.adaptSize,
                            padding: EdgeInsets.all(10.h),
                            decoration: IconButtonStyleHelper.fillGrayTL22,
                            child:
                                CustomImageView(imagePath: ImageConstant.phone),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 15.h, top: 13.v, bottom: 10.v),
                            child: Text(
                              "Phone Number",
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
              ]),
            ),
          ],
        ),
      ),
    );
  }

  onTapArrowLeft() {
    Get.back();
  }
}
