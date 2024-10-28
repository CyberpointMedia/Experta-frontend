import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/edit_education/edit_education_controller.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class EditEducationPage extends StatefulWidget {
  const EditEducationPage({super.key});

  @override
  State<EditEducationPage> createState() => _EditEducationPageState();
}

class _EditEducationPageState extends State<EditEducationPage> {
  final EditEducationController controller = Get.put(EditEducationController());
  final Education? education = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                  tileMode: TileMode.decal, sigmaX: 60, sigmaY: 60),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildAppBar(), _buildBody()],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 40.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.cross,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          Get.back(result: true);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(
          text: education != null ? 'Edit Education' : 'Add Education'),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Degree',
                        style: CustomTextStyles.bodyLargeBlack90001),
                    const TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomTextFormField(
              controller: controller.degreeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a degree';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'School/College',
                        style: CustomTextStyles.bodyLargeBlack90001),
                    const TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomTextFormField(
              controller: controller.schoolCollegeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a school/college';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Start Date',
                        style: CustomTextStyles.bodyLargeBlack90001),
                    const TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomTextFormField(
              hintText: "yyyy-mm-dd",
              controller: controller.startDateController,
              suffixConstraints: const BoxConstraints(
                  maxHeight: 40, maxWidth: 40, minHeight: 30, minWidth: 30),
              suffix: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CustomImageView(
                  imagePath: ImageConstant.imgCalendarGray900,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      controller.startDateController.text =
                          controller.formatDate(picked);
                      controller.startDate.value = picked;
                      print('Picked Start Date: ${controller.startDate.value}');
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 5),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'End Date',
                        style: CustomTextStyles.bodyLargeBlack90001),
                    const TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomTextFormField(
              hintText: "yyyy-mm-dd",
              controller: controller.endDateController,
              suffixConstraints: const BoxConstraints(
                  maxHeight: 40, maxWidth: 40, minHeight: 30, minWidth: 30),
              suffix: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CustomImageView(
                  imagePath: ImageConstant.imgCalendarGray900,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      controller.endDateController.text =
                          controller.formatDate(picked);
                      controller.endDate.value = picked;
                      print('Picked End Date: ${controller.endDate.value}');
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 200),
            CustomElevatedButton(
              onPressed: () {
                if (education != null) {
                  controller.saveEducation(education!.id);
                } else {
                  controller.saveEducation(null);
                }
              },
              text: "Save",
            ),
          ],
        ),
      ),
    );
  }
}
