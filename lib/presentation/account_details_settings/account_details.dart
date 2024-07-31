import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/change_date_of_birth/controller/change_date_of_birth_controller.dart';
import 'package:experta/presentation/change_email/controller/change_email_controller.dart';
import 'package:experta/presentation/change_gender/controller/change_gender_controller.dart';
import 'package:experta/presentation/change_user_name/controller/change_user_name_controller.dart';
import 'package:experta/presentation/phone_number/controller/phone_number_controller.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/custom_toast_message.dart';

class DynamicSettingsPage extends StatelessWidget {
  final String settingType = Get.arguments['keyword'] as String;

  DynamicSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildSettingUI(context),
                  ),
                ),
              ),
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

  List<Widget> _buildSettingUI(BuildContext context) {
    switch (settingType) {
      case 'Username':
        return _buildChangeUserNameUI(context);
      case 'Gender':
        return _buildChangeGenderUI(context);
      case 'Birthday':
        return _buildChangeDateOfBirthUI(context);
      case 'Change Email':
        return _buildChangeEmailUI(context);
      case 'Phone Number':
        return _buildChangePhoneNumberUI(context);
      default:
        return [];
    }
  }

  List<Widget> _buildChangeUserNameUI(BuildContext context) {
    final controller = Get.put(ChangeUserNameController());
    return [
      _buildTitle("Change User Name"),
      _buildSubtitle("Enter your user name."),
      const Text("User name"),
      CustomTextFormField(
        hintText: "navi_verma88",
        hintStyle: CustomTextStyles.titleMediumBluegray300,
        textInputType: TextInputType.name,
        controller: controller.textField1,
      ),
      const Spacer(),
      _buildSaveButton(context, controller.textField1.text.isNotEmpty, "User Name changed Successfully", "Please Fill the user name"),
    ];
  }

  List<Widget> _buildChangeGenderUI(BuildContext context) {
    // Initialize the controller if not already present
    final controller = Get.find<ChangeGenderController>();

    return [
      _buildTitle("Change Gender"),
      _buildSubtitle("This helps us find more relevant content. We won’t show it on your profile."),
      Center(
        child: Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGenderSelection(
                "Male",
                ImageConstant.male,
                ImageConstant.maleunselected,
                controller.selectedGender.value == "Male",
                () {
                  controller.selectedGender("Male");
                },
              ),
              const SizedBox(width: 16.0),
              _buildGenderSelection(
                "Female",
                ImageConstant.female,
                ImageConstant.femele,
                controller.selectedGender.value == "Female",
                () {
                  controller.selectedGender("Female");
                },
              ),
            ],
          );
        }),
      ),
      const Spacer(),
      _buildSaveButton(context, true, "Gender changed Successfully", ""),
    ];
  }

  List<Widget> _buildChangeDateOfBirthUI(BuildContext context) {
    final controller = Get.put(ChangeDateOfBirthController());

    return [
      _buildTitle("Change Date of Birth"),
      _buildSubtitle("Enter your date of birth."),
      const Text("Date of birth (DD/MM/YYYY)"),
      Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              hintText: "01/01/2024",
              hintStyle: CustomTextStyles.titleMediumBluegray300,
              textInputType: TextInputType.datetime,
              controller: controller.textField1,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context, controller),
          ),
        ],
      ),
      const Spacer(),
      _buildSaveButton(context, controller.textField1.text.isNotEmpty, "Date of Birth changed Successfully", "Please Fill the Date of Birth"),
    ];
  }

  List<Widget> _buildChangeEmailUI(BuildContext context) {
    final controller = Get.put(ChangeEmailController());
    return [
      _buildTitle("Change Email"),
      _buildSubtitle("Enter your new email address."),
      const Text("Email"),
      CustomTextFormField(
        hintText: "john.doe@example.com",
        hintStyle: CustomTextStyles.titleMediumBluegray300,
        textInputType: TextInputType.emailAddress,
        controller: controller.textField1,
      ),
      const Spacer(),
      _buildSaveButton(context, controller.textField1.text.isNotEmpty, "Email changed Successfully", "Please Fill the email"),
    ];
  }

  List<Widget> _buildChangePhoneNumberUI(BuildContext context) {
    final controller = Get.put(PhoneNumberController());
    return [
      _buildTitle("Change Phone Number"),
      _buildSubtitle("Enter your phone number."),
      const Text("Phone Number"),
      CustomTextFormField(
        hintText: "+1 123 456 7890",
        hintStyle: CustomTextStyles.titleMediumBluegray300,
        textInputType: TextInputType.phone,
        controller: controller.textField1,
      ),
      const Spacer(),
      _buildSaveButton(context, controller.textField1.text.isNotEmpty, "Phone Number changed Successfully", "Please Fill the phone number"),
    ];
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: theme.textTheme.headlineSmall!.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 15),
      child: Text(text, maxLines: 1),
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isValid, String successMessage, String errorMessage) {
    return CustomElevatedButton(
      text: "Save",
      onPressed: () {
        if (isValid) {
          CustomToast().showToast(context: context, message: successMessage, isSuccess: true);
          Get.toNamed(AppRoutes.accountSetting);
        } else {
          CustomToast().showToast(context: context, message: errorMessage, isSuccess: false);
        }
      },
      margin: const EdgeInsets.all(10),
    );
  }

  Widget _buildGenderSelection(
    String label,
    String selectedImagePath,
    String unselectedImagePath,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 144.0,
        height: 144.0,
        padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            CustomImageView(
              imagePath: isSelected ? selectedImagePath : unselectedImagePath,
              width: 50.0,
              height: 50.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(color: Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, ChangeDateOfBirthController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.textField1.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () => Get.back(),
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(
        text: settingType,
      ),
    );
  }
}
