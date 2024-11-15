import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/account_details_settings/controller/account_detail_controller.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/custom_toast_message.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DynamicSettingsPage extends StatefulWidget {
  const DynamicSettingsPage({super.key});

  @override
  State<DynamicSettingsPage> createState() => _DynamicSettingsPageState();
}

class _DynamicSettingsPageState extends State<DynamicSettingsPage> {
  final String settingType = Get.arguments['keyword'] as String;
  final controller = Get.put(AccountDetailsController());

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
                  padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
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
        imageFilter:
            ImageFilter.blur(tileMode: TileMode.decal, sigmaX: 60, sigmaY: 60),
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
      // case 'Gender':
      //   return _buildChangeGenderUI(context);
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
    return [
      _buildTitle("Change User Name"),
      _buildSubtitle("Enter your email or phone number to reset the password."),
      const SizedBox(
        height: 12,
      ),
      Text("User name"),
      const SizedBox(
        height: 6,
      ),
      CustomTextFormField(
        // hintText: "navi_verma88",
        hintStyle: CustomTextStyles.titleMediumBluegray300,
        textInputType: TextInputType.name,
        controller: controller.textField1,
        focusNode: controller.focus1,
      ),
      const Spacer(),
      _buildSaveButton(context, controller.textField1.text.isNotEmpty,
          "User Name changed Successfully", "Please Fill the user name"),
    ];
  }

  // List<Widget> _buildChangeGenderUI(BuildContext context) {
  //   RxBool isMaleSelected = false.obs;
  //   RxBool isFemaleSelected = false.obs;

  //   return [
  //     _buildTitle("Change Gender"),
  //     _buildSubtitle("This help us find your more relevant content. We won’t show it on your profile.max 2 line "),
  //     Center(
  //       child: Obx(() => Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           _buildGenderSelection(
  //             "Male",
  //             ImageConstant.male,
  //             ImageConstant.maleunselected,
  //             isMaleSelected.value,
  //             () {
  //               isMaleSelected.value = true;
  //               isFemaleSelected.value = false;
  //               controller.setGender("male");
  //             }
  //           ),
  //           const SizedBox(width: 16.0),
  //           _buildGenderSelection(
  //             "Female",
  //             ImageConstant.female,
  //             ImageConstant.femele,
  //             isFemaleSelected.value,
  //             () {
  //               isFemaleSelected.value = true;
  //               isMaleSelected.value = false;
  //               controller.setGender("female");
  //             }
  //           ),
  //         ],
  //       )),
  //     ),
  //     const Spacer(),
  //     _buildSaveButton(context, true, "Gender changed Successfully", ""),
  //   ];
  // }

  List<Widget> _buildChangeDateOfBirthUI(BuildContext context) {
    return [
      _buildTitle("Change Date of birth"),
      _buildSubtitle("Enter your email or phone number to reset the password."),
      const SizedBox(
        height: 12,
      ),
      const Text("Date of birth (DD/MM/YYYY)"),
      const SizedBox(
        height: 6,
      ),
      Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              // hintText: "01/01/2024",
              hintStyle: CustomTextStyles.titleMediumBluegray300,
              textInputType: TextInputType.datetime,
              controller: controller.textField2,
              focusNode: FocusNode(),
              suffix: CustomIconButton(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  height: 24.0, // Adjust the size as needed
                  width: 24.0,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgCalendar,
                    color: appTheme.blueGray300,
                    onTap: () => _selectDate(context),
                  )

                  // Adjust the size as needed
                  ),
            ),
          ),
        ],
      ),
      const Spacer(),
      _buildSaveButton(context, controller.textField5.text.isNotEmpty,
          "Phone Number changed Successfully", "Please Fill the phone number"),
    ];
  }

  List<Widget> _buildChangeEmailUI(BuildContext context) {
    return [
      _buildTitle("Change Email"),
      _buildSubtitle("Enter your email or phone number to reset the password."),
      const SizedBox(
        height: 12,
      ),
      // const Text("Current Email"),
      const SizedBox(
        height: 6,
      ),
      CustomTextFormField(
        // hintText: "john.doe@example.com",
        hintStyle: CustomTextStyles.titleMediumBluegray300,
        textInputType: TextInputType.emailAddress,
        controller: controller.textField3,
        focusNode: controller.focus3,
      ),
      const SizedBox(
        height: 12,
      ),
      const Text("New Email"),
      const SizedBox(
        height: 6,
      ),
      CustomTextFormField(
        // hintText: "john.doe@example.com",
        hintStyle: CustomTextStyles.titleMediumBluegray300,
        textInputType: TextInputType.emailAddress,
        controller: controller.textField4,
        focusNode: controller.focus4,
      ),
      const Spacer(),
      _buildSaveButton(
          context,
          controller.textField3.text.isNotEmpty ||
              controller.textField4.text.isNotEmpty,
          "Email changed Successfully",
          "Please Fill the email"),
    ];
  }

  List<Widget> _buildChangePhoneNumberUI(BuildContext context) {
    return [
      _buildTitle("Change Phone Number"),
      _buildSubtitle("Enter your phone number to update it."),
      const SizedBox(
        height: 12,
      ),
      const Text("Phone Number"),
      const SizedBox(
        height: 6,
      ),
      CustomTextFormField(
        // hintText: "+1 123 456 7890",
        hintStyle: CustomTextStyles.titleMediumBluegray300,
        textInputType: TextInputType.phone,
        controller: controller.textField5,
        focusNode: controller.focus5,
      ),
      // const Spacer(),
      // _buildSaveButton(context, controller.textField5.text.isNotEmpty, "Phone Number changed Successfully", "Please Fill the phone number"),
    ];
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: theme.textTheme.headlineSmall!
          .copyWith(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24.fSize),
    );
  }

  Widget _buildSubtitle(String text) {
    return Padding(
      padding:  EdgeInsets.only(top: 5.adaptSize, bottom: 15.adaptSize),
      child: Text(text, maxLines: 1, style: theme.textTheme.headlineSmall!
          .copyWith(color: appTheme.blueGray300, fontWeight: FontWeight.w400, fontSize: 14.fSize),),
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isValid,
      String successMessage, String errorMessage) {
    return CustomElevatedButton(
      text: "Save",
      onPressed: () async {
        if (isValid) {
          // Prepare data based on the current setting
          Map<String, dynamic> data;
          switch (settingType) {
            case 'Username':
              data = {'username': controller.textField1.text};
              break;
            case 'Gender':
              data = {'gender': controller.selectedGender.value};
              break;
            case 'Birthday':
              data = {'dateOfBirth': controller.textField2.text};
              break;
            case 'Change Email':
              data = {'email': controller.textField3.text};
              break;
            case 'Phone Number':
              data = {'phone': controller.textField5.text};
              break;
            default:
              data = {};
          }

          // Call the API to update account settings
          await controller.updateAccountSettings(data);

          // Show success toast
          // ignore: use_build_context_synchronously
          CustomToast().showToast(
              context: context, message: successMessage, isSuccess: true);
          Get.toNamed(AppRoutes.accountSetting);
        } else {
          CustomToast().showToast(
              context: context, message: errorMessage, isSuccess: false);
        }
      },
      margin: const EdgeInsets.all(10),
    );
  }

  Widget _buildGenderSelection(String label, String selectedIcon,
      String unselectedIcon, bool isSelected, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        children: [
          SvgPicture.asset(
            isSelected ? selectedIcon : unselectedIcon,
            height: 120,
          ),
          Text(
            label,
            style: theme.textTheme.titleMedium!.copyWith(
              color: isSelected ? appTheme.yellow6001e : appTheme.blueGray100,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        controller.textField2.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      height: 65,
      leadingWidth: 45,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      // title: Text(
      //   settingType,
      //   style: theme.textTheme.titleLarge!.copyWith(color: Colors.black),
      // ),
    );
  }
}
