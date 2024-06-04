import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/userProfile/controller/profile_controller.dart';
import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  Iphone1415ProMaxOneController controller =
      Get.put(Iphone1415ProMaxOneController());
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
                    expandedHeight: 400.0,
                    backgroundColor: Colors.white,
                    primary: true,
                    title: const Text(
                      "anjali_arora_11",
                    ),
                    actions: [
                      CustomImageView(
                        margin: const EdgeInsets.all(8),
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
                          const SizedBox(height: 50),
                          _profilepicBody(),
                          _ratingSection(),
                        ],
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(48.0),
                      child: Material(
                        // color: Colors.white,
                        child: TabBar(
                          controller: _tabController,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorSize: TabBarIndicatorSize.tab,
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
            height: 88.v,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(bottom: 610),
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 27,
                        right: 17,
                      ),
                      child: _buildRowaboutme(aboutMeText: "Expertise"),
                    ),
                    SizedBox(
                      height: 17.v,
                    ),
                    _buildChipviewvisual(),
                    SizedBox(
                      height: 28.v,
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
    return const Center(
      child: Text(
        'Buy Now',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildChipviewvisual() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 27),
        child: Obx(
          () => Wrap(
            runSpacing: 6.43,
            spacing: 6.43,
            children: List<Widget>.generate(
              controller.iphone1415ProMaxOneModelObj.value
                  .chipviewvisualItemList.value.length,
              (index) {
                ChipviewvisualItemModel model = controller
                    .iphone1415ProMaxOneModelObj
                    .value
                    .chipviewvisualItemList
                    .value[index];
                return ChipviewvisualItemWidget(
                  model,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget

  Widget _buildColumnaboutme() {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 18,
      ),
      decoration: const BoxDecoration(
        color: Color(
          0XFFFFFFFF,
        ),
      ),
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
            child: ReadMoreText(
              "Hey there! I'm Taranvir Kaur, your go-to source for all things positive vibes and adventure! 🚀 Join me on this journey as we explore...",
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
            ),
          ),
          SizedBox(
            height: 17.v,
          ),
          Row(
            children: [
              CustomIconButton(
                height: 24.v,
                width: 25.adaptSize,
                decoration: BoxDecoration(
                  color: appTheme.gray900,
                ),
                child: SvgPicture.asset('assets/images/img_vector.svg'),
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  height: 24.v,
                  width: 25.adaptSize,
                  child:
                      SvgPicture.asset("assets/images/img_linkedin_icon_1.svg"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CustomIconButton(
                  height: 24.v,
                  width: 25.adaptSize,
                  child:
                      SvgPicture.asset('assets/images/img_linkedin_icon_2.svg'),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CustomIconButton(
                  height: 24.v,
                  width: 25.adaptSize,
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset('assets/images/img_twitter_1.svg'),
                  onTap: () {},
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// Section Widget

  Widget _buildColumnexperienc() {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 19,
      ),
      decoration: const BoxDecoration(
        color: Color(
          0XFFFFFFFF,
        ),
      ),
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
          Text(
            "Lead UI/UX consultant",
            style: theme.textTheme.titleMedium!,
          ),
          SizedBox(
            height: 9.v,
          ),
          Text(
            "Daiki Media | Digital Marketing That Drives Results",
            style:
                theme.textTheme.bodyMedium?.copyWith(color: appTheme.gray900),
          ),
          SizedBox(
            height: 5.v,
          ),
          Text(
            "Jan 2020 - Present · 4 yrs 3 mos",
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
          Text(
            "Lead UI/UX Designer",
            style: theme.textTheme.titleMedium!,
          ),
          SizedBox(
            height: 9.v,
          ),
          Text(
            "BabelFish Money Protocol",
            style: theme.textTheme.displaySmall?.copyWith(fontSize: 14.fSize),
          ),
          SizedBox(
            height: 5.v,
          ),
          Text(
            "Jan 2020 - Present · 4 yrs 3 mos",
            style: theme.textTheme.bodyMedium!,
          )
        ],
      ),
    );
  }

  /// Section Widget

  Widget _buildColumneducation() {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 19,
      ),
      decoration: const BoxDecoration(
        color: Color(
          0XFFFFFFFF,
        ),
      ),
      child: Column(
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
          Text(
            "Bachelor of Technology (B.Tech.)",
            style: theme.textTheme.titleMedium!,
          ),
          SizedBox(
            height: 9.v,
          ),
          Text(
            "Mangalam college of Engineering",
            style:
                theme.textTheme.bodyMedium?.copyWith(color: appTheme.gray900),
          ),
          SizedBox(
            height: 4.v,
          ),
          Text(
            "2013 - 2017",
            style: theme.textTheme.bodyMedium!,
          )
        ],
      ),
    );
  }

  /// Section Widget

  Widget _buildColumnachieveme() {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.all(17),
      decoration: const BoxDecoration(
        color: Color(
          0XFFFFFFFF,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowaboutme(aboutMeText: "Achievements"),
          SizedBox(
            height: 17.v,
          ),
          Row(
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
                  "The American Influencer Awards",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: appTheme.gray900,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 9.v,
          ),
          Row(
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
                  "Entertainer of the year",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: appTheme.gray900,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 9.v,
          ),
          Row(
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
                  "Celebrity Influencer of the Year",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: appTheme.gray900,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// Section Widget

  Widget _buildColumnintereste() {
    return Container(
        // decoration: const BoxDecoration(
        //   color: Color(
        //     0XFFFFFFFF,
        //   ),
        // ),
        child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interested',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 8.0, // spacing between chips
          runSpacing: 4.0, // spacing between lines
          children: [
            Chip(
              // avatar: CircleAvatar(
              //   backgroundImage: AssetImage(
              //       'assets/images/dancing.png'), // Replace with your image path
              // ),
              label: Text(
                '💃🏻Dancing & Singing',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Chip(
              // avatar: CircleAvatar(
              //   backgroundImage: AssetImage(
              //       'assets/images/travel.png'), // Replace with your image path
              // ),
              label: Text(
                '💃🏻Travel & Places',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Chip(
                // avatar: CircleAvatar(
                //   backgroundImage: AssetImage(
                //       'assets/images/fashion.png'), // Replace with your image path
                // ),
                label: Text(
              '💃🏻Fashion',
              style: TextStyle(color: Colors.black),
            )),
            Chip(
                // avatar: CircleAvatar(
                //   backgroundImage: AssetImage(
                //       'assets/images/painting.png'), // Replace with your image path
                // ),
                label: Text(
              '💃🏻Painting',
              style: TextStyle(color: Colors.black),
            )),
            Chip(
                // avatar: CircleAvatar(
                //   backgroundImage: AssetImage(
                //       'assets/images/movie.png'), // Replace with your image path
                // ),
                label: Text(
              '💃🏻 Movie',
              style: TextStyle(color: Colors.black),
            )),
          ],
        ),
      ],
    ));
  }

  /// Section Widget

  Widget _buildColumnreviews() {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 17,
        vertical: 19,
      ),
      decoration: const BoxDecoration(
        color: Color(
          0XFFFFFFFF,
        ),
      ),
      child: Column(
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
          Container(
            width: 367.adaptSize,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(
                0XFFF9F9F9,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
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
                            "Lexie",
                            style: theme.textTheme.headlineLarge
                                ?.copyWith(fontSize: 14.fSize),
                          ),
                          SizedBox(
                            height: 1.v,
                          ),
                          Text(
                            "4 days ago",
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
                      initialRating: 0,
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
                        "4.9",
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
                    "Had an excellent call with Austin. He gave me a lot of ideas to test to improve my content. As a res",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: appTheme.gray900),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 19.v,
          )
        ],
      ),
    );
  }

  /// Common widget

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
        SizedBox(
          height: 24.v,
          width: 25.adaptSize,
          child: SvgPicture.asset("assets/images/img_frame.svg"),
        )
      ],
    );
  }

  /// Common widget

  Widget _buildRoweducation({required String educationText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          educationText,
          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 16.fSize),
        ),
        SizedBox(
          height: 19.v,
          width: 21.adaptSize,
          child: SvgPicture.asset("assets/images/img_vector_ff95a4b7.svg"),
        )
      ],
    );
  }
}

Widget _ratingSection() {
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
                        "5.0",
                        style: theme.textTheme.headlineLarge
                            ?.copyWith(fontSize: 18.fSize),
                      ),
                    )
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
            _buildColumnFourHundredFifty(
              dynamicText: "450",
              dynamicText1: "Followers",
            ),
            const Spacer(
              flex: 58,
            ),
            _buildColumnFourHundredFifty(
              dynamicText: "480",
              dynamicText1: "Following",
            )
          ],
        ),
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
          onPressed: () {},
        )
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
              // fit: BoxFit.cover,
              imagePath: "assets/images/img_rectangle_2_2.png",
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
                      Text("lbl_anjali_arora".tr,
                          textAlign: TextAlign.left,
                          style: CustomTextStyles.titleLargeSemiBold),
                      CustomImageView(
                        margin: EdgeInsets.only(left: 5.v),
                        imagePath: "assets/images/veifiedtick.svg",
                      )
                    ],
                  ),
                  Text(
                    "UI/UX Designer | Graphic Designer",
                    textAlign: TextAlign.left,
                    style: CustomTextStyles.bodyMediumBlack90001,
                  )
                ],
              ),
            ),
          )
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
            Text("English, Hindi, Punjabi",
                textAlign: TextAlign.left,
                style: CustomTextStyles.bodyLargeBlack90001),
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
              Text("Reg no: G0100",
                  textAlign: TextAlign.left,
                  style: CustomTextStyles.bodyLargeBlack90001),
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
              Text("587",
                  textAlign: TextAlign.left,
                  style: CustomTextStyles.titleMediumBold),
              SizedBox(
                width: 5.v,
              ),
              Text("Consultation",
                  textAlign: TextAlign.left,
                  style: CustomTextStyles.bodyLargeBlack90001),
            ],
          ))
    ],
  );
}

