import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/userProfile/controller/profile_controller.dart';
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
            NestedScrollView(
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
                        controller
                                .userData.value.data?.basicInfo?.displayName ??
                            '',
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: appTheme.gray900,
                        ),
                      );
                    }),
                    actions: [
                      CustomImageView(
                        margin: const EdgeInsets.all(8),
                        imagePath: "assets/images/settings.svg",
                        onTap: () {
                          Get.delete<ProfileController>();
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
                            padding: const EdgeInsets.only(top: 50),
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
            ),
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildChipviewvisual(context),
                    SizedBox(
                      height: 5.v,
                    ),
                    _buildColumnaboutme(),
                    SizedBox(
                      height: 8.v,
                    ),
                    _buildColumnexperienc(),
                    SizedBox(
                      height: 8.v,
                    ),
                    _buildColumneducation(),
                    SizedBox(
                      height: 8.v,
                    ),
                    _buildColumnachieveme(),
                    SizedBox(
                      height: 8.v,
                    ),
                    _buildColumnintereste(),
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
      var posts = controller.userData.value.data?.basicInfo?.posts;
      if (posts == null || posts.isEmpty) {
        return const Center(
          child: Text(
            'No posts available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      } else {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CustomImageView(
                          imagePath: posts[index].image ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              },
              child: CustomImageView(
                imagePath: posts[index].image ?? '',
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

    return Column(
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
              colorClickableText: const Color(
                0XFFD45102,
              ),
              trimMode: TrimMode.Line,
              trimCollapsedText: "Read more",
              moreStyle:
                  theme.textTheme.bodyLarge?.copyWith(color: appTheme.gray900),
              lessStyle:
                  theme.textTheme.bodyLarge?.copyWith(color: appTheme.gray900),
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
    );
  }

  Widget _buildColumnexperienc() {
    return Column(
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller.userData.value.data?.workExperience
                    ?.map((experience) {
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
                      SizedBox(
                        height: 9.v,
                      ),
                      Text(
                        experience.companyName ?? '',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: appTheme.gray900),
                      ),
                      SizedBox(
                        height: 5.v,
                      ),
                      Text(
                        "$formattedStartDate - $formattedEndDate · $totalDuration",
                        style: theme.textTheme.bodyMedium!,
                      ),
                      SizedBox(
                        height: 18.v,
                      ),
                      Divider(
                        height: 1.v,
                        thickness: 1,
                        color: const Color(
                          0XFFE9E9E9,
                        ),
                      ),
                      SizedBox(
                        height: 19.v,
                      ),
                    ],
                  );
                }).toList() ??
                [],
          );
        }),
      ],
    );
  }

  Widget _buildChipviewvisual(BuildContext context) {
    final theme = Theme.of(context);
    final data = controller.userData.value.data?.expertise;
    final expertiseList = data?.expertise ?? [];

    return Column(
      children: [
        _buildRowaboutme(aboutMeText: "Expertise"),
        Padding(
          padding: const EdgeInsets.all(8.0),
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
                    fontSize: 16,
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
    );
  }

  Widget _buildColumneducation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 2),
          child: _buildRoweducation(educationText: "Education"),
        ),
        SizedBox(
          height: 19.v,
        ),
        Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                controller.userData.value.data?.education?.map((education) {
                      // Format the dates
                      String formattedStartDate = education.startDate != null
                          ? DateFormat('MMM yyyy').format(education.startDate!)
                          : '';
                      String formattedEndDate = education.endDate != null
                          ? DateFormat('MMM yyyy').format(education.endDate!)
                          : 'Present';

                      // Calculate the total duration
                      String totalDuration = '';
                      if (education.startDate != null &&
                          education.endDate != null) {
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
                          SizedBox(
                            height: 9.v,
                          ),
                          Text(
                            education.schoolCollege ?? '',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: appTheme.gray900),
                          ),
                          SizedBox(
                            height: 4.v,
                          ),
                          Text(
                            "$formattedStartDate - $formattedEndDate · $totalDuration",
                            style: theme.textTheme.bodyMedium!,
                          ),
                          SizedBox(
                            height: 18.v,
                          ),
                        ],
                      );
                    }).toList() ??
                    [],
          );
        }),
      ],
    );
  }

  Widget _buildColumnachieveme() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRowaboutme(aboutMeText: "Achievements"),
        SizedBox(
          height: 17.v,
        ),
        Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: controller
                    .userData.value.data?.industryOccupation?.achievements
                    ?.map((achievement) {
                  return Row(
                    children: [
                      SizedBox(
                        height: 24.v,
                        width: 25.adaptSize,
                        child: SvgPicture.asset("assets/images/img_link_1.svg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          top: 4,
                        ),
                        child: Text(
                          achievement,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: appTheme.gray900,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  );
                }).toList() ??
                [],
          );
        }),
      ],
    );
  }

  Widget _buildColumnintereste() {
    final interest = controller.userData.value.data?.interest;
    final interestList = interest?.interest ?? [];

    return Column(
      children: [
        _buildRowaboutme(aboutMeText: "Interests"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: interestList.map((interest) {
              return Chip(
                label: Text(
                  interest.name.toString(),
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
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
            Text(
              "See all",
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: appTheme.deepOrangeA200),
            )
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
            return Column(
              children: reviews.map((review) {
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 2.v,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/img_rectangle_2.png",
                            height: 34.v,
                            width: 36.adaptSize,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.reviewerName ?? '',
                                  style: theme.textTheme.headlineLarge
                                      ?.copyWith(fontSize: 14.fSize),
                                ),
                                SizedBox(
                                  height: 1.v,
                                ),
                                Text(
                                  review.date ?? '',
                                  style: theme.textTheme.titleSmall!,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 9.v,
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: review.rating?.toDouble() ?? 0,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemSize: 22,
                            itemCount: 5,
                            updateOnDrag: true,
                            onRatingUpdate: (rating) {},
                            itemBuilder: (context, _) {
                              return const Icon(
                                Icons.star,
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              review.rating?.toString() ?? '',
                              style: theme.textTheme.headlineLarge
                                  ?.copyWith(fontSize: 16.fSize),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.v,
                      ),
                      Container(
                        width: 304.adaptSize,
                        margin: const EdgeInsets.only(right: 31),
                        child: Text(
                          review.comment ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: appTheme.gray900),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            );
          }
        }),
        SizedBox(
          height: 19.v,
        )
      ],
    );
  }

  Widget _buildRowaboutme({required String aboutMeText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 1,
            bottom: 2,
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
      padding: const EdgeInsets.only(left: 13, right: 30, top: 30),
      child: Column(
        children: [
          Obx((){return Row(
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
                          child: SvgPicture.asset("assets/images/img_star.svg"),
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
                onTap: () => Get.toNamed(AppRoutes.follower),
                child: Column(
                      children: [
                        Text(
                          "$totalFollowers",
                          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 18.fSize),
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
                onTap: () => Get.toNamed(AppRoutes.following),
                child: Column(
                      children: [
                        Text(
                          "$totalFollowing",
                          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 18.fSize),
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

//  Widget _buildColumnFourHundredFifty({
//   required String dynamicText,
//   required String dynamicText1,
//   required VoidCallback onTap, 
// }) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Column(
//       children: [
//         Text(
//           dynamicText,
//           style: theme.textTheme.headlineLarge?.copyWith(fontSize: 18.fSize),
//         ),
//         SizedBox(
//           height: 6.v,
//         ),
//         Text(
//           dynamicText1,
//           style: theme.textTheme.bodyMedium!,
//         ),
//       ],
//     ),
//   );
// }


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
                    spacing: 8.0,
                    runSpacing: 4.0,
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
                Text(
                  "Reg no: ${controller.userData.value.data?.industryOccupation?.registrationNumber ?? " 22354678"}",
                  textAlign: TextAlign.left,
                  style: CustomTextStyles.bodyLargeBlack90001,
                ),
                Container(
                  width: 1.0,
                  height: 15,
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