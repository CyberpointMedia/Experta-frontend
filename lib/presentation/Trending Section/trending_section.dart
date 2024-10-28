import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/home_screen.dart';
import 'package:experta/presentation/Home/model/home_model.dart';

class TrendingPeoplePage extends StatelessWidget {
  final List<User> trendingPeople;

  const TrendingPeoplePage({super.key, required this.trendingPeople});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                  padding: EdgeInsets.only(
                      left: 16.adaptSize, right: 16.adaptSize, top: 0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0, // Set gap between columns to 16
                      mainAxisSpacing: 16.0, // Set gap between rows to 16
                      childAspectRatio: 0.75,
                    ),
                    itemCount: trendingPeople.length,
                    itemBuilder: (context, index) {
                      User user = trendingPeople[index];
                      return UserProfileItemWidget(user: user);
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

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
        height: 40.h,
        leadingWidth: 40.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
            margin: EdgeInsets.only(left: 16.h),
            onTap: () {
              onTapArrowLeft();
            }),
        centerTitle: true,
        title: AppbarSubtitleSix(text: "Trending"));
  }

  onTapArrowLeft() {
    Get.back();
  }
}
