import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:experta/presentation/categoryDetails/category_details_screen.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:experta/presentation/category/category_controller.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_title.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_iconbutton.dart';
import 'package:flutter/widgets.dart';

class CategoryScreen extends GetWidget<CategoryController> {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
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
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Obx(() {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: controller.industries.length,
                    itemBuilder: (context, index) {
                      Industry industry = controller.industries[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => CategoryDetailScreen(
                              categoryName: industry.name,
                            ),
                            arguments: {'industry': industry},
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImageView(
                              imagePath: industry.icon,
                              height: 36.v,
                              width: 36.adaptSize,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              industry.name,
                              style: theme.textTheme.headlineLarge
                                  ?.copyWith(fontSize: 14.fSize),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// Section Widget

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
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Category"),
      actions: [
        AppbarTrailingIconbutton(
          imagePath: "assets/images/img_frame_30.svg",
          margin: const EdgeInsets.symmetric(horizontal: 16),
        )
      ],
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
