import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/edit_education/edit_education.dart';
import 'package:experta/presentation/education/controller/education_controller.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_image.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/shimmer.dart';
import 'package:experta/widgets/work_experience_widget.dart';
import 'package:flutter/material.dart';

class EducationList extends StatefulWidget {
  const EducationList({super.key});

  @override
  State<EducationList> createState() => _EducationListState();
}

class _EducationListState extends State<EducationList> {
  final EducationController educationController =
      Get.put(EducationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildAppBar(), _buildBody()],
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
      title: AppbarSubtitleSix(text: "Education Info"),
      actions: [
        AppbarTrailingImage(
          margin: const EdgeInsets.only(right: 20),
          imagePath: ImageConstant.plus,
          onTap: () {
            Get.to(() => const EditEducationPage());
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (educationController.isLoading.value) {
        return Expanded(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const ShimmerLoadingEffect(),
                  childCount: 10,
                ),
              ),
            ],
          ),
        );
      } else if (educationController.educationList.isEmpty) {
        return const Center(child: Text('No education data available.'));
      } else {
        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: educationController.educationList.length,
            itemBuilder: (context, index) {
              final education = educationController.educationList[index];
              return EducationWidget(
                education: education,
                edit: true,
                onEdit: () async {
                  Get.delete<EducationController>();
                  var result = await Get.toNamed(AppRoutes.editEducation,
                      arguments: education);

                  if (result == true) {
                    final educationController = Get.find<EducationController>();
                    educationController.fetchEducation();
                  }
                },
              );
            },
          ),
        );
      }
    });
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
