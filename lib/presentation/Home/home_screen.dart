// home_screen.dart
import 'dart:developer';
import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:experta/presentation/Trending%20Section/trending_section.dart';
import 'package:experta/presentation/categoryDetails/category_details_screen.dart';
import 'package:experta/presentation/dashboard/controller/dashboard_controller.dart';
import 'package:experta/widgets/animated_hint_searchview.dart';
import 'package:experta/widgets/dashed_border.dart';
import 'package:experta/presentation/Home/controller/home_controller.dart';
import 'package:experta/widgets/custom_icon_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeController controller;
  late DashboardController dashboardController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController());
    dashboardController = Get.find<DashboardController>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appTheme.gray20002,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Positioned(
              left: 270.adaptSize,
              top: 50.adaptSize,
              child: IgnorePointer(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    tileMode: TileMode.decal,
                    sigmaX: 100,
                    sigmaY: 100,
                  ),
                  child: Align(
                    child: SizedBox(
                      width: 252.adaptSize,
                      height: 252.adaptSize,
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
            ),
            RefreshIndicator(
              onRefresh: () async => controller.refreshData(),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildStackaccentone()),
                  SliverToBoxAdapter(
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
                  SliverToBoxAdapter(child: _buildColumncategory()),
                  SliverToBoxAdapter(child: _buildTrendingPeopleSection()),
                ],
              ),
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

  final List<String> hintTexts = [
    "msg_search_your_interest".tr,
    "Search Users",
    "Find Friends",
    "Find Consultant",
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
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: CustomAnimatedSearchView(
                width: double.infinity,
                controller: controller.searchController,
                hintTextDuration: const Duration(seconds: 2),
                hintTexts: hintTexts,
                onChanged: (value) {
                  controller.fetchUsersBySearch(value);
                },
              ),
            ),
          ),
          _buildColumnedit(),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
      height: 400.v,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        children: [
          Obx(() {
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
                      height: 65.adaptSize,
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
                                bottom: 3.adaptSize,
                                right: 1.adaptSize,
                                child: CircleAvatar(
                                  radius: 8.adaptSize,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 6.adaptSize,
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
        margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
        padding: EdgeInsets.symmetric(
            horizontal: 13.adaptSize, vertical: 14.adaptSize),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: appTheme.gray30001, width: 1.adaptSize),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0.adaptSize, right: 0.adaptSize),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Complete your Profile",
                        // style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                        style: theme.textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2.v),
                      Text("Fill in all required fields",
                          style: theme.textTheme.titleSmall),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(Get.context!).size.width * 0.3,
                    height: 36.v,
                    margin: EdgeInsets.only(bottom: 2.adaptSize),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        visualDensity:
                            const VisualDensity(vertical: -4, horizontal: -4),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.v, vertical: 9.h),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.editProfileSetting,
                            arguments: controller.profileCompletion.value);
                      },
                      child: Text(
                        "Edit Profile",
                        style: theme.textTheme.displaySmall
                            ?.copyWith(fontSize: 14.fSize),
                      ),
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
            padding: const EdgeInsets.only(right: 8),
            child: _buildRowtrending(
              trending: "Category",
              seeallOne: "See All",
              onPressed: () {
                Get.toNamed(AppRoutes.category,
                    arguments: {'industries': controller.industries});
              },
            ),
          ),
          SizedBox(height: 9.v),
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

                    return GestureDetector(
                      onTap: () {
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
                              height: 30.adaptSize,
                              width: 30.adaptSize,
                              child: CustomImageView(
                                imagePath: industry.icon,
                                color: theme.primaryColor,
                                placeHolder: ImageConstant.imageNotFound,
                              ),
                            ),
                            SizedBox(height: 5.v),
                            Text(
                              industry.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: theme.textTheme.labelMedium!
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildRowtrending(
            trending: "Top Users",
            seeallOne: "See All",
            onPressed: () {
              log("${controller.trendingPeople}");
              Get.to(() => TrendingPeoplePage(
                    trendingPeople: controller.trendingPeople,
                  ));
            },
          ),
        ),
        const SizedBox(height: 10), // Standard spacing
        SizedBox(
          height: MediaQuery.of(context).size.height * 1.8,
          child: FutureBuilder<List<User>>(
            future: controller.fetchTrendingPeople(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingList();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final users = snapshot.data ?? [];

              return Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return UserProfileItemWidget(user: users[index]);
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10), // Add space between items
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildLoadingList() {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16),
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemCount: 15,
      itemBuilder: (context, index) => _buildShimmerEffect(),
    );
  }

  Widget _buildRowtrending({
    required String trending,
    required String seeallOne,
    required Function onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          trending,
          style: theme.textTheme.titleLarge!.copyWith(
            fontSize: 22.fSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextButton(
          onPressed: () => onPressed(),
          child: Text(
            seeallOne,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w500,
              color: appTheme.deepOrangeA200,
            ),
          ),
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
}

class UserProfileItemWidget extends StatelessWidget {
  final User user;

  const UserProfileItemWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.detailsPage, arguments: {"user": user});
      },
      child: Padding(
        padding: EdgeInsets.only(right: 16.adaptSize, bottom: 10.adaptSize),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30.adaptSize,
                        right: 30.adaptSize,
                        top: 30.adaptSize),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 30.adaptSize,
                              backgroundColor: Colors.orange,
                              child: CircleAvatar(
                                radius: 28.adaptSize,
                                backgroundColor: Colors.white,
                                child: CustomImageView(
                                  height: 55,
                                  width: 55,
                                  radius: BorderRadius.circular(25),
                                  imagePath: user.profilePic.isNotEmpty
                                      ? user.profilePic
                                      : ImageConstant.imageNotFound,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 2,
                              child: Container(
                                height: 15.adaptSize,
                                width: 15.adaptSize,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.displayName.isNotEmpty
                                        ? user.displayName
                                        : "anonymous",
                                    style: TextStyle(
                                      fontSize: 16.fSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.verified,
                                      color: Colors.deepPurple, size: 16),
                                  const Spacer(),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6.adaptSize,
                                        vertical: 2.adaptSize),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: Colors.orange, width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.orange, size: 14),
                                        SizedBox(width: 4.adaptSize),
                                        Text(
                                          user.rating.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.fSize),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                user.industry.isNotEmpty
                                    ? "${user.industry} | ${user.occupation}"
                                    : "No data",
                                style: TextStyle(
                                  fontSize: 12.fSize,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  CustomImageView(
                                    height: 14.adaptSize,
                                    width: 14.adaptSize,
                                    imagePath: "assets/images/language.svg",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      (() {
                                        if (user.language != null &&
                                            user.language!.isNotEmpty) {
                                          final languages = user.language!
                                              .map((l) => l.name)
                                              .toList();

                                          if (languages.length > 3) {
                                            return '${languages.take(3).join(', ')} +${languages.length - 3} more';
                                          } else {
                                            return languages.join(', ');
                                          }
                                        } else {
                                          return 'No languages';
                                        }
                                      })(),
                                      style: TextStyle(
                                        fontSize: 12.fSize,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: CustomPaint(
                      painter: DashedDividerPainter(
                        color: appTheme.gray200, // or your desired color
                        dashWidth: 5.0, // length of each dash
                        dashSpace: 3.0, // space between dashes
                        strokeWidth: 1.0, // thickness of the line
                      ),
                      size: Size(MediaQuery.of(context).size.width * 0.8, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30.adaptSize,
                        right: 30.adaptSize,
                        top: 10.adaptSize),
                    child: Wrap(
                      spacing: 8.adaptSize,
                      runSpacing: 8.adaptSize,
                      children:
                          user.expertise == null || user.expertise!.isEmpty
                              ? [_buildChip('No expertise')]
                              : [
                                  ...user.expertise!
                                      .take(3)
                                      .map((e) => _buildChip(e.name)),
                                  if (user.expertise!.length > 3)
                                    _buildChip(
                                      '+${user.expertise!.length - 3}',
                                    ),
                                ],
                    ),
                  ),
                  SizedBox(height: 30.adaptSize),
                  Container(
                    decoration: BoxDecoration(
                      color: appTheme.gray100,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(24)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(
                            ImageConstant.videocam,
                            "${user.pricing.videoCallPrice}/min",
                            appTheme.red500,
                            () {}),
                        Container(
                          color: appTheme.gray300,
                          width: 0.5.adaptSize,
                          height: 50.adaptSize,
                        ),
                        _buildActionButton(
                            ImageConstant.call,
                            "${user.pricing.audioCallPrice}/min",
                            appTheme.green100,
                            () {}),
                        Container(
                          color: appTheme.gray300,
                          width: 0.5.adaptSize,
                          height: 50.adaptSize,
                        ),
                        _buildActionButton(
                            ImageConstant.msg,
                            "${user.pricing.messagePrice}/min",
                            appTheme.yellow900,
                            () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // "Top Rated" Ribbon
            Positioned(
              top: 55.adaptSize,
              left: -15.adaptSize,
              child: Transform.rotate(
                angle: -45 * (3.141592653589793 / 180),
                alignment: Alignment.topLeft,
                child: Container(
                  width: 100.adaptSize,
                  padding: EdgeInsets.symmetric(
                      vertical: 3.adaptSize, horizontal: 8.adaptSize),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(imagePath: "assets/images/verify.svg"),
                      SizedBox(width: 2.adaptSize),
                      const Text(
                        "Top Rated",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildChip(String label) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(60),
    ),
    padding:
        EdgeInsets.symmetric(horizontal: 12.adaptSize, vertical: 6.adaptSize),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 12.fSize,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    ),
  );
}

Widget _buildActionButton(
    String img, String label, Color color, VoidCallback? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        CustomImageView(imagePath: img),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
