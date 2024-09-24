import 'package:experta/core/app_export.dart';
import 'controller/settings_log_out_controller.dart';

// ignore_for_file: must_be_immutable
class SettingsLogOutDialog extends StatelessWidget {
  SettingsLogOutDialog(this.controller, {super.key});

  SettingsLogOutController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 270.h,
        decoration: AppDecoration.fillOnPrimaryContainer
            .copyWith(borderRadius: BorderRadiusStyle.roundedBorder15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: 18.v),
          Text("lbl_logout2".tr, style: CustomTextStyles.titleMediumSFProText),
          SizedBox(height: 10.v),
          SizedBox(
              width: 185.h,
              child: Text("msg_the_less_text_people".tr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.bodySmallSFProTextGray900
                      .copyWith(height: 1.67))),
          SizedBox(height: 21.v),
          Divider(color: appTheme.gray300),
          Container(
              decoration: AppDecoration.fillGray300,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CustomElevatedButton(
                    height: 40.v,
                    width: 134.h,
                    text: "lbl_cancel".tr,
                    buttonStyle: CustomButtonStyles.fillOnPrimaryContainer1,
                    buttonTextStyle:
                        CustomTextStyles.bodyLargeSFProTextLightblueA700,
                    onPressed: () {
                      onTapCancel();
                    }),
                CustomElevatedButton(
                    height: 40.v,
                    width: 134.h,
                    text: "lbl_logout2".tr,
                    buttonStyle: CustomButtonStyles.fillOnPrimaryContainer1,
                    buttonTextStyle:
                        CustomTextStyles.bodyLargeSFProTextLightblueA700,
                    onPressed: () {
                      onTapLogout();
                    })
              ]))
        ]));
  }

  /// Navigates to the settingScreen when the action is triggered.
  onTapCancel() {
    Get.toNamed(
      AppRoutes.settingScreen,
    );
  }

  /// Navigates to the onboardingScreen when the action is triggered.
  onTapLogout() async {
    // Clear all data from SharedPreferences
    await PrefUtils().clearPreferencesData();

    // Navigate to the onboarding screen
    Get.offAllNamed(AppRoutes.onboardingScreen);
  }
}
