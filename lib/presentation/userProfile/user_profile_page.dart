import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/core/utils/web_view/web_view.dart';
import 'package:experta/presentation/all_review/all_review.dart';
import 'package:experta/presentation/edit_about/edit_about.dart';
import 'package:experta/presentation/edit_experties/edit_experties.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';
import 'package:experta/presentation/userProfile/controller/profile_controller.dart';
import 'package:experta/presentation/userProfile/post_details/post_details.dart';
import 'package:experta/widgets/custom_rating_bar.dart';
import 'package:experta/widgets/custom_toast_message.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with TickerProviderStateMixin {
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
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: NestedScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          ProfileHeader(controller: controller, tabController: _tabController),
        ],
        body:
            ProfileTabs(controller: controller, tabController: _tabController),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ProfileController controller;
  final TabController tabController;

  const ProfileHeader(
      {super.key, required this.controller, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      automaticallyImplyLeading: false,
      expandedHeight: MediaQuery.of(context).size.height * 0.52,
      backgroundColor: Colors.transparent,
      primary: true,
      title: _buildAppBarTitle(context),
      actions: [_buildSettingsButton()],
      flexibleSpace: _buildFlexibleSpace(context),
      bottom: _buildTabBar(context, tabController),
    );
  }

  Widget _buildAppBarTitle(BuildContext context) {
    return Obx(() => Text(
          controller.userData.value.data?.basicInfo?.displayName ?? '',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: appTheme.black900,
                fontSize: 20.fSize,
                fontWeight: FontWeight.bold,
              ),
        ));
  }

  Widget _buildSettingsButton() {
    return CustomImageView(
      margin: EdgeInsets.all(8.adaptSize),
      imagePath: "assets/images/settings.svg",
      onTap: () async {
        await Get.toNamed(AppRoutes.settingScreen,
            arguments:
                controller.userData.value.data?.basicInfo?.profilePic ?? '');
        controller.refreshData();
      },
    );
  }

  Widget _buildFlexibleSpace(BuildContext context) {
    return FlexibleSpaceBar(
      background: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 30.adaptSize,
            ),
            child: _profilepicBody(context),
          ),
          _ratingSection(context),
        ],
      ),
    );
  }

  PreferredSize _buildTabBar(
      BuildContext context, TabController tabController) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(10),
      child: Material(
        color: Colors.white,
        child: TabBar(
          controller: tabController,
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
    );
  }

  Widget _profilepicBody(BuildContext context) {
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          "${controller.userData.value.data?.industryOccupation?.industry?.name ?? ''} | ${controller.userData.value.data?.industryOccupation?.occupation?.name ?? ''}",
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: appTheme.black900),
                        ),
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
                    children: (() {
                      final languages =
                          controller.userData.value.data?.language?.language;

                      if (languages != null && languages.isNotEmpty) {
                        final languageNames =
                            languages.map((e) => e.name.toString()).toList();

                        if (languageNames.length > 3) {
                          return [
                            Text(
                              '${languageNames.take(3).join(', ')} +${languageNames.length - 3} more',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: appTheme.black900,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ];
                        } else {
                          return [
                            Text(
                              languageNames.join(', '),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: appTheme.black900,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                            )
                          ];
                        }
                      } else {
                        return <Widget>[
                          Text(
                            "No Languages found",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: appTheme.black900,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                          )
                        ];
                      }
                    })(),
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
                    "Reg no: ${controller.userData.value.data?.industryOccupation?.registrationNumber ?? " N/A"}",
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: appTheme.black900,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  width: 1.v,
                  height: 15.h,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 10.adaptSize),
                ),
                CustomImageView(
                  margin: EdgeInsets.only(left: 5.v),
                  imagePath: "assets/images/chat.svg",
                ),
                SizedBox(
                  width: 10.v,
                ),
                Text(
                  (controller.userData.value.data?.noOfBooking != null &&
                          controller.userData.value.data!.noOfBooking
                              .toString()
                              .isNotEmpty)
                      ? controller.userData.value.data!.noOfBooking.toString()
                      : "0",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: appTheme.black900,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 5.v,
                ),
                Text(
                  "Consultation",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: appTheme.black900,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _ratingSection(BuildContext context) {
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
                          padding: EdgeInsets.only(
                            top: 1.adaptSize,
                            bottom: 2.adaptSize,
                          ),
                          child: SizedBox(
                            height: 18.v,
                            width: 18.adaptSize,
                            child:
                                SvgPicture.asset("assets/images/img_star.svg"),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2.adaptSize),
                          child: Text(
                            "${controller.userData.value.data?.basicInfo?.rating ?? "N/A"}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
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
                      style: Theme.of(context).textTheme.titleSmall!,
                    )
                  ],
                ),
                const Spacer(
                  flex: 42,
                ),
                GestureDetector(
                  onTap: () async {
                    await Get.toNamed(AppRoutes.follower, arguments: {
                      "id": controller.userData.value.data?.id,
                      "userProfile": "userProfile"
                    })!
                        .then((value) {
                      Get.find<ProfileController>().fetchUserData(
                          controller.address.toString(),
                          controller.address.toString());
                    });
                    controller.refreshData();
                  },
                  child: Column(
                    children: [
                      Text(
                        "$totalFollowers",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontSize: 18.fSize),
                      ),
                      SizedBox(
                        height: 6.v,
                      ),
                      Text(
                        "Followers",
                        style: Theme.of(context).textTheme.titleSmall!,
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 58,
                ),
                GestureDetector(
                  onTap: () async {
                    await Get.toNamed(AppRoutes.following, arguments: {
                      "id": controller.userData.value.data?.id,
                      "userProfile": "userProfile"
                    })!
                        .then((value) {
                      Get.find<ProfileController>().fetchUserData(
                          controller.address.toString(),
                          controller.address.toString());
                    });
                    controller.refreshData();
                  },
                  child: Column(
                    children: [
                      Text(
                        "$totalFollowing",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontSize: 18.fSize),
                      ),
                      SizedBox(
                        height: 6.v,
                      ),
                      Text(
                        "Following",
                        style: Theme.of(context).textTheme.titleSmall,
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
            leftIcon: Icon(
              Icons.add,
              color: Colors.black,
              size: 15.adaptSize,
            ),
            text: "Create Post",
            onPressed: () async {
              await Get.toNamed(AppRoutes.newPost);
              controller.refreshData();
            },
          )
        ],
      ),
    );
  }
}

class ProfileTabs extends StatelessWidget {
  final ProfileController controller;
  final TabController tabController;

  const ProfileTabs({
    super.key,
    required this.controller,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: tabController,
      children: [
        AboutMeSection(controller: controller),
        PostsSection(controller: controller),
      ],
    );
  }
}

class AboutMeSection extends StatelessWidget {
  final ProfileController controller;

  const AboutMeSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                    _buildColumnaboutme(context),
                    SizedBox(
                      height: 8.v,
                    ),
                    ExperienceSection(controller: controller),
                    SizedBox(
                      height: 8.v,
                    ),
                    EducationSection(controller: controller),
                    SizedBox(
                      height: 8.v,
                    ),
                    AchievementsSection(controller: controller),
                    SizedBox(
                      height: 8.v,
                    ),
                    InterestsSection(controller: controller),
                    SizedBox(
                      height: 8.v,
                    ),
                    ReviewsSection(controller: controller),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChipviewvisual(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRowaboutme(context, aboutMeText: "Expertise"),
              CustomImageView(
                imagePath: "assets/images/Frame.svg",
                onTap: () async {
                  final expertiseList =
                      controller.userData.value.data?.expertise?.expertise ??
                          [];

                  await Get.to(() => EditExpertisePage(
                        selectedItems: expertiseList.map((userExpertise) {
                          return ExpertiseItem(
                            id: userExpertise.id.toString(),
                            name: userExpertise.name.toString(),
                          );
                        }).toList(),
                      ));
                  controller.refreshData();
                },
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              final expertiseList =
                  controller.userData.value.data?.expertise?.expertise ?? [];

              return Wrap(
                spacing: 4.0,
                runSpacing: 0.0,
                children: expertiseList.map((expertise) {
                  return Chip(
                    label: Text(
                      expertise.name.toString(),
                      style: theme.textTheme.titleSmall!.copyWith(
                        color: Colors.black,
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
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnaboutme(BuildContext context) {
    List<Map<String, dynamic>>? socialMediaLinks =
        controller.userData.value.data?.basicInfo?.getSocialMediaLinks();
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRowaboutme(context, aboutMeText: "About me"),
              InkWell(
                onTap: () async {
                  final bio =
                      controller.userData.value.data?.basicInfo?.bio ?? '';
                  await Get.to(
                    () => EditAboutPage(bio: bio),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );

                  controller.refreshData();
                },
                child: CustomImageView(
                  height: 19,
                  width: 19,
                  imagePath: "assets/images/Frame.svg",
                ),
              ),
            ],
          ),
          SizedBox(height: 18.v),
          SizedBox(
            width: 331.adaptSize,
            child: Obx(() {
              return ReadMoreText(
                controller.userData.value.data?.basicInfo?.bio ?? '',
                trimLines: 3,
                colorClickableText: appTheme.readmore,
                trimMode: TrimMode.Line,
                trimCollapsedText: "Read more",
                trimExpandedText: "Read less",
                style: theme.textTheme.titleSmall!
                    .copyWith(color: appTheme.black900),
                moreStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: appTheme.readmore, // Color for 'Read more'
                  fontSize: theme.textTheme.bodyMedium?.fontSize,
                ),
                lessStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: appTheme.readmore, // Color for 'Read less'
                  fontSize: theme.textTheme.bodyMedium?.fontSize,
                ),
              );
            }),
          ),
          SizedBox(
            height: 17.v,
          ),
          if (socialMediaLinks != null && socialMediaLinks.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                    controller.refreshData();
                    print('Opening link: ${socialMedia['link']}');
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.adaptSize),
                    child: CustomImageView(
                      imagePath: socialMedia['icon'],
                      height: 24.adaptSize,
                      width: 24.adaptSize,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildRowaboutme(BuildContext context, {required String aboutMeText}) {
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
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontSize: 16.fSize, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class PostsSection extends StatelessWidget {
  final ProfileController controller;

  const PostsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var posts = controller.feeds;
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (posts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgNoChat,
                height: 70.h,
                width: 70.h,
              ),
              SizedBox(height: 20.v),
              Text(
                "Your feed is empty",
                style: CustomTextStyles.titleMediumBold,
              ),
              SizedBox(height: 8.v),
              Text(
                "Let’s create your first post here.",
                style: CustomTextStyles.bodyMediumLight,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.v),
            ],
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
                controller.refreshData();
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
}

class ExperienceSection extends StatelessWidget {
  final ProfileController controller;

  const ExperienceSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Text(
                  "Experience",
                  style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 16.fSize,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              CustomImageView(
                imagePath: "assets/images/Frame.svg",
                onTap: () async {
                  await Get.toNamed(AppRoutes.experience);
                  controller.refreshData();
                },
              ),
            ],
          ),
          SizedBox(height: 19.v),
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
                      style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: 16.fSize, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 1.v),
                    Text(
                      experience.companyName ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                          color: appTheme.gray900,
                          fontSize: 14.fSize,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 1.v),
                    Text(
                      "$formattedStartDate - $formattedEndDate · $totalDuration",
                      style: theme.textTheme.titleSmall!.copyWith(
                        fontSize: 14.fSize,
                      ),
                    ),
                    SizedBox(height: 18.v),
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
}

class EducationSection extends StatelessWidget {
  final ProfileController controller;

  const EducationSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Text(
                  "Education",
                  style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 16.fSize,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              CustomImageView(
                imagePath: "assets/images/Frame.svg",
                onTap: () async {
                  await Get.toNamed(AppRoutes.education);
                  controller.refreshData();
                },
              ),
            ],
          ),
          SizedBox(height: 19.v),
          Obx(() {
            var educationList = controller.userData.value.data?.education ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(educationList.length, (index) {
                var education = educationList[index];
                String formattedStartDate = education.startDate != null
                    ? DateFormat('MMM yyyy').format(education.startDate!)
                    : '';
                String formattedEndDate = education.endDate != null
                    ? DateFormat('MMM yyyy').format(education.endDate!)
                    : 'Present';
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
                      style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: 16.adaptSize, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 1.v),
                    Text(
                      education.schoolCollege ?? '',
                      style: theme.textTheme.titleMedium!.copyWith(
                          color: appTheme.gray900,
                          fontSize: 14.adaptSize,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 1.v),
                    Text(
                      "$formattedStartDate - $formattedEndDate · $totalDuration",
                      style: theme.textTheme.titleSmall!.copyWith(
                          fontSize: 14.adaptSize, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 18.v),
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
}

class AchievementsSection extends StatelessWidget {
  final ProfileController controller;

  const AchievementsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowaboutme(context, aboutMeText: "Achievements"),
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
                        padding: EdgeInsets.only(
                            bottom: 8.adaptSize,
                            left: 10.adaptSize,
                            right: 10.adaptSize),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 24.v,
                              width: 25.adaptSize,
                              child: CustomImageView(
                                  imagePath: "assets/images/img_link_1.svg"),
                            ),
                            SizedBox(width: 10.adaptSize),
                            Expanded(
                              child: Text(
                                achievement,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: appTheme.gray900,
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                            ),
                          ],
                        )),
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

  Widget _buildRowaboutme(BuildContext context, {required String aboutMeText}) {
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
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontSize: 16.fSize, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class InterestsSection extends StatelessWidget {
  final ProfileController controller;

  const InterestsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final interest = controller.userData.value.data?.interest;
    final interestList = interest?.interest ?? [];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRowaboutme(context, aboutMeText: "Interests"),
                CustomImageView(
                  imagePath: "assets/images/Frame.svg",
                  onTap: () async {
                    await Get.toNamed(AppRoutes.additional);
                    controller.refreshData();
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 17.v),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: interestList.map((interest) {
                return Chip(
                  label: Text(
                    interest.name ?? '',
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

  Widget _buildRowaboutme(BuildContext context, {required String aboutMeText}) {
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
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontSize: 16.fSize, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class ReviewsSection extends StatelessWidget {
  final ProfileController controller;

  const ReviewsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reviews",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontSize: 16.fSize),
              ),
              GestureDetector(
                onTap: () async {
                  var reviews =
                      controller.userData.value.data?.basicInfo?.reviews;
                  if (reviews != null && reviews.isNotEmpty) {
                    await Get.to(() {
                      AllReviewsPage(reviews: reviews);
                      controller.refreshData();
                    });
                  } else {
                    CustomToast().showToast(
                      context: context,
                      message: "No Reviews Yet for this Expert",
                      isSuccess: false,
                    );
                  }
                },
                child: Text(
                  "See all",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: appTheme.deepOrangeA200),
                ),
              ),
            ],
          ),
          const SizedBox(height: 19),
          Obx(() {
            var reviews = controller.userData.value.data?.basicInfo?.reviews;
            if (reviews == null || reviews.isEmpty) {
              return Text(
                "No reviews yet",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: appTheme.gray300),
              );
            }
            var limitedReviews = reviews.take(3).toList();

            return Column(
              children: limitedReviews.map((review) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(16.adaptSize),
                    decoration: BoxDecoration(
                      color: appTheme.gray100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomImageView(
                              imagePath: review.profilePic,
                              placeHolder: ImageConstant.imageNotFound,
                              height: 50.v,
                              width: 50.h,
                              radius: BorderRadius.circular(50),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.reviewer ?? "null",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(fontSize: 14.fSize),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  review.formattedDate ?? "Unknown Date",
                                  style:
                                      Theme.of(context).textTheme.titleSmall!,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (review.rating != null)
                          Row(
                            children: [
                              CustomRatingBar(
                                initialRating: review.rating!.toDouble(),
                                itemCount: 5,
                                itemSize: 22,
                                onRatingUpdate: (rating) {},
                                color: appTheme.deepYello,
                                unselectedColor: appTheme.gray300,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                review.rating.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(fontSize: 16.fSize),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        Text(
                          review.review ?? "No comments provided.",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: appTheme.gray900,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.adaptSize,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 19),
        ],
      ),
    );
  }
}
