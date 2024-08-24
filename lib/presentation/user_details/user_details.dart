import 'dart:developer';
import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/core/utils/web_view/web_view.dart';
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:experta/presentation/all_review/all_review.dart';
import 'package:experta/presentation/userProfile/post_details/post_details.dart';
import 'package:experta/presentation/user_details/controller/details_controller.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage>
    with SingleTickerProviderStateMixin {
  final User id = Get.arguments['user'];
  DetailsController controller = Get.put(DetailsController());

  late TabController _tabController;

  @override
  void initState() {
    controller.fetchUserData(id.id);
    controller.fetchFeeds(id.id);
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent, // Set the background color to transparent
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Center(
                          child: Text(
                            'Report this user',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        onTap: () {
                          // Handle report action
                          Navigator.pop(context);
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Center(
                          child: Text(
                            'Block this user',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _showBlockUserDialog(context, id.id,
                              controller); // Show the block user confirmation dialog
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: ListTile(
                    title: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBlockUserDialog(BuildContext context, String userToBlockId,
      DetailsController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Colors.transparent, // Make the dialog background transparent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Obx(() {
            if (controller.isSucess.value) {
              // If success, show success animation and dismiss after 3 seconds
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
              });

              return SizedBox(
                height: 200,
                width: 200,
                child: Center(
                  child: Lottie.asset("assets/jsonfiles/tick.json"),
                ),
              );
            } else if (controller.isBlocking.value) {
              // If loading, show loading animation
              return Center(
                child: Lottie.asset("assets/jsonfiles/Loader.json"),
              );
            } else {
              // Default dialog content
              return Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomIconButton(
                        height: 88.adaptSize,
                        width: 88.adaptSize,
                        padding: EdgeInsets.all(20.h),
                        decoration: IconButtonStyleHelper.fillGreenTL245,
                        child: CustomImageView(
                          imagePath: ImageConstant.popup,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        "Block this user",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Are you sure you want to block this user? This action can be undone later.',
                          style: CustomTextStyles.bodyMediumLight,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      CustomElevatedButton(
                        onPressed: () async {
                          controller.isBlocking.value = true;
                          controller.blockUser(userToBlockId, context);
                        },
                        text: "Block",
                      ),
                      const SizedBox(height: 12.0),
                      CustomOutlinedButton(
                        height: 56.v,
                        buttonStyle: CustomButtonStyles.outlineGrayTL23,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: "Cancel",
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              );
            }
          }),
        );
      },
    );
  }

  void _showBottomSheet2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade100,
                    child: const Icon(Icons.call, color: Colors.green),
                  ),
                  title: const Text('Audio Call'),
                  subtitle: const Text('Chat me up, share photos.'),
                  trailing: const Text(
                    '1800/min',
                    style: TextStyle(
                      color: Colors.amber,
                    ),
                  ),
                  onTap: () {
                    // Handle audio call action
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.shade100,
                    child: const Icon(Icons.videocam, color: Colors.red),
                  ),
                  title: const Text('Video Call'),
                  subtitle: const Text('Call your doctor directly.'),
                  trailing: const Text(
                    '2800/min',
                    style: TextStyle(
                      color: Colors.amber,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.yellow.shade100,
                    child:
                        const Icon(Icons.calendar_today, color: Colors.yellow),
                  ),
                  title: const Text('Schedule Call'),
                  subtitle: const Text('Chat me up, share photos.'),
                  trailing: const Text(
                    '1800/min',
                    style: TextStyle(
                      color: Colors.amber,
                    ),
                  ),
                  onTap: () {
                    // Handle schedule call action
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: ,
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
            Obx(() {
              return NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      automaticallyImplyLeading: false,
                      expandedHeight: MediaQuery.of(context).size.height * 0.45,
                      backgroundColor: Colors.transparent,
                      primary: true,
                      leading: AppbarLeadingImage(
                        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
                        margin: EdgeInsets.only(
                            left: 16.h, top: 10, bottom: 10, right: 16),
                        onTap: () {
                          onTapArrowLeft();
                        },
                      ),
                      title: Obx(() {
                        return Text(
                          controller.userData.value.data?.basicInfo
                                  ?.displayName ??
                              '',
                          style: theme.textTheme.titleMedium!.copyWith(
                              color: appTheme.gray900,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: Obx(() => CustomElevatedButton(
                                buttonStyle: CustomButtonStyles.fillOnError2,
                                buttonTextStyle:
                                    CustomTextStyles.bodySmallffffffff,
                                height: 36,
                                width: 70,
                                text: controller.isFollowing.value == false
                                    ? "Follow"
                                    : "Unfollow",
                                onPressed: () {
                                  if (controller.isFollowing.value == false) {
                                    controller.followUser(
                                        controller.userData.value.data?.id ??
                                            '');
                                    controller.fetchUserData(
                                        controller.userData.value.data?.id ??
                                            '');
                                    setState(() {
                                      controller.isFollowing.value = true;
                                    });
                                    log("now the new value of is following is ==== ${controller.isFollowing.value}");
                                  } else {
                                    // Handle unfollow logic here if needed
                                    // controller.unfollowUser(controller.userData.value.data?.id ?? '');
                                    controller.fetchUserData(
                                        controller.userData.value.data?.id ??
                                            '');
                                    setState(() {
                                      controller.isFollowing.value = false;
                                    });
                                  }
                                },
                              )),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 80),
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
            }),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: appTheme.whiteA700,
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 15, right: 10, left: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomElevatedButton(
                        width: MediaQuery.of(context).size.width * 0.75,
                        text: "Make a call",
                        onPressed: () {
                          _showBottomSheet2(context);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomImageView(
                        height: 50,
                        width: 50,
                        imagePath: ImageConstant.msg,
                      )
                    ],
                  ),
                ),
              ),
            )
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
          ),
          const SizedBox(
            height: 100,
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
        return Column(
          children: [
            Expanded(
              child: GridView.builder(
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
                            userId: id.id,
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
              ),
            ),
            const SizedBox(
              height: 100,
              width: double.infinity,
            ),
          ],
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
                  String formattedStartDate = experience.startDate != null
                      ? DateFormat('MMM yyyy').format(experience.startDate!)
                      : '';
                  String formattedEndDate = experience.endDate != null
                      ? DateFormat('MMM yyyy').format(experience.endDate!)
                      : 'Present';
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
                          achievement ?? '',
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
      crossAxisAlignment:
          CrossAxisAlignment.start, // Added for better alignment
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
                  interest.name ?? '', // Ensure interest name is not null
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
            GestureDetector(
              onTap: () {
                var reviews =
                    controller.userData.value.data?.basicInfo?.reviews;
                if (reviews != null && reviews.isNotEmpty) {
                  Get.to(() => AllReviewsPage(reviews: reviews));
                }
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
                    color: appTheme.gray100,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomImageView(
                              imagePath: review.profilePic,
                              height: 50,
                              width: 50,
                              radius: BorderRadius.circular(50),
                            ),
                            const SizedBox(width: 10),
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
                                )
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
                            const SizedBox(
                                width: 6), // Added SizedBox for spacing
                            Text(
                              review.rating.toString(),
                              style: theme.textTheme.headlineLarge
                                  ?.copyWith(fontSize: 16.fSize),
                            )
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
          Row(
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
                onTap: () {
                  Get.toNamed(AppRoutes.follower, arguments: {
                    "id": id.id,
                    "userProfile": "userDetails"
                  })!
                      .then((value) {
                    Get.find<DetailsController>().fetchUserData(id.id);
                  });
                },
                child: _buildColumnFourHundredFifty(
                  dynamicText: "$totalFollowers",
                  dynamicText1: "Followers",
                ),
              ),
              const Spacer(
                flex: 58,
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.following, arguments: {
                    "id": id.id,
                    "userProfile": "userProfile"
                  })!
                      .then((value) {
                    Get.find<DetailsController>().fetchUserData(id.id);
                  });
                },
                child: _buildColumnFourHundredFifty(
                  dynamicText: "$totalFollowing",
                  dynamicText1: "Following",
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumnFourHundredFifty(
      {required String dynamicText, required String dynamicText1}) {
    return Column(
      children: [
        Text(
          dynamicText,
          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 18.fSize),
        ),
        SizedBox(
          height: 6.v,
        ),
        Text(
          dynamicText1,
          style: theme.textTheme.bodyMedium!,
        )
      ],
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
                  "Reg no: ${controller.userData.value.data?.industryOccupation?.registrationNumber ?? " N/A"}",
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
                  "587",
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
