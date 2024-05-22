import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/app_bar/appbar_title.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
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
          Column(
            children: [
              _profilepicBody(),
              _ratingSection(),
              _tabBarControl(),
            ],
          )
        ],
      ),
    );
  }

  Widget _tabBarControl() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 45,
              decoration: const BoxDecoration(
                color: Colors.white70,
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(
                    text: 'About Me',
                  ),
                  Tab(
                    text: 'Posts',
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  Center(
                    child: Text(
                      'Place Bid',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
              height: 100.v,
              width: 100.v,
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
// chat.svg

PreferredSizeWidget _buildAppBar(BuildContext context) {
  return CustomAppBar(
    height: 40.v,
    centerTitle: false,
    title: AppbarTitle(
      text: "Ajit Singh",
      margin: const EdgeInsets.only(left: 50),
    ),
    actions: [
      CustomImageView(
        margin: const EdgeInsets.all(8),
        imagePath: "assets/images/more-horizontal.svg",
      )
    ],
  );
}
