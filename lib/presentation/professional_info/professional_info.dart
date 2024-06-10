import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/professional_info/controller/professional_controller.dart';
import 'package:experta/presentation/professional_info/expertise.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_drop_down.dart';
import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:experta/widgets/custom_radio_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/work_experience_widget.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class EditProfessionalInfo extends StatefulWidget {
  const EditProfessionalInfo({super.key});

  @override
  State<EditProfessionalInfo> createState() => _EditProfessionalInfoState();
}

class _EditProfessionalInfoState extends State<EditProfessionalInfo> {
  final EditProfessionalInfoController controller =
      Get.put(EditProfessionalInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
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
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildAppBar(), _buildBody()],
            ),
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
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: EdgeInsets.only(left: 16.h),
        onTap: onTapArrowLeft,
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Professional Info"),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.v),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Your Profession"),
          _buildDropdown("Choose Industry *"),
          _buildDropdown("Choose Occupation *"),
          _buildRadioButtonSection(),
          const Divider(),
          _buildExpertiseSection(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(),
          ),
          _buildEditWorkExperience(),
          _buildEducation(),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CustomElevatedButton(
              text: "Save",
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        title,
        style: CustomTextStyles.labelMediumBlack900,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildDropdown(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: CustomTextStyles.bodyMediumBlack90001,
          textAlign: TextAlign.start,
        ),
        Padding(
          padding: EdgeInsets.only(top: 6.v, bottom: 12.v),
          child: CustomDropDown(
            width: double.infinity,
            icon: Container(
              margin: EdgeInsets.only(right: 6.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgCheckmark,
                height: 30.adaptSize,
                width: 30.adaptSize,
              ),
            ),
            hintText: "Choose",
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }

  Widget _buildRadioButtonSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomRadioButton(
                  value: 'regNumber',
                  groupValue: controller.selectedOption.value,
                  onChange: (value) {
                    setState(() {
                      controller.selectedOption.value = value;
                    });
                  },
                  text: 'Registration Number',
                ),
              ),
              Expanded(
                child: CustomRadioButton(
                  value: 'uploadCert',
                  groupValue: controller.selectedOption.value,
                  onChange: (value) {
                    setState(() {
                      controller.selectedOption.value = value;
                    });
                  },
                  text: 'Upload Certificate',
                ),
              ),
            ],
          ),
          if (controller.selectedOption.value == 'regNumber')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CustomTextFormField(
                controller: controller.regNumberController,
                autofocus: false,
                width: MediaQuery.of(context).size.width,
                hintText: "Enter your registration number".tr,
                hintStyle: CustomTextStyles.titleMediumBluegray300,
                textInputType: TextInputType.name,
              ),
            ),
          if (controller.selectedOption.value == 'uploadCert')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImageView(
                                imagePath: ImageConstant.uploadcloud),
                            const SizedBox(height: 8),
                            const Text('(JPEG, PNG, PDF)',
                                style: TextStyle(color: Colors.grey)),
                            Text(
                              'click to browse files',
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(color: Colors.black),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (controller.pickedFile != null) _buildFileUploadProgress(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        controller.pickedFile = result.files.first;
        controller.uploadProgress = 0.0.obs;
      });

      // Simulate file upload
      for (double i = 0; i <= 1; i += 0.1) {
        await Future.delayed(const Duration(milliseconds: 400));
        setState(() {
          controller.uploadProgress.value = i;
        });
      }
    }
  }

  Widget _buildFileUploadProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(child: Text(controller.pickedFile!.name)),
              Text(
                  '${(controller.pickedFile!.size / 1024).toStringAsFixed(2)} KB'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: controller.uploadProgress.value,
            color: appTheme.green400,
          ),
          const SizedBox(height: 8),
          Text(
              '${(controller.uploadProgress.value * 100).toStringAsFixed(0)}% uploaded'),
        ],
      ),
    );
  }

  Widget _buildExpertiseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Your Expertise",
              style: CustomTextStyles.labelMediumBlack900,
              textAlign: TextAlign.start,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: _editExpertise,
                child: Text(
                  "Edit",
                  style: theme.textTheme.bodyLarge!.copyWith(color: Colors.red),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: controller.expertiseList.map((expertise) {
                return Chip(
                  label: Text(
                    expertise.name,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                );
              }).toList(),
            );
          }
        }),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          width: 150,
          child: ElevatedButton(
            onPressed: _editExpertise,
            child: Text(
              '+ Add Expertise',
              style: theme.textTheme.bodyMedium!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _editExpertise() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditExpertise()),
    );

    if (result != null && result is String) {
      setState(() {
        // expertiseList.add(result);
      });
    }
  }

  Widget _buildEditWorkExperience() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Work Experience",
              style: CustomTextStyles.labelMediumBlack900,
              textAlign: TextAlign.start,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: _editExpertise,
                child: Text(
                  "Edit",
                  style: theme.textTheme.bodyLarge!.copyWith(color: Colors.red),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.workExperienceList.isEmpty) {
            return const Center(child: Text('No work experience available'));
          } else {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.workExperienceList.length,
              itemBuilder: (context, index) {
                final workExperience = controller.workExperienceList[index];
                return WorkExperienceWidget(workExperience: workExperience);
              },
            );
          }
        }),
      ],
    );
  }

  Widget _buildEducation() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Education",
              style: CustomTextStyles.labelMediumBlack900,
              textAlign: TextAlign.start,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: _editExpertise,
                child: Text(
                  "Edit",
                  style: theme.textTheme.bodyLarge!.copyWith(color: Colors.red),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.educationList.isEmpty) {
            return const Center(child: Text('No education data available'));
          } else {
            return SizedBox(
              // height: 400.0,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.educationList.length,
                itemBuilder: (context, index) {
                  final education = controller.educationList[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        education.degree,
                        style: CustomTextStyles.titleMediumSFProTextBlack90001,
                      ),
                      const SizedBox(height: 1.0),
                      Text(
                        education.schoolCollege,
                        style: theme.textTheme.bodyLarge!
                            .copyWith(color: Colors.black),
                      ),
                      const SizedBox(height: 1.0),
                      Text(
                        '${education.startDate.year} - ${education.endDate.year}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      const SizedBox(height: 5),
                    ],
                  );
                },
              ),
            );
          }
        }),
      ],
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