// ignore: must_be_immutable
// ignore_for_file: must_be_immutable
// ignore_for_file: must_be_immutable

class ChipviewdancingItemWidget extends StatelessWidget {
  ChipviewdancingItemWidget(this.chipviewdancingItemModelObj, {Key? key})
      : super(key: key);

  ChipviewdancingItemModel chipviewdancingItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RawChip(
        padding: const EdgeInsets.symmetric(
          horizontal: 21,
          vertical: 13,
        ),
        showCheckmark: false,
        labelPadding: EdgeInsets.zero,
        label: Text(
          chipviewdancingItemModelObj.dancingsinging!.value,
          style: theme.textTheme.titleMedium!,
        ),
        selected: (chipviewdancingItemModelObj.isSelected?.value ?? false),
        backgroundColor: const Color(
          0XFFFFFFFF,
        ),
        selectedColor: const Color(
          0XFFFFFFFF,
        ),
        shape: (chipviewdancingItemModelObj.isSelected?.value ?? false)
            ? RoundedRectangleBorder(
                side: BorderSide(
                  color: const Color(
                    0X99FFFFFF,
                  ),
                  width: 1.adaptSize,
                ),
                borderRadius: BorderRadius.circular(23),
              )
            : RoundedRectangleBorder(
                side: const BorderSide(
                  color: Color(
                    0XFFE4E4E4,
                  ),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(23),
              ),
        onSelected: (value) {
          chipviewdancingItemModelObj.isSelected!.value = value;
        },
      ),
    );
  }
}

