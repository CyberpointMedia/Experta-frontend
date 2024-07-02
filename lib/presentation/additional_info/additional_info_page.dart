import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/additional_info/controller/additional_controller.dart';
import 'package:experta/presentation/additional_info/edit_languages.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AdditionalInfoPage extends StatefulWidget {
  const AdditionalInfoPage({super.key});

  @override
  State<AdditionalInfoPage> createState() => _AdditionalInfoPageState();
}

class _AdditionalInfoPageState extends State<AdditionalInfoPage> {
  final AdditionalInfoController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildAppBar()),
              SliverToBoxAdapter(child: _buildInterestChips()),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Divider(),
                ),
              ),
              SliverToBoxAdapter(child: _buildLanguageChips()),
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
                color: appTheme.deepOrangeA20,
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
      title: AppbarSubtitleSix(text: "Additional Info"),
    );
  }

  Widget _buildLanguageChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Languages I know", onEdit: () {
          final languages = controller.languageData.value.data?.languages ?? [];
          Get.to(() => EditLanguagePage(initialSelectedLanguages: languages));
          Get.delete<AdditionalInfoController>();
        }),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerEffect();
          }

          final languages = controller.languageData.value.data?.languages ?? [];

          if (languages.isEmpty) {
            return const Center(child: Text('No languages available'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: languages.map((language) {
                return Chip(
                  label: Text(
                    language.name,
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
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInterestChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Your Interests", onEdit: () {
          final interests = controller.interestData.value.interests;
          Get.toNamed(AppRoutes.editInterest, arguments: interests);
          Get.delete<AdditionalInfoController>();
        }),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerEffect();
          }

          final interests = controller.interestData.value.interests;

          if (interests.isEmpty) {
            return const Center(child: Text('No interests available'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: interests.map((interest) {
                return Chip(
                  label: Text(
                    interest.name,
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
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onEdit}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            title,
            style: CustomTextStyles.labelMediumBlack900,
            textAlign: TextAlign.start,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: TextButton(
            onPressed: onEdit,
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

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: List.generate(5, (index) {
            return Chip(
              label: Container(
                width: 80,
                height: 20,
                color: Colors.grey[300],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: const BorderSide(color: Colors.transparent),
              ),
            );
          }),
        ),
      ),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
