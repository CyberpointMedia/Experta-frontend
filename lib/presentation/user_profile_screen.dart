import 'package:experta/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:experta/presentation/user_profile_controller.dart';
import 'package:experta/widgets/custom_elevated_button.dart';

// ignore_for_file: must_be_immutable

class UserProfileScreen extends GetWidget<UserProfileController> {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray20002,
        body: SizedBox(
          width: 375.adaptSize,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildStackArrowLeft(),
                SizedBox(
                  height: 8.v,
                ),
                SizedBox(
                  height: 550.v,
                  width: 375.adaptSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [_buildRowAboutMe(), _buildGridUserProfile()],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget

  Widget _buildStackArrowLeft() {
    return SizedBox(
      height: 356.v,
      width: 375.adaptSize,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(
                  0XFFFFFFFF,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: SizedBox(
                          height: 24.v,
                          width: 24.adaptSize,
                          child: SvgPicture.asset(
                              "assets/images/img_arrow_left.svg"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "taran_kaur01",
                          style: theme.textTheme.titleLarge!,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 22.v,
                  ),
                  Row(
                    children: [
                      Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 0,
                        margin: const EdgeInsets.all(0),
                        color: const Color(
                          0XFFFFFFFF,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48),
                        ),
                        child: Container(
                          height: 96.v,
                          width: 96.adaptSize,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color(
                              0XFFFFFFFF,
                            ),
                            borderRadius: BorderRadius.circular(48),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(45),
                                  child: Image.asset(
                                    "assets/images/img_rectangle_2.png",
                                    height: 90.v,
                                    width: 90.adaptSize,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(45),
                                  child: Image.asset(
                                    "assets/images/img_rectangle_3.png",
                                    height: 90.v,
                                    width: 90.adaptSize,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 87.adaptSize,
                        margin: const EdgeInsets.only(
                          left: 21,
                          top: 72,
                          bottom: 5,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/img_frame_1171276710.png",
                              height: 18.v,
                              width: 18.adaptSize,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "Top Rated",
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: appTheme.gray900),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 24.v,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 18.v,
                        width: 18.adaptSize,
                        child: SvgPicture.asset(
                            "assets/images/img_language_1.svg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "English, Hindi, Punjabi ",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: appTheme.gray900),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 9.v,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 18.v,
                        width: 18.adaptSize,
                        child: SvgPicture.asset(
                            "assets/images/img_verified_1.svg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Reg no: ",
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: appTheme.gray900),
                              ),
                              TextSpan(
                                text: "G0100",
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(color: appTheme.gray900),
                              )
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        height: 12.v,
                        width: 1.adaptSize,
                        margin: const EdgeInsets.only(
                          left: 10,
                          top: 3,
                          bottom: 3,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.blueGray300,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          height: 18.v,
                          width: 18.adaptSize,
                          child: SvgPicture.asset(
                              "assets/images/img_chat_1_1.svg"),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 38.v,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 30,
                      ),
                      child: Row(
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
                                      child: SvgPicture.asset(
                                          "assets/images/img_star.svg"),
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
                          Expanded(
                            child: _buildColumnFourHundredFifty(
                              dynamicText: "450",
                              dynamicText1: "Followers",
                            ),
                          ),
                          const Spacer(
                            flex: 58,
                          ),
                          Expanded(
                            child: _buildColumnFourHundredFifty(
                              dynamicText: "450",
                              dynamicText1: "Following",
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 23.v,
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.only(left: 221),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(
                  0X3FFFCA9A,
                ),
                borderRadius: BorderRadius.circular(126),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(Get.context!).size.width,
                            height: 36.v,
                            child: CustomElevatedButton(
                              text: "Follow",
                              onPressed: () {},
                              buttonStyle: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0X66000000,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              buttonTextStyle:
                                  theme.textTheme.titleMedium?.copyWith(
                                      color: const Color(
                                0XFFFFFFFF,
                              )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: SizedBox(
                              height: 24.v,
                              width: 24.adaptSize,
                              child: SvgPicture.asset(
                                  "assets/images/img_more_horizontal.svg"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 31.v,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: SizedBox(
                      height: 22.v,
                      width: 22.adaptSize,
                      child: SvgPicture.asset(
                          "assets/images/img_group_1000004594.svg"),
                    ),
                  ),
                  SizedBox(
                    height: 31.v,
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 111,
                right: 39,
              ),
              child: Text(
                "UI/UX Designer | Graphic Designer",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: appTheme.gray900),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 74),
              child: Text(
                "Taranvir Kaur",
                style:
                    theme.textTheme.headlineLarge?.copyWith(fontSize: 22.fSize),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 90,
                bottom: 124,
              ),
              child: Text(
                "587 Consultation  ",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: appTheme.gray900),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget

  Widget _buildRowAboutMe() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(
          top: 19,
          bottom: 490,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "About Me",
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 15,
                bottom: 20,
              ),
              child: Text(
                "Posts",
                style: theme.textTheme.titleMedium!,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget

  Widget _buildGridUserProfile() {
    return Align(
      alignment: Alignment.center,
      child: Obx(
        () => GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 282,
            crossAxisCount: 1,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller
              .userProfileModelObj.value.griduserprofileItemList.value.length,
          itemBuilder: (context, index) {
            GriduserprofileItemModel model = controller
                .userProfileModelObj.value.griduserprofileItemList.value[index];
            return GriduserprofileItemWidget(
              model,
            );
          },
        ),
      ),
    );
  }

  /// Common widget

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
}

// ignore: must_be_immutable
// ignore_for_file: must_be_immutable
// ignore_for_file: must_be_immutable

class GriduserprofileItemWidget extends StatelessWidget {
  GriduserprofileItemWidget(this.griduserprofileItemModelObj, {Key? key})
      : super(key: key);

  GriduserprofileItemModel griduserprofileItemModelObj;

  var controller = Get.find<UserProfileController>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 281.v,
        width: 375.adaptSize,
        decoration: const BoxDecoration(
          color: Color(
            0XFFFFFFFF,
          ),
        ),
      ),
    );
  }
}