// ignore: must_be_immutable
// ignore_for_file: must_be_immutable
// ignore_for_file: must_be_immutable

class ChipviewvisualItemWidget extends StatelessWidget {
  ChipviewvisualItemWidget(this.chipviewvisualItemModelObj, {Key? key})
      : super(key: key);

  ChipviewvisualItemModel chipviewvisualItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RawChip(
        padding: const EdgeInsets.symmetric(
          horizontal: 19,
          vertical: 10,
        ),
        showCheckmark: false,
        labelPadding: EdgeInsets.zero,
        label: Text(
          chipviewvisualItemModelObj.visualDesign!.value,
          style: theme.textTheme.bodyLarge?.copyWith(color: appTheme.gray900),
        ),
        selected: (chipviewvisualItemModelObj.isSelected?.value ?? false),
        backgroundColor: appTheme.gray20002,
        selectedColor: appTheme.gray20002,
        shape: (chipviewvisualItemModelObj.isSelected?.value ?? false)
            ? RoundedRectangleBorder(
                side: BorderSide(
                  color: const Color(
                    0X99EFEFEF,
                  ),
                  width: 1.adaptSize,
                ),
                borderRadius: BorderRadius.circular(20),
              )
            : RoundedRectangleBorder(
                side: const BorderSide(
                  color: Color(
                    0XFFE4E4E4,
                  ),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
        onSelected: (value) {
          chipviewvisualItemModelObj.isSelected!.value = value;
        },
      ),
    );
  }
}
