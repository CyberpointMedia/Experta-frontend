import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/professional_info/controller/professional_controller.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_drop_down.dart';
import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:experta/widgets/custom_radio_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:experta/widgets/shimmer.dart';
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
          _buildBackground(),
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

  Widget _buildBackground() {
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
          _buildDropdown(),
          _buildRadioButtonSection(),
          const Divider(),
          _buildExpertiseSection(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(),
          ),
          _buildEditWorkExperience(),
          _buildEducation(),
          _buildAchievements(),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CustomElevatedButton(
              text: "Save",
              onPressed: controller.saveProfessionalInfo,
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

  Widget _buildDropdown() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingDropdown();
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownField(
              "Choose Industry *",
              controller.industryDropdownItems,
              controller.selectedIndustry,
              (String industryId) {
                controller.onIndustryChanged(industryId);
              },
            ),
            _buildDropdownField(
              "Choose Occupation *",
              controller.occupationDropdownItems,
              controller.selectedOccupation,
              null,
            ),
          ],
        );
      }
    });
  }

  Widget _buildDropdownField(String label, List<SelectionPopupModel> items,
      Rx<SelectionPopupModel?> selectedValue, Function(String)? onChanged) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              label,
              style: CustomTextStyles.bodyMediumBlack90001,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.v, bottom: 12.v),
            child: CustomDropDown(
              hintText: "Select",
              width: double.infinity,
              icon: _buildDropdownIcon(),
              items: items,
              onChanged: (SelectionPopupModel? newValue) {
                if (newValue != null) {
                  selectedValue.value = newValue;
                  if (onChanged != null) {
                    onChanged(newValue.id.toString());
                  }
                }
              },
              value: selectedValue.value,
              validator: (value) =>
                  value == null ? 'Please select an option' : null,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildLoadingDropdown() {
    return Padding(
      padding: EdgeInsets.only(top: 6.v, bottom: 12.v),
      child: CustomDropDown(
        width: double.infinity,
        icon: _buildDropdownIcon(),
        hintText: "Choose",
        alignment: Alignment.center,
      ),
    );
  }

  Widget _buildDropdownIcon() {
    return Container(
      margin: EdgeInsets.only(right: 6.h),
      child: CustomImageView(
        imagePath: ImageConstant.imgCheckmark,
        height: 30.adaptSize,
        width: 30.adaptSize,
      ),
    );
  }

  Widget _buildRadioButtonSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildRadioButton("Registration Number", 'regNumber'),
              _buildRadioButton("Upload Certificate", 'uploadCert'),
            ],
          ),
          if (controller.selectedOption.value == 'regNumber')
            _buildRegistrationNumberField(),
          if (controller.selectedOption.value == 'uploadCert')
            _buildUploadCertificateField(),
        ],
      ),
    );
  }

  Widget _buildRadioButton(String text, String value) {
    return Expanded(
      child: CustomRadioButton(
        value: value,
        groupValue: controller.selectedOption.value,
        onChange: (value) {
          setState(() {
            controller.selectedOption.value = value;
          });
        },
        text: text,
      ),
    );
  }

  Widget _buildRegistrationNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: CustomTextFormField(
        controller: controller.regNumberController,
        autofocus: false,
        width: MediaQuery.of(context).size.width,
        hintText: "Enter your registration number".tr,
        hintStyle: CustomTextStyles.titleMediumBluegray300,
        textInputType: TextInputType.name,
      ),
    );
  }

  Widget _buildUploadCertificateField() {
    return Padding(
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
                    CustomImageView(imagePath: ImageConstant.uploadcloud),
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
        _buildSectionHeader("Your Expertise", controller.editExpertise),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: ShimmerLoadingEffect());
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
            onPressed: () => controller.editExpertise(context),
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

  Widget _buildSectionHeader(String title, Function(BuildContext) onEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: CustomTextStyles.labelMediumBlack900,
          textAlign: TextAlign.start,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: TextButton(
            onPressed: () => onEdit(context),
            child: Text(
              "Edit",
              style: theme.textTheme.bodyLarge!.copyWith(color: Colors.red),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditWorkExperience() {
    return Column(
      children: [
        _buildSectionHeader(
            "Work Experience", (context) => Get.toNamed(AppRoutes.experience)),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: ShimmerLoadingEffect());
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
                onPressed: () => Get.toNamed(AppRoutes.education),
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
            return const Center(child: ShimmerLoadingEffect());
          } else if (controller.educationList.isEmpty) {
            return const Center(child: Text('No education data available'));
          } else {
            return ListView.builder(
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
            );
          }
        }),
      ],
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...controller.linkControllers.asMap().entries.map((entry) {
          final index = entry.key;
          final textController = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Link ${index + 1}'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: textController,
                        hintText: "Enter Url",
                        hintStyle: CustomTextStyles.titleMediumBluegray300,
                        textInputType: TextInputType.url,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a URL';
                          } else if (!controller.isValidUrl(value)) {
                            return 'Please enter a valid URL';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          textController.clear();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        CustomElevatedButton(
          onPressed: controller.addNewLinkField,
          text: '+ Add more links',
          buttonStyle: CustomButtonStyles.fillWhite,
        ),
      ],
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
