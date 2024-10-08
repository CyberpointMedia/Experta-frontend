import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/edit_work_experience/controller/edit_work_experience_controller.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';
import 'package:experta/widgets/custom_text_form_field.dart';

class EditWorkExperiencePage extends StatefulWidget {
  const EditWorkExperiencePage({super.key});

  @override
  State<EditWorkExperiencePage> createState() => _EditWorkExperiencePageState();
}

class _EditWorkExperiencePageState extends State<EditWorkExperiencePage> {
  final EditWorkExperienceController controller =
      Get.put(EditWorkExperienceController());
  final WorkExperience? workExperience = Get.arguments;

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
        onTap: () => Get.back(),
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(
          text: workExperience != null
              ? 'Edit Work Experience'
              : 'Add Work Experience'),
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
                        text: 'Job Title',
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
              controller: controller.jobTitleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a job title';
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
                        text: 'Company Name',
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
              controller: controller.companyNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a company name';
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
                    }
                  },
                ),
              ),
            ),
            Row(
              children: [
                Obx(() => Checkbox(
                      value: controller.isCurrentlyWorking.value,
                      onChanged: (bool? value) {
                        controller.isCurrentlyWorking.value = value!;
                      },
                    )),
                Text('I am currently working in this role',
                    style: CustomTextStyles.bodyLargeBlack90001),
              ],
            ),
            Obx(() {
              if (!controller.isCurrentlyWorking.value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      controller: controller.endDateController,
                      suffixConstraints: const BoxConstraints(
                          maxHeight: 40,
                          maxWidth: 40,
                          minHeight: 30,
                          minWidth: 30),
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
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
            const SizedBox(height: 200),
            CustomElevatedButton(
              onPressed: () {
                if (workExperience != null) {
                  controller.saveWorkExperience(workExperience!.id);
                } else {
                  controller.saveWorkExperience(null);
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
