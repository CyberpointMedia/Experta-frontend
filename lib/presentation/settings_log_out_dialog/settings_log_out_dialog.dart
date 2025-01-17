import 'package:experta/core/app_export.dart';
import 'controller/settings_log_out_controller.dart';
// Import for SystemNavigator

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 18.v),
          Text("lbl_logout2".tr,
          style:theme.textTheme.bodySmall!.copyWith(
        color: Colors.black,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w400,
        // height: 1.67,
      )
            ),
          SizedBox(height: 10.v),
          SizedBox(
            width: 185.h,
            child: Text(
              "msg_the_less_text_people".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style:theme.textTheme.bodySmall!.copyWith(
        color: Colors.black,
        fontSize: 12.fSize,
        fontWeight: FontWeight.w300,
        height: 1.67,
      )
            ),
          ),
          SizedBox(height: 21.v),
          Divider(color: appTheme.gray300),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomElevatedButton(
                height: 40.v,
                width: 134.h,
                text: "lbl_cancel".tr,
                buttonStyle: CustomButtonStyles.fillOnPrimaryContainer1, // Use the updated style
                buttonTextStyle: theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.lightBlueA700,
        fontSize: 17.fSize,
        fontWeight: FontWeight.w500
      ),
                onPressed: () {
                  onTapCancel();
                },
              ),
              Container(
                width: 1, // Set the width of the divider
                height: 40.v, // Match the height of the buttons
                color: appTheme.gray300, // Set the color to grey
              ),
              CustomElevatedButton(
                height: 40.v,
                width: 134.h,
                text: "lbl_logout2".tr,
                buttonStyle: CustomButtonStyles.fillOnPrimaryContainer1, // Use the updated style
                buttonTextStyle: theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.lightBlueA700,
        fontSize: 17.fSize,
        fontWeight: FontWeight.w500
      ),
                onPressed: () {
                  onTapLogout(); // Pass context to the method
                },
              ),
            ],
          ),
        ],
      ),
    );
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
    Get.offAllNamed(AppRoutes.signinPage);
  }
}
