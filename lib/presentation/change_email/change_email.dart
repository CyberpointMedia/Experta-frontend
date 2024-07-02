import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/change_email/controller/change_email_controller.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/custom_toast_message.dart';
import 'package:flutter/material.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  // Define separate controllers for current and new email
  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();

  final FocusNode currentEmailFocusNode = FocusNode();
  final FocusNode newEmailFocusNode = FocusNode();

  ChangeEmailController controller = Get.put(ChangeEmailController());

  @override
  void dispose() {
    // Dispose controllers and focus nodes when the widget is disposed
    currentEmailController.dispose();
    newEmailController.dispose();
    currentEmailFocusNode.dispose();
    newEmailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
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
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Change email",
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 15),
                    child: Text(
                      "Enter your email or phone number to reset the password.",
                      maxLines: 1,
                    ),
                  ),
                  const Text("Current Email"),
                  CustomTextFormField(
                    hintText: "current123@email",
                    hintStyle: CustomTextStyles.titleMediumBluegray300,
                    textInputType: TextInputType.emailAddress,
                    controller: currentEmailController,
                    focusNode: currentEmailFocusNode,
                    autofocus: false,
                  ),
                  const SizedBox(height: 10), // Add spacing between fields
                  const Text("New Email"),
                  CustomTextFormField(
                    hintText: "new123@email",
                    hintStyle: CustomTextStyles.titleMediumBluegray300,
                    textInputType: TextInputType.emailAddress,
                    controller: newEmailController,
                    focusNode: newEmailFocusNode,
                    autofocus: false,
                  ),
                  const Spacer(),
                  CustomElevatedButton(
                    text: "Save",
                    onPressed: () {
                      if (currentEmailController.text.isNotEmpty && newEmailController.text.isNotEmpty) {
                        CustomToast().showToast(
                          context: context,
                          message: "Email changed successfully",
                          isSuccess: true,
                        );
                        Get.toNamed(AppRoutes.accountSetting);
                      } else {
                        CustomToast().showToast(
                          context: context,
                          message: "Please fill in both email fields",
                          isSuccess: false,
                        );
                      }
                    },
                    margin: const EdgeInsets.all(10),
                  ),
                ],
              ),
            ),
          ],
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
        onTap: () {
          onTapArrowLeft();
        },
      ),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
