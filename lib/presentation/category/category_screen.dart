import 'dart:ui';

import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:experta/presentation/category/category_controller.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_title.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_iconbutton.dart';
import 'package:experta/theme/theme_helper.dart';
import 'package:experta/core/utils/size_utils.dart';

class CategoryScreen extends GetWidget<CategoryController> {
  CategoryScreen({super.key});

  final List<Map<String, String>> categories = [
    {"name": "Actors", "asset": "assets/images/img_celebrity_1.svg"},
    {"name": "Athletes", "asset": "assets/images/img_running_shoe.svg"},
    {"name": "Comedians", "asset": "assets/images/img_theater_3.svg"},
    {"name": "Musicians", "asset": "assets/images/img_guitar.svg"},
    {"name": "Creators", "asset": "assets/images/img_movie.svg"},
    {"name": "Doctors", "asset": "assets/images/img_stethoscope_5.svg"},
    {"name": "Chefs", "asset": "assets/images/img_chef_hat_3.svg"},
    {"name": "Teachers", "asset": "assets/images/img_graduate_hat.svg"},
    {"name": "Astrologers", "asset": "assets/images/img_magic_cards.svg"},
    {"name": "Sports", "asset": "assets/images/img_american_football.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray20002,
        appBar: _buildAppBar(context),
        body: SizedBox(
          height: 620.v,
          width: 375.adaptSize,
          child: Stack(
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
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 28,
                    right: 32,
                  ),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailScreen(
                                  categoryName: category['name']!),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              category['asset']!,
                              height: 36.v,
                              width: 36.adaptSize,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              category['name']!,
                              style: theme.textTheme.headlineLarge
                                  ?.copyWith(fontSize: 14.fSize),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 40.v,
      leadingWidth: 40,
      leading: AppbarLeadingImage(
        imagePath: "assets/images/img_arrow_left.svg",
        margin: const EdgeInsets.only(
          left: 16,
          top: 8,
          bottom: 8,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: AppbarTitle(
        text: "Category",
        margin: const EdgeInsets.only(left: 12),
      ),
      actions: [
        AppbarTrailingIconbutton(
          imagePath: "assets/images/img_frame_30.svg",
          margin: const EdgeInsets.symmetric(horizontal: 16),
        )
      ],
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;

  const CategoryDetailScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Center(
        child: Text('Category Detail Screen for $categoryName'),
      ),
    );
  }
}
