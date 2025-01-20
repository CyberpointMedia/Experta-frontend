import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:experta/presentation/categoryDetails/category_details_screen.dart';
import 'package:experta/presentation/category/category_controller.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryController controller = Get.put(CategoryController());
  List<Industry> displayedIndustries = [];

  @override
  void initState() {
    super.initState();
    _loadLevel1Industries();
  }

  Future<void> _loadLevel1Industries() async {
    await controller.fetchIndustriesByLevel(1);
    setState(() {
      displayedIndustries = controller.industries;
    });
  }

  Future<void> _loadSubIndustries(String parentId, int level) async {
    await controller.fetchIndustriesByParentId(parentId, level);
    setState(() {
      displayedIndustries = controller.subIndustries;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Blurred background circle
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                tileMode: TileMode.decal,
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: displayedIndustries.length,
                    itemBuilder: (context, index) {
                      Industry industry = displayedIndustries[index];
                      return GestureDetector(
                        onTap: () {
                          if (industry.level == 3) {
                            Get.to(
                              () => CategoryDetailScreen(
                                categoryName: industry.name!,
                              ),
                              arguments: {'industry': industry},
                            );
                          } else {
                            _loadSubIndustries(
                                industry.id!, industry.level! + 1);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0XFFFFFFFF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 80.adaptSize,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 36.adaptSize,
                                width: 36.adaptSize,
                                child: SvgPicture.network(
                                  industry.icon!,
                                  placeholderBuilder: (BuildContext context) =>
                                      CircularProgressIndicator(),
                                ),
                              ),
                              SizedBox(height: 5.v),
                              Text(
                                industry.name!.capitalizeFirst!,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleSmall!.copyWith(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// AppBar Widget
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
      title: AppbarSubtitleSix(text: "Category"),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.notification);
            },
            padding: const EdgeInsets.only(right: 5),
            icon: Container(
              width: 35.0,
              height: 35.0,
              padding: const EdgeInsets.all(5),
              decoration: IconButtonStyleHelper.outline.copyWith(
                color: appTheme.whiteA700.withOpacity(0.6),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgBell02,
                height: 8.0,
                width: 8.0,
              ),
            ),
          ),
        )
      ],
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
