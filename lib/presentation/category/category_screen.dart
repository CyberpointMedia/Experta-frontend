import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:experta/presentation/categoryDetails/category_details_screen.dart';
import 'package:experta/presentation/category/category_controller.dart';
import 'package:experta/widgets/custom_icon_button.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  int? selectedIndex; // Track the selected index
  final CategoryController controller =
      Get.put(CategoryController()); // Initialize controller

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
                child: Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: GridView.builder(
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
                        bool isSelected =
                            selectedIndex == index; // Check if item is selected

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            Get.to(
                              () => CategoryDetailScreen(
                                categoryName: industry.name,
                              ),
                              arguments: {'industry': industry},
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0XFFFFFFFF),
                              borderRadius: BorderRadius.circular(10),
                              // Removed boxShadow
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
                                  child: CustomImageView(
                                    imagePath: industry.icon,
                                    color: theme.primaryColor,
                                    placeHolder: ImageConstant.imageNotFound,
                                  ),
                                ),
                                SizedBox(height: 5.v),
                                Text(
                                  industry.name,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleSmall!
                                      .copyWith(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
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
                // color: appTheme.gray20002,
                color: appTheme.whiteA700.withOpacity(0.6),
                border: Border.all(
                  color: Colors.white,
                  width: 1.5, // Border width
                ),
              ),
              child: CustomImageView(
                imagePath: ImageConstant.imgBell02,
                height: 8.0, // Set the desired height
                width: 8.0, // Set the desired width
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
