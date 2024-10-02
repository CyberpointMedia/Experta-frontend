// home_screen.dart
import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:experta/presentation/Trending%20Section/trending_section.dart';
import 'package:experta/presentation/categoryDetails/category_details_screen.dart';
import 'package:experta/presentation/dashboard/controller/dashboard_controller.dart';
import 'package:experta/widgets/animated_hint_searchview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:experta/presentation/Home/controller/home_controller.dart';
import 'package:experta/widgets/custom_icon_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController controller = Get.put(HomeController());
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appTheme.gray20002,
        body: Stack(
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
            SingleChildScrollView(child: Obx(() {
              return Column(
                children: [
                  _buildAppBar(),
                  _buildStackaccentone(),
                  SizedBox(height: 6.v),
                  _buildColumncategory(),
                  SizedBox(height: 31.v),
                  _buildTrendingPeopleSection(),
                  ..._buildSections(),
                ],
              );
            })),
            Padding(
              padding: const EdgeInsets.only(top: 120, left: 20, right: 20),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.searchController.text.isNotEmpty &&
                    controller.searchResults.isNotEmpty) {
                  return _buildSearchResults();
                }
                return const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 50.h,
      leadingWidth: 150.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.dashboard,
        margin: const EdgeInsets.only(left: 20),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.notification);
            },
            constraints: const BoxConstraints(
              minHeight: 30,
              minWidth: 30,
            ),
            padding: const EdgeInsets.all(0),
            icon: Container(
              width: 30.adaptSize,
              height: 30.v,
              decoration: IconButtonStyleHelper.outline.copyWith(
                color: const Color(0X59FFFFFF),
              ),
              child: SvgPicture.asset("assets/images/img_group_11.svg"),
            ),
          ),
        )
      ],
    );
  }

  final List<String> hintTexts = [
    "msg_search_your_interest".tr,
    "Search Users",
    "Find Friends",
    "Find Cunsultants",
    "Search Categories",
    "Search Interested Positions"
  ];
  Widget _buildStackaccentone() {
    return SizedBox(
      height: 200.v,
      width: 359.adaptSize,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: CustomAnimatedSearchView(
                width: double.infinity,
                controller: controller.searchController,
                hintTextDuration: const Duration(seconds: 2),
                hintTexts: hintTexts,
                onChanged: (value) {
                  controller.fetchUsersBySearch(value);
                },
              ),
              // child: CustomSearchView(
              //   width: double.infinity,
              //   controller: controller.searchController,
              //   hintText: "msg_search_your_interest".tr,
              // ),
            ),
          ),
          _buildColumnedit(),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          Obx(() {
            if (controller.searchResults == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.searchResults.length > 5
                    ? 5
                    : controller.searchResults.length,
                itemBuilder: (context, index) {
                  SearchResult user = controller.searchResults[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.detailsPage,
                          arguments: {"user": user});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      height: 65,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              CustomImageView(
                                radius: BorderRadius.circular(29), // 58 / 2
                                imagePath: (user.profilePic.isEmpty)
                                    ? ImageConstant.imgImage3380x80
                                    : user.profilePic,
                              ),
                              Positioned(
                                bottom: 3,
                                right: 1,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 6,
                                    backgroundColor:
                                        user.online ? Colors.green : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${user.firstName} ${user.lastName}"),
                                Text("${user.industry} | ${user.occupation}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          if (controller.searchResults.length > 5)
            TextButton(
              onPressed: () {
                final searchResults = controller.searchResults
                    .map((result) => result.toMap())
                    .toList();
                final searchQuery = controller.searchController.text;
                print('Search Results: $searchResults');
                print('Search Query: $searchQuery');

                controller.searchController.clear();
                dashboardController.navigateToPage(
                  1,
                  {
                    'searchResults': searchResults,
                    'searchQuery': searchQuery,
                  },
                );
              },
              child: const Text("View More"),
            ),
        ],
      ),
    );
  }

  Widget _buildColumnedit() {
    return Obx(() {
      if (controller.profileCompletion.value == null ||
          controller.profileCompletion.value!.totalCompletionPercentage ==
              100) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0XFFFFFFFF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: appTheme.gray30001, width: 1.adaptSize),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      "Complete your Profile",
      style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500), // Setting fontWeight to 500
    ),
    SizedBox(height: 2.v),
    Text(
      "Fill in all required fields",
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: 12.fSize,
        fontWeight: FontWeight.w400, // Setting fontWeight to 400
      ),
    ),
  ],
),

                  Container(
                    width: MediaQuery.of(Get.context!).size.width * 0.3,
                    height: 36.v,
                    margin: const EdgeInsets.only(bottom: 2),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFFEDC33),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        visualDensity:
                            const VisualDensity(vertical: -4, horizontal: -4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 9),
                      ),
                      onPressed: () {
                        // if (controller.profileCompletion.value!
                        //         .totalCompletionPercentage <
                        //     100) {
                        Get.toNamed(AppRoutes.editProfileSetting,
                            arguments: controller.profileCompletion.value);
                        // }
                      },
                      child: Text("Edit Profile",
                          style: theme.textTheme.displaySmall
                              ?.copyWith(fontSize: 14.fSize)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.v),
            Padding(
              padding: const EdgeInsets.only(left: 1),
              child: Container(
                height: 8.v,
                width: 313.adaptSize,
                decoration: BoxDecoration(
                  color: appTheme.gray20002,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: controller.profileCompletion.value!
                            .totalCompletionPercentage /
                        100,
                    backgroundColor: appTheme.gray20002,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(appTheme.deepOrangeA200),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildColumncategory() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildRowtrending(
              trending: "Category",
              seeallOne: "See All",
              onPressed: () {
                Get.toNamed(AppRoutes.category,
                    arguments: {'industries': controller.industries});
              },
            ),
          ),
          SizedBox(
            height: 80.v,
            child: Obx(
              () {
                if (controller.isLoading.value) {
                  return _buildShimmerEffect();
                }
                if (controller.industries.isEmpty) {
                  return const Center(child: Text("No items available"));
                }
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 15.adaptSize),
                  itemCount: controller.industries.length,
                  itemBuilder: (context, index) {
                    Industry industry = controller.industries[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0XFFFFFFFF),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0X0C000000),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(0, 30),
                          ),
                        ],
                      ),
                      width: 80.adaptSize,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30.adaptSize,
                            width: 30.adaptSize,
                            child: CustomImageView(imagePath: industry.icon),
                          ),
                          SizedBox(height: 5.v),
                          Text(
                            industry.name,
                            style: theme.textTheme.labelMedium!
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingPeopleSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildRowtrending(
            trending: "Trending",
            seeallOne: "See All",
            onPressed: () {
              Get.to(() => TrendingPeoplePage(
                    trendingPeople: controller.trendingPeople,
                  ));
            },
          ),
        ),
        Obx(() {
          if (controller.isLoading.value) {
            return SizedBox(
              height: 220.v,
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 16),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) =>
                    SizedBox(width: 10.adaptSize),
                itemCount: 15,
                itemBuilder: (context, index) {
                  return _buildShimmerEffect();
                },
              ),
            );
          }
          var trendingPeople = controller.trendingPeople;
          if (trendingPeople.isEmpty) {
            return SizedBox(
              height: 220.v,
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 16),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) =>
                    SizedBox(width: 10.adaptSize),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildEmptyContainer();
                },
              ),
            );
          }
          return SizedBox(
            height: 220.v,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 16),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) =>
                  SizedBox(width: 10.adaptSize),
              itemCount: trendingPeople.length,
              itemBuilder: (context, index) {
                User user = trendingPeople[index];
                return UserProfileItemWidget(user: user);
              },
            ),
          );
        }),
        SizedBox(height: 30.v),
      ],
    );
  }

  List<Widget> _buildSections() {
    return controller.industries.map((industry) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildRowtrending(
              trending: industry.name,
              seeallOne: "See All",
              onPressed: () {
                Get.to(
                  () => CategoryDetailScreen(
                    categoryName: industry.name,
                  ),
                  arguments: {'industry': industry},
                );
              },
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return SizedBox(
                height: 220.v,
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 16),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 10.adaptSize),
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return _buildShimmerEffect();
                  },
                ),
              );
            }
            var users = controller.usersByIndustry[industry.id] ?? [];
            if (users.isEmpty) {
              return SizedBox(
                height: 220.v,
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 16),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 10.adaptSize),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildEmptyContainer();
                  },
                ),
              );
            }
            return SizedBox(
              height: 220.v,
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 16),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) =>
                    SizedBox(width: 10.adaptSize),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  User user = users[index];
                  return UserProfileItemWidget(user: user);
                },
              ),
            );
          }),
          SizedBox(height: 30.v),
        ],
      );
    }).toList();
  }

  Widget _buildRowtrending(
      {required String trending,
      required String seeallOne,
      required Function onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(trending, style: theme.textTheme.titleLarge!),
        TextButton(
          onPressed: () => onPressed(),
          child: Text(seeallOne,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: appTheme.deepOrangeA200)),
        ),
      ],
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 80.adaptSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildEmptyContainer() {
    return SizedBox(
      height: 220.v,
      width: 156.adaptSize,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CustomImageView(
                imagePath: ImageConstant.imgWomanWithHeadsetVideoCall1,
                height: 220.v,
                width: 156.adaptSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80.0,
                width: 156.adaptSize,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.03),
                      Colors.black.withOpacity(0.5)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
              )),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 37),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildStatusContainer("Offline", appTheme.red500),
                      _buildRatingContainer("0"),
                    ],
                  ),
                  SizedBox(height: 126.v),
                  Text(
                    "Not Found",
                    maxLines: 1,
                    style: theme.textTheme.labelLarge
                        ?.copyWith(fontSize: 14.fSize),
                  ),
                  SizedBox(height: 2.v),
                  Text(
                    "Not found",
                    style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0XFFFFFFFF), fontSize: 11.fSize),
                  ),
                  SizedBox(height: 6.v),
                  Row(
                    children: [
                      SizedBox(
                          height: 14.v,
                          width: 14.adaptSize,
                          child: SvgPicture.asset(
                              "assets/images/img_layer_1.svg")),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "60",
                                  style: theme.textTheme.labelLarge!),
                              TextSpan(
                                  text: "/min",
                                  style: theme.textTheme.labelLarge
                                      ?.copyWith(fontWeight: FontWeight.w400)),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfileItemWidget extends StatelessWidget {
  final User user;

  const UserProfileItemWidget({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    print("hey the user is ${user.profilePic}/ ${user.displayName}");
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.detailsPage, arguments: {"user": user});
      },
      child: SizedBox(
        height: 220.v,
        width: 156.adaptSize,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CustomImageView(
                  imagePath: user.profilePic == ""
                      ? ImageConstant.imgWomanWithHeadsetVideoCall1
                      : user.profilePic,
                  height: 220.v,
                  width: 156.adaptSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 80.0,
                  width: 156.adaptSize,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.03),
                        Colors.black.withOpacity(0.5)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 37),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildStatusContainer(
                            user.online ? "Online" : "Offline",
                            user.online ? appTheme.green400 : appTheme.red500),
                        _buildRatingContainer(
                            // ignore: unnecessary_string_interpolations
                            "${user.rating.toStringAsFixed(1)}"),
                      ],
                    ),
                    SizedBox(height: 126.v),
                    Text(
                      user.displayName == "" ? "Not Found" : user.displayName,
                      maxLines: 1,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontSize: 14.fSize),
                    ),
                    SizedBox(height: 2.v),
                    Text(
                      user.industry == ""
                          ? "Not Found"
                          : "${user.industry} | ${user.occupation}",
                      style: theme.textTheme.bodyLarge?.copyWith(
                          color: const Color(0XFFFFFFFF), fontSize: 11.fSize),
                    ),
                    SizedBox(height: 6.v),
                    Row(
                      children: [
                        SizedBox(
                          height: 14.v,
                          width: 14.adaptSize,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgLayer1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "${user.pricing.videoCallPrice}",
                                    style: theme.textTheme.labelLarge!),
                                TextSpan(
                                    text: "/min",
                                    style: theme.textTheme.labelLarge?.copyWith(
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildStatusContainer(String text, Color color) {
  return Container(
    width: 44.adaptSize,
    padding: const EdgeInsets.symmetric(vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0X4C171717),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 4.v,
          width: 4.adaptSize,
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(
          text,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: const Color(0XFFFFFFFF)),
        ),
      ],
    ),
  );
}

Widget _buildRatingContainer(String text) {
  return Container(
    width: 37.adaptSize,
    margin: const EdgeInsets.only(left: 2),
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0X4C171717),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: SizedBox(
            height: 10.v,
            width: 10.adaptSize,
            child: SvgPicture.asset("assets/images/img_star.svg"),
          ),
        ),
        Text(
          text,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: const Color(0XFFFFFFFF)),
        ),
      ],
    ),
  );
}
