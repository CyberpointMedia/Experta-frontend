import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/edit_profile/edit_profile_controller/edit_profile_controller.dart';
import 'package:experta/widgets/custom_icon_button.dart';

class EditProfileSettings extends StatefulWidget {
  const EditProfileSettings({super.key});

  @override
  State<EditProfileSettings> createState() => _EditProfileSettingsState();
}

class _EditProfileSettingsState extends State<EditProfileSettings> {
  final EditSettingController controller = Get.find();

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
      title: AppbarSubtitleSix(text: "Edit Profile"),
    );
  }

  Widget _buildSettingsOptions() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
         padding: EdgeInsets.only(right: 16.h, left: 16, top: 7),
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
                    title: "Basic Info",
                    iconPath: ImageConstant.info,
                    iconDecoration: IconButtonStyleHelper.fillPrimary,
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderBL20),
                    completion: controller
                            .profileCompletion?.sectionCompletions.basicInfo ??
                        0,
                    onTap: () => Get.toNamed(AppRoutes.basicProfile),
                  ),
                  _buildSettingsOption(
                    title: "Professional Info",
                    iconPath: ImageConstant.brief,
                    iconDecoration: IconButtonStyleHelper.fillDeepPurple,
                    decoration: AppDecoration.fillOnPrimaryContainer,
                    completion: controller.profileCompletion?.sectionCompletions
                            .industryOccupation ??
                        0,
                    onTap: () => Get.toNamed(AppRoutes.professionalInfo),
                  ),
                  _buildSettingsOption(
                    title: "Additional Info",
                    iconPath: ImageConstant.vector,
                    iconDecoration: IconButtonStyleHelper.fillOrange,
                    decoration: AppDecoration.fillOnPrimaryContainer,
                    completion: controller
                            .profileCompletion?.sectionCompletions.interest ??
                        0,
                    onTap: () => Get.toNamed(AppRoutes.additional),
                  ),
                  _buildSettingsOption(
                    title: "Call Setting",
                    iconPath: ImageConstant.union,
                    iconDecoration: IconButtonStyleHelper.fillGreenTL24,
                    decoration: AppDecoration.fillOnPrimaryContainer.copyWith(
                        borderRadius: BorderRadiusStyle.customBorderL20),
                    completion: controller.profileCompletion?.sectionCompletions
                            .availability ??
                        0,
                    onTap: () => Get.toNamed(AppRoutes.callSettings),
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
    required int completion,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
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
              if (completion == 100)
                CustomImageView(
                  imagePath: ImageConstant.complete,
                  height: 20,
                  width: 20,
                ),
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
