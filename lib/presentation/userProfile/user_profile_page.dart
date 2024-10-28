import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/core/utils/web_view/web_view.dart';
import 'package:experta/presentation/all_review/all_review.dart';
import 'package:experta/presentation/userProfile/controller/profile_controller.dart';
import 'package:experta/presentation/userProfile/post_details/post_details.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  ProfileController controller = Get.put(ProfileController());
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
            Obx(() {
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      automaticallyImplyLeading: false,
                      expandedHeight: 450.0,
                      backgroundColor: Colors.transparent,
                      primary: true,
                      title: Obx(() {
                        return Text(
                          controller.userData.value.data?.basicInfo
                                  ?.displayName ??
                              '',
                          style: theme.textTheme.titleMedium!.copyWith(
                              color: appTheme.gray900,
                              fontSize: 20.fSize,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                      actions: [
                        CustomImageView(
                          margin: EdgeInsets.all(8.adaptSize),
                          imagePath: "assets/images/settings.svg",
                          onTap: () {
                            Get.toNamed(AppRoutes.settingScreen);
                          },
                        )
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 30.adaptSize),
                              child: _profilepicBody(),
                            ),
                            _ratingSection(),
                          ],
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(10),
                        child: Material(
                          color: Colors.white,
                          child: TabBar(
                            controller: _tabController,
                            labelColor: Colors.black,
                            dividerColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicatorSize: TabBarIndicatorSize.tab,
                            physics: const BouncingScrollPhysics(),
                            tabs: const [
                              Tab(text: 'About Me'),
                              Tab(text: 'Posts'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAboutMe(),
                    _buildPosts(),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildAboutMe() {
    return SizedBox(
      width: 430.adaptSize,
      child: Column(
        children: [
          SizedBox(
            height: 15.v,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.adaptSize),
                child: Column(
                  children: [
                    _buildChipviewvisual(context),
                    SizedBox(
                      height: 8.v,
                    ),
                    _buildColumnaboutme(),
                    SizedBox(
                      height: 8.v,
                    ),
                    _buildColumnExperience(),
                    SizedBox(
                      height: 8.v,
                    ),
                    _buildColumnEducation(),
                    SizedBox(
                      height: 8.v,
                    ),
                    _buildColumnAchievements(),
                    SizedBox(
                      height: 8.v,
                    ),
                    _buildColumnInterests(),
                    SizedBox(
                      height: 8.v,
                    ),
                    _buildColumnreviews()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPosts() {
    return Obx(() {
      var posts = controller.feeds;
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (posts.isEmpty) {
        return Center(
          child: Text(
            'No posts available',
            style: TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      } else {
        return GridView.builder(
          reverse: false,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            int reverseIndex = posts.length - 1 - index;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailsPage(
                      initialIndex: reverseIndex,
                      userId: controller.address.toString(),
                    ),
                  ),
                );
              },
              child: CustomImageView(
                imagePath: posts[reverseIndex].image ?? '',
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }
    });
  }

  Widget _buildColumnaboutme() {
    List<Map<String, dynamic>>? socialMediaLinks =
        controller.userData.value.data?.basicInfo?.getSocialMediaLinks();

    return Container(
      color: Colors.white, // Card-like appearance
      padding: const EdgeInsets.all(10), // Padding inside the card for spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildRowaboutme(aboutMeText: "About me"),
          SizedBox(
            height: 18.v,
          ),
          SizedBox(
            width: 331.adaptSize,
            child: Obx(() {
              return ReadMoreText(
                controller.userData.value.data?.basicInfo?.bio ?? '',
                trimLines: 3,
                colorClickableText: const Color(0XFFD45102),
                trimMode: TrimMode.Line,
                trimCollapsedText: "Read more",
                trimExpandedText: "Read less",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: appTheme.gray900, // Same style as the body text
                ),
                moreStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: appTheme.deepOrangeA200, // Color for 'Read more'
                  fontSize: theme.textTheme.bodyMedium
                      ?.fontSize, // Same font size as paragraph
                ),
                lessStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: appTheme.deepOrangeA200, // Color for 'Read less'
                  fontSize: theme.textTheme.bodyMedium
                      ?.fontSize, // Same font size as paragraph
                ),
              );
            }),
          ),
          SizedBox(
            height: 17.v,
          ),
          if (socialMediaLinks != null && socialMediaLinks.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: socialMediaLinks.map((socialMedia) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpertaBrowser(
                          url: socialMedia['link'],
                          title: socialMedia['name'],
                        ),
                      ),
                    );
                    print('Opening link: ${socialMedia['link']}');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      socialMedia['icon'],
                      size: 24,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildColumnExperience() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: _buildRoweducation(educationText: "Experience"),
          ),
          SizedBox(
            height: 19.v,
          ),
          Obx(() {
            var workExperience =
                controller.userData.value.data?.workExperience ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(workExperience.length, (index) {
                var experience = workExperience[index];

                // Format the dates
                String formattedStartDate = experience.startDate != null
                    ? DateFormat('MMM yyyy').format(experience.startDate!)
                    : '';
                String formattedEndDate = experience.endDate != null
                    ? DateFormat('MMM yyyy').format(experience.endDate!)
                    : 'Present';

                // Calculate the total duration
                String totalDuration = '';
                if (experience.startDate != null &&
                    experience.endDate != null) {
                  Duration duration =
                      experience.endDate!.difference(experience.startDate!);
                  int years = (duration.inDays / 365).floor();
                  int months = ((duration.inDays % 365) / 30).floor();
                  totalDuration = '$years years $months months';
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.jobTitle ?? '',
                      style: theme.textTheme.titleMedium!,
                    ),
                    SizedBox(height: 9.v),
                    Text(
                      experience.companyName ?? '',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: appTheme.gray900),
                    ),
                    SizedBox(height: 5.v),
                    Text(
                      "$formattedStartDate - $formattedEndDate · $totalDuration",
                      style: theme.textTheme.bodyMedium!,
                    ),
                    SizedBox(height: 18.v),

                    // Show the divider only if there is more than one experience
                    if (workExperience.length > 1 &&
                        index < workExperience.length - 1)
                      Divider(
                        height: 1.v,
                        thickness: 1,
                        color: const Color(0XFFE9E9E9),
                      ),
                  ],
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChipviewvisual(BuildContext context) {
    final theme = Theme.of(context);
    final data = controller.userData.value.data?.expertise;
    final expertiseList = data?.expertise ?? [];

    return Container(
      color: Colors.white, // Card-like appearance
      padding: const EdgeInsets.all(10), // Padding around the card content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowaboutme(aboutMeText: "Expertise"),
          const SizedBox(
              height: 8.0), // Added space for better visual separation
          Padding(
            padding:
                const EdgeInsets.all(8.0), // Padding around the expertise chips
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: expertiseList.map((expertise) {
                return Chip(
                  label: Text(
                    expertise.name.toString(),
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.fSize,
                    ),
                  ),
                  backgroundColor: appTheme.gray200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: appTheme.gray300,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnEducation() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: _buildRoweducation(educationText: "Education"),
          ),
          SizedBox(
            height: 19.v,
          ),
          Obx(() {
            var educationList = controller.userData.value.data?.education ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(educationList.length, (index) {
                var education = educationList[index];

                // Format the dates
                String formattedStartDate = education.startDate != null
                    ? DateFormat('MMM yyyy').format(education.startDate!)
                    : '';
                String formattedEndDate = education.endDate != null
                    ? DateFormat('MMM yyyy').format(education.endDate!)
                    : 'Present';

                // Calculate the total duration
                String totalDuration = '';
                if (education.startDate != null && education.endDate != null) {
                  Duration duration =
                      education.endDate!.difference(education.startDate!);
                  int years = (duration.inDays / 365).floor();
                  int months = ((duration.inDays % 365) / 30).floor();
                  totalDuration = '$years years $months months';
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      education.degree ?? '',
                      style: theme.textTheme.titleMedium!,
                    ),
                    SizedBox(height: 9.v),
                    Text(
                      education.schoolCollege ?? '',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: appTheme.gray900),
                    ),
                    SizedBox(height: 4.v),
                    Text(
                      "$formattedStartDate - $formattedEndDate · $totalDuration",
                      style: theme.textTheme.bodyMedium!,
                    ),
                    SizedBox(height: 18.v),

                    // Show the divider only if there is more than one education item
                    if (educationList.length > 1 &&
                        index < educationList.length - 1)
                      Divider(
                        height: 1.v,
                        thickness: 1,
                        color: const Color(0XFFE9E9E9),
                      ),
                  ],
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildColumnAchievements() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowaboutme(aboutMeText: "Achievements"),
          SizedBox(
            height: 17.v,
          ),
          Obx(() {
            var achievements = controller
                    .userData.value.data?.industryOccupation?.achievements ??
                [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(achievements.length, (index) {
                var achievement = achievements[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 10, right: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 24.v,
                            width: 25.adaptSize,
                            child: SvgPicture.asset(
                                "assets/images/img_link_1.svg"),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              achievement,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: appTheme.gray900,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Show the divider only if there is more than one achievement
                    if (achievements.length > 1 &&
                        index < achievements.length - 1)
                      Divider(
                        height: 1.v,
                        thickness: 1,
                        color: const Color(0XFFE9E9E9),
                      ),
                  ],
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildColumnInterests() {
    final interest = controller.userData.value.data?.interest;
    final interestList = interest?.interest ?? [];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowaboutme(aboutMeText: "Interests"),
          SizedBox(
            height: 17.v,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0, // Horizontal spacing between chips
              runSpacing: 4.0, // Vertical spacing between lines of chips
              children: interestList.map((interest) {
                return Chip(
                  label: Text(
                    interest.name ?? '', // Ensure interest name is not null
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.fSize,
                    ),
                  ),
                  backgroundColor: appTheme.gray200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: appTheme.gray300,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnreviews() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Reviews",
              style:
                  theme.textTheme.headlineLarge?.copyWith(fontSize: 16.fSize),
            ),
            GestureDetector(
              onTap: () {
                var reviews =
                    controller.userData.value.data?.basicInfo?.reviews;
                // Navigate to the AllReviewsPage even if there are no reviews
                Get.to(() => AllReviewsPage(reviews: reviews ?? []));
              },
              child: Text(
                "See all",
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: appTheme.deepOrangeA200),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 19.v,
        ),
        Obx(() {
          var reviews = controller.userData.value.data?.basicInfo?.reviews;
          if (reviews == null || reviews.isEmpty) {
            return Text(
              "No reviews yet",
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: appTheme.gray900),
            );
          } else {
            // Limit the number of reviews to 3
            var limitedReviews = reviews.take(3).toList();
            return Column(
              children: limitedReviews.map((review) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // Apply circular border to the container
                    decoration: BoxDecoration(
                      color: appTheme.gray100,
                      borderRadius: BorderRadius.circular(
                          15), // Circular border with radius 15
                      border: Border.all(
                        color: appTheme.gray300, // Border color
                        width: 0, // Border width
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomImageView(
                              imagePath: review.profilePic,
                              height: 50.v,
                              width: 50.h,
                              radius: BorderRadius.circular(50),
                            ),
                            SizedBox(width: 10.adaptSize),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.reviewer.toString(),
                                  style: theme.textTheme.headlineLarge
                                      ?.copyWith(fontSize: 14.fSize),
                                ),
                                SizedBox(height: 1.v),
                                Text(
                                  review.formattedDate.toString(),
                                  style: theme.textTheme.titleSmall!,
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 9.v),
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: review.rating!.toDouble(),
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemSize: 22,
                              updateOnDrag: true,
                              onRatingUpdate: (rating) {},
                              itemBuilder: (context, _) {
                                return const Icon(
                                  Icons.star,
                                );
                              },
                            ),
                            SizedBox(
                              width: 6.adaptSize,
                            ), // Added SizedBox for spacing
                            Text(
                              review.rating.toString(),
                              style: theme.textTheme.headlineLarge
                                  ?.copyWith(fontSize: 16.fSize),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.v),
                        Container(
                          width: 304.adaptSize,
                          margin: const EdgeInsets.only(right: 31),
                          child: Text(
                            review.review.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: appTheme.gray900),
                          ),
                        ),
                        SizedBox(height: 8.v), // Added SizedBox for spacing
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        }),
        SizedBox(
          height: 19.v,
        ),
      ],
    );
  }

  Widget _buildRowaboutme({required String aboutMeText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 1.adaptSize,
            bottom: 2.adaptSize,
          ),
          child: Text(
            aboutMeText,
            style: theme.textTheme.headlineLarge?.copyWith(fontSize: 16.fSize),
          ),
        ),
      ],
    );
  }

  Widget _buildRoweducation({required String educationText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          educationText,
          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 16.fSize),
        ),
      ],
    );
  }

  Widget _ratingSection() {
    int? totalFollowers =
        controller.userData.value.data?.basicInfo?.getTotalFollowers() ?? 0;
    int? totalFollowing =
        controller.userData.value.data?.basicInfo?.getTotalFollowing() ?? 0;

    return Padding(
      padding: EdgeInsets.only(
          left: 13.adaptSize, right: 30.adaptSize, top: 30.adaptSize),
      child: Column(
        children: [
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 1,
                            bottom: 2,
                          ),
                          child: SizedBox(
                            height: 18.v,
                            width: 18.adaptSize,
                            child:
                                SvgPicture.asset("assets/images/img_star.svg"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            "${controller.userData.value.data?.basicInfo?.rating ?? "N/A"}",
                            style: theme.textTheme.headlineLarge
                                ?.copyWith(fontSize: 18.fSize),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6.v,
                    ),
                    Text(
                      "Overall Ratings",
                      style: theme.textTheme.bodyMedium!,
                    )
                  ],
                ),
                const Spacer(
                  flex: 42,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.follower, arguments: {
                      "id": controller.userData.value.data?.id,
                      "userProfile": "userProfile"
                    })!
                        .then((value) {
                      Get.find<ProfileController>().fetchUserData(
                          controller.address.toString(),
                          controller.address.toString());
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "$totalFollowers",
                        style: theme.textTheme.headlineLarge
                            ?.copyWith(fontSize: 18.fSize),
                      ),
                      SizedBox(
                        height: 6.v,
                      ),
                      Text(
                        "Followers",
                        style: theme.textTheme.bodyMedium!,
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 58,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.following, arguments: {
                      "id": controller.userData.value.data?.id,
                      "userProfile": "userProfile"
                    })!
                        .then((value) {
                      Get.find<ProfileController>().fetchUserData(
                          controller.address.toString(),
                          controller.address.toString());
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "$totalFollowing",
                        style: theme.textTheme.headlineLarge
                            ?.copyWith(fontSize: 18.fSize),
                      ),
                      SizedBox(
                        height: 6.v,
                      ),
                      Text(
                        "Following",
                        style: theme.textTheme.bodyMedium!,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          SizedBox(
            height: 16.v,
          ),
          CustomElevatedButton(
            leftIcon: const Icon(
              Icons.add,
              color: Colors.black,
              size: 15,
            ),
            text: "Create Post",
            onPressed: () {
              Get.toNamed(AppRoutes.newPost);
            },
          )
        ],
      ),
    );
  }

  Widget _profilepicBody() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.v, top: 20.v),
                child: CustomImageView(
                  height: 70.v,
                  width: 70.v,
                  radius: BorderRadius.circular(50.v),
                  imagePath:
                      controller.userData.value.data?.basicInfo?.profilePic ??
                          ImageConstant.imgImage3380x80,
                ),
              ),
              SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(left: 15.v),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${controller.userData.value.data?.basicInfo?.firstName ?? ''} ${controller.userData.value.data?.basicInfo?.lastName ?? ''}',
                            textAlign: TextAlign.left,
                            style: CustomTextStyles.titleLargeSemiBold,
                          ),
                          CustomImageView(
                            margin: EdgeInsets.only(left: 5.v),
                            imagePath: "assets/images/veifiedtick.svg",
                          ),
                        ],
                      ),
                      Text(
                        "${controller.userData.value.data?.industryOccupation?.industry?.name ?? ''} | ${controller.userData.value.data?.industryOccupation?.occupation?.name ?? ''}",
                        textAlign: TextAlign.left,
                        style: CustomTextStyles.bodyMediumBlack90001,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.v, left: 10.v),
            child: Row(
              children: [
                CustomImageView(
                  margin: EdgeInsets.only(left: 5.v),
                  imagePath: "assets/images/language.svg",
                ),
                SizedBox(
                  width: 10.v,
                ),
                Expanded(
                  child: Wrap(
                    spacing: 8.adaptSize,
                    runSpacing: 4.adaptSize,
                    children: controller.userData.value.data?.language?.language
                            ?.map((e) => Text(
                                  e.name.toString(),
                                  style: CustomTextStyles.bodyLargeBlack90001,
                                ))
                            .toList() ??
                        [],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.v, left: 10.v),
            child: Row(
              children: [
                CustomImageView(
                  margin: EdgeInsets.only(left: 5.v),
                  imagePath: "assets/images/doctorverify.svg",
                ),
                SizedBox(
                  width: 10.v,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    "Reg no: ${controller.userData.value.data?.industryOccupation?.registrationNumber ?? " 22354678"}",
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: appTheme.black90001),
                  ),
                ),
                Container(
                  width: 1.0,
                  height: 15.v,
                  color: Colors.grey,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                ),
                CustomImageView(
                  margin: EdgeInsets.only(left: 5.v),
                  imagePath: "assets/images/chat.svg",
                ),
                SizedBox(
                  width: 10.v,
                ),
                Text(
                  "570",
                  textAlign: TextAlign.left,
                  style: CustomTextStyles.titleMediumBold,
                ),
                SizedBox(
                  width: 5.v,
                ),
                Text(
                  "Consultation",
                  textAlign: TextAlign.left,
                  style: CustomTextStyles.bodyLargeBlack90001,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
