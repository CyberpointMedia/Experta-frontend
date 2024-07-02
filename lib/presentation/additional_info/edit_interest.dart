import 'dart:developer';
import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/additional_info/controller/edit_interest_controller.dart';
import 'package:experta/presentation/additional_info/model/interest_model.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:experta/widgets/custom_search_view.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EditInterestPage extends StatefulWidget {
  const EditInterestPage({super.key});

  @override
  State<EditInterestPage> createState() => _EditInterestPageState();
}

class _EditInterestPageState extends State<EditInterestPage> {
  late InterestController controller;

  @override
  void initState() {
    super.initState();
    final List<Interest> initialSelectedInterests =
        Get.arguments as List<Interest>;
    controller = InterestController(interests: initialSelectedInterests);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundBlur(),
          Obx(() {
            if (controller.isLoading.value) {
              return _buildShimmerEffect();
            } else {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildAppBar()),
                  SliverToBoxAdapter(
                    child: _bodyWidget(context, controller),
                  )
                ],
              );
            }
          }),
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
                color: Colors.deepOrange.withOpacity(0.2),
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
      title: AppbarSubtitleSix(text: "Edit Interests"),
    );
  }

  Widget _bodyWidget(BuildContext context, InterestController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "What’s your interest?",
              style: CustomTextStyles.titleMediumBlack90001,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Pick your favorite interests to find groups and events related to them",
              style: CustomTextStyles.bodyMediumLight,
            ),
          ),
          CustomSearchView(
            hintText: "Search your interest",
            onChanged: (query) {
              if (query.isEmpty) {
                controller.resetInterests();
              } else {
                controller.filterInterests(query);
              }
            },
          ),
          const SizedBox(height: 10),
          Obx(() => SizedBox(
                height: 400,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: controller.filteredInterests.map((interest) {
                      final isSelected =
                          controller.selectedInterests.contains(interest);
                      return ChoiceChip(
                        label: Text(
                          interest.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => controller.toggleSelection(interest),
                        selectedColor:
                            Theme.of(context).primaryColor.withOpacity(0.5),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              )),
          const SizedBox(height: 10),
          Obx(() => CustomElevatedButton(
                onPressed: controller.selectedInterests.isNotEmpty
                    ? () async {
                        await controller.submitSelectedInterests();
                      }
                    : () {},
                text: "${controller.selectedInterests.length}/5 Selected",
              )),
        ],
      ),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(),
          _bodyWidget(context, controller),
        ],
      ),
    );
  }
}
