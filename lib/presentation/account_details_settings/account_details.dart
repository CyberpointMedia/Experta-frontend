import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/account_details_settings/controller/account_detail_controller.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/custom_toast_message.dart';

class DynamicSettingsPage extends StatefulWidget {
  const DynamicSettingsPage({super.key});

  @override
  State<DynamicSettingsPage> createState() => _DynamicSettingsPageState();
}

class _DynamicSettingsPageState extends State<DynamicSettingsPage> {
  late final Map<String, dynamic> arguments;
  late final String keyword;
  late final Map<String, dynamic> userData;
  final controller = Get.put(AccountDetailsController());

  @override
  void initState() {
    super.initState();
    arguments = Get.arguments as Map<String, dynamic>;
    keyword = arguments['keyword'] as String;
    userData = arguments['userData'] as Map<String, dynamic>;
    controller.textField1.text = userData['username']?.toString().trim() ?? '';
    controller.textField3.text = userData['email']?.toString().trim() ?? '';
  }

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
    switch (keyword) {
      case 'Username':
        return _buildChangeUserNameUI(context);
      case 'Email':
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
      const Text("User name"),
      const SizedBox(
        height: 6,
      ),
      CustomTextFormField(
        controller: controller.textField1,
        hintStyle: CustomTextStyles.titleMediumBluegray300,
        textInputType: TextInputType.name,
        focusNode: controller.focus1, inputFormatters: [],
      ),
      const Spacer(),
      _buildSaveButton(context, controller.textField1.text.isNotEmpty,
          "User Name changed Successfully", "Please Fill the user name"),
    ];
  }

  List<Widget> _buildChangeEmailUI(BuildContext context) {
    return [
      _buildTitle("Change Email"),
      _buildSubtitle("Enter your email or phone number to reset the password."),
      const SizedBox(
        height: 12,
      ),
      const SizedBox(
        height: 6,
      ),
      CustomTextFormField(
        controller: controller.textField3,
        hintStyle: CustomTextStyles.titleMediumBluegray300,
        textInputType: TextInputType.emailAddress,
        focusNode: controller.focus3, inputFormatters: [],
      ),
      const Spacer(),
      _buildSaveButton(
          context,
          controller.textField3.text.isNotEmpty ||
              controller.textField4.text.isNotEmpty,
          "otp sent to your requested email",
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
        initialValue: userData['phoneNo'] ?? '',
        hintStyle: CustomTextStyles.titleMediumBluegray300,
        textInputType: TextInputType.phone,
        focusNode: controller.focus5,
        readOnly: true, inputFormatters: [],
      ),
    ];
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: theme.textTheme.headlineSmall!.copyWith(
          color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24.fSize),
    );
  }

  Widget _buildSubtitle(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 5.adaptSize, bottom: 15.adaptSize),
      child: Text(
        text,
        maxLines: 1,
        style: theme.textTheme.headlineSmall!.copyWith(
            color: appTheme.blueGray300,
            fontWeight: FontWeight.w400,
            fontSize: 14.fSize),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isValid,
      String successMessage, String errorMessage) {
    return CustomElevatedButton(
      text: "Save",
      onPressed: () async {
        String? validationError;

        switch (keyword) {
          case 'Username':
            if (controller.textField1.text.trim().isEmpty) {
              validationError = "Username cannot be empty";
            }
            break;
          case 'Email':
            if (controller.textField3.text.trim().isEmpty) {
              validationError = "Email cannot be empty";
            } else if (!isValidEmail(controller.textField3.text.trim())) {
              validationError = "Please enter a valid email address";
            }
            break;
        }

        if (validationError != null) {
          CustomToast().showToast(
            context: context,
            message: validationError,
            isSuccess: false,
          );
          return;
        }

        try {
          switch (keyword) {
            case 'Username':
              await controller.changeUsername(
                  controller.textField1.text.trim(), context);
              CustomToast().showToast(
                  context: context, message: successMessage, isSuccess: true);
              Get.toNamed(AppRoutes.accountSetting);
              break;

            case 'Email':
              await controller.initiateEmailChange(
                  controller.textField3.text.trim(), context);
              break;
          }
        } catch (e) {
          CustomToast().showToast(
              context: context,
              message: "An error occurred. Please try again.",
              isSuccess: false);
        }
      },
      margin: const EdgeInsets.all(10),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      centerTitle: true,
      height: 65,
      leadingWidth: 45,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      title: AppbarSubtitleSix(text: keyword),
    );
  }
}