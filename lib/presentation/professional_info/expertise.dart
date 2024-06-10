import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/professional_info/controller/professional_controller.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_search_view.dart';
import 'package:flutter/material.dart';

class EditExpertise extends StatefulWidget {
  const EditExpertise({super.key});

  @override
  State<EditExpertise> createState() => _EditExpertiseState();
}

class _EditExpertiseState extends State<EditExpertise> {
  final TextEditingController _expertiseController = TextEditingController();
  final EditProfessionalInfoController controller =
      Get.put(EditProfessionalInfoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomSearchView(
                  controller: _expertiseController,
                  hintText: "Enter your expertise",
                ),
                const SizedBox(height: 20),
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
                    onPressed: () {},
                    child: Text(
                      '+ Add Expertise',
                      style: theme.textTheme.bodyMedium!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _expertiseController.text);
                  },
                  child: const Text('Save'),
                ),
              ],
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

  void onTapArrowLeft() {
    Get.back();
  }
}
