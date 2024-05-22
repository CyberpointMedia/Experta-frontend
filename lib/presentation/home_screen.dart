// ignore_for_file: must_be_immutable

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_bottom_bar.dart';
import 'package:experta/widgets/custom_search_view.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:experta/presentation/home_controller.dart';
import 'package:experta/widgets/custom_icon_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 48,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: SizedBox(
              height: 40.v,
              width: 141.adaptSize,
              child: SvgPicture.asset("assets/images/img_group_9.svg"),
            ),
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
                      color: const Color(
                    0X59FFFFFF,
                  )),
                  child: SvgPicture.asset("assets/images/img_group_11.svg"),
                ),
              ),
            )
          ],
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: appTheme.gray20002,
        body: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildStackaccentone(),
                SizedBox(
                  height: 6.v,
                ),
                _buildColumncategory(),
                SizedBox(
                  height: 31.v,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildRowtrending(
                      trending: "Trending",
                      seeallOne: "See All",
                      onPressed: () {}),
                ),
                SizedBox(
                  height: 17.v,
                ),
                _buildUserprofile(),
                SizedBox(
                  height: 30.v,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildRowtrending(
                      trending: "Models",
                      seeallOne: "See All",
                      onPressed: () {}),
                ),
                SizedBox(
                  height: 20.v,
                ),
                _buildUserprofile1(),
                SizedBox(
                  height: 30.v,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildRowtrending(
                      trending: "Athletes",
                      seeallOne: "See All",
                      onPressed: () {}),
                ),
                SizedBox(
                  height: 20.v,
                ),
                _buildUserprofile2(),
                SizedBox(
                  height: 30.v,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildRowtrending(
                      trending: "Influencers",
                      seeallOne: "See All",
                      onPressed: () {}),
                ),
                SizedBox(
                  height: 20.v,
                ),
                _buildUserprofile3(),
                SizedBox(
                  height: 30.v,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildRowtrending(
                      trending: "Movie Artist",
                      seeallOne: "See All",
                      onPressed: () {}),
                ),
                SizedBox(
                  height: 20.v,
                ),
                _buildUserprofile4(),
                SizedBox(
                  height: 30.v,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildRowtrending(
                      trending: "Doctors",
                      seeallOne: "See All",
                      onPressed: () {}),
                ),
                SizedBox(
                  height: 20.v,
                ),
                _buildUserprofile5(),
                SizedBox(
                  height: 30.v,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildRowtrending(
                      trending: "Astrologer",
                      seeallOne: "See All",
                      onPressed: () {}),
                ),
                SizedBox(
                  height: 20.v,
                ),
                _buildUserprofile6()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumnedit() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(
          0XFFFFFFFF,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: appTheme.gray30001,
          width: 1.adaptSize,
        ),
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
                      style: theme.textTheme.titleMedium!,
                    ),
                    SizedBox(
                      height: 2.v,
                    ),
                    Text(
                      "Fill in all required fields",
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontSize: 12.fSize),
                    )
                  ],
                ),
                Container(
                  width: MediaQuery.of(Get.context!).size.width * 0.3,
                  height: 36.v,
                  margin: const EdgeInsets.only(bottom: 2),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0XFFFEDC33,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      visualDensity: const VisualDensity(
                        vertical: -4,
                        horizontal: -4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 9,
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Edit Profile",
                      style: theme.textTheme.displaySmall
                          ?.copyWith(fontSize: 14.fSize),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 12.v,
          ),
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
                  value: 0.03,
                  backgroundColor: appTheme.gray20002,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    appTheme.deepOrangeA200,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStackaccentone() {
    return SizedBox(
      height: 252.v,
      width: 359.adaptSize,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: CustomSearchView(
                width: double.infinity,
                controller: controller.searchController,
                hintText: "msg_search_your_interest".tr,
              ),
            ),
          ),
          _buildColumnedit(),
        ],
      ),
    );
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
                  Get.toNamed(AppRoutes.category);
                }),
          ),
          SizedBox(
            height: 17.v,
          ),
          SizedBox(
            height: 80.v,
            child: Obx(
              () => ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    width: 15.adaptSize,
                  );
                },
                itemCount: controller
                    .homeModelObj.value.listactorsOneItemList.value.length,
                itemBuilder: (context, index) {
                  ListactorsOneItemModel model = controller
                      .homeModelObj.value.listactorsOneItemList.value[index];
                  return ListactorsOneItemWidget(
                    model,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUserprofile() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(
          () => Row(
            children: controller.homeModelObj.value.userprofileItemList.value
                .map((model) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: UserprofileItemWidget(model),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildUserprofile1() {
    return SizedBox(
      height: 220.v,
      child: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.only(left: 16),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10.adaptSize,
            );
          },
          itemCount:
              controller.homeModelObj.value.userprofile1ItemList.value.length,
          itemBuilder: (context, index) {
            Userprofile1ItemModel model =
                controller.homeModelObj.value.userprofile1ItemList.value[index];
            return Userprofile1ItemWidget(
              model,
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserprofile2() {
    return SizedBox(
      height: 220.v,
      child: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.only(left: 16),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10.adaptSize,
            );
          },
          itemCount:
              controller.homeModelObj.value.userprofile2ItemList.value.length,
          itemBuilder: (context, index) {
            Userprofile2ItemModel model =
                controller.homeModelObj.value.userprofile2ItemList.value[index];
            return Userprofile2ItemWidget(
              model,
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserprofile3() {
    return SizedBox(
      height: 220.v,
      child: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.only(left: 16),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10.adaptSize,
            );
          },
          itemCount:
              controller.homeModelObj.value.userprofile3ItemList.value.length,
          itemBuilder: (context, index) {
            Userprofile3ItemModel model =
                controller.homeModelObj.value.userprofile3ItemList.value[index];
            return Userprofile3ItemWidget(
              model,
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserprofile4() {
    return SizedBox(
      height: 220.v,
      child: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.only(left: 16),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10.adaptSize,
            );
          },
          itemCount:
              controller.homeModelObj.value.userprofile4ItemList.value.length,
          itemBuilder: (context, index) {
            Userprofile4ItemModel model =
                controller.homeModelObj.value.userprofile4ItemList.value[index];
            return Userprofile4ItemWidget(
              model,
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserprofile5() {
    return SizedBox(
      height: 220.v,
      child: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.only(left: 16),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10.adaptSize,
            );
          },
          itemCount:
              controller.homeModelObj.value.userprofile5ItemList.value.length,
          itemBuilder: (context, index) {
            Userprofile5ItemModel model =
                controller.homeModelObj.value.userprofile5ItemList.value[index];
            return Userprofile5ItemWidget(
              model,
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserprofile6() {
    return SizedBox(
      height: 220.v,
      child: Obx(
        () => ListView.separated(
          padding: const EdgeInsets.only(left: 16),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 10.adaptSize,
            );
          },
          itemCount:
              controller.homeModelObj.value.userprofile6ItemList.value.length,
          itemBuilder: (context, index) {
            Userprofile6ItemModel model =
                controller.homeModelObj.value.userprofile6ItemList.value[index];
            return Userprofile6ItemWidget(
              model,
            );
          },
        ),
      ),
    );
  }

  Widget _buildRowtrending(
      {required String trending,
      required String seeallOne,
      required Function onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          trending,
          style: theme.textTheme.titleLarge!,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: TextButton(
              onPressed: () {
                onPressed();
              },
              child: Text(
                seeallOne,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: appTheme.deepOrangeA200),
              )),
        )
      ],
    );
  }
}

class ListactorsOneItemWidget extends StatelessWidget {
  ListactorsOneItemWidget(this.listactorsOneItemModelObj, {super.key});

  ListactorsOneItemModel listactorsOneItemModelObj;

  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(
          0XFFFFFFFF,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(
              0X0C000000,
            ),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(
              0,
              30,
            ),
          )
        ],
      ),
      width: 80.adaptSize,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => SizedBox(
              height: 30.v,
              width: 30.adaptSize,
              child:
                  SvgPicture.asset(listactorsOneItemModelObj.actorsone!.value),
            ),
          ),
          SizedBox(
            height: 5.v,
          ),
          Obx(
            () => Text(
              listactorsOneItemModelObj.actorstwo!.value,
              style:
                  theme.textTheme.headlineLarge?.copyWith(fontSize: 10.fSize),
            ),
          )
        ],
      ),
    );
  }
}

class Userprofile1ItemWidget extends StatelessWidget {
  Userprofile1ItemWidget(this.userprofile1ItemModelObj, {super.key});

  Userprofile1ItemModel userprofile1ItemModelObj;

  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
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
              child: Obx(
                () => Image.asset(
                  userprofile1ItemModelObj.onlineImage!.value,
                  height: 220.v,
                  width: 156.adaptSize,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 37,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44.adaptSize,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
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
                                color: appTheme.green400,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofile1ItemModelObj.onlineText!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 33.adaptSize,
                        margin: const EdgeInsets.only(left: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: SizedBox(
                                height: 10.v,
                                width: 10.adaptSize,
                                child: SvgPicture.asset(
                                    "assets/images/img_star.svg"),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofile1ItemModelObj.ratingText!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 126.v,
                  ),
                  Obx(
                    () => Text(
                      userprofile1ItemModelObj.usernameText!.value,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontSize: 16.fSize),
                    ),
                  ),
                  SizedBox(
                    height: 2.v,
                  ),
                  Obx(
                    () => Text(
                      userprofile1ItemModelObj.roleText!.value,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(
                          0XFFFFFFFF,
                        ),
                        fontSize: 11.fSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6.v,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 14.v,
                        width: 14.adaptSize,
                        child:
                            SvgPicture.asset("assets/images/img_layer_1.svg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "2000",
                                style: theme.textTheme.labelLarge!,
                              ),
                              TextSpan(
                                text: "/min",
                                style: theme.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Userprofile2ItemWidget extends StatelessWidget {
  Userprofile2ItemWidget(this.userprofile2ItemModelObj, {super.key});

  Userprofile2ItemModel userprofile2ItemModelObj;

  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
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
              child: Obx(
                () => Image.asset(
                  userprofile2ItemModelObj.onlineStatusIma!.value,
                  height: 220.v,
                  width: 156.adaptSize,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 37,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44.adaptSize,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
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
                                color: appTheme.green400,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofile2ItemModelObj.onlineStatusTex!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 33.adaptSize,
                        margin: const EdgeInsets.only(left: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: SizedBox(
                                height: 10.v,
                                width: 10.adaptSize,
                                child: SvgPicture.asset(
                                    "assets/images/img_star.svg"),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofile2ItemModelObj.ratingText!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 126.v,
                  ),
                  Obx(
                    () => Text(
                      userprofile2ItemModelObj.usernameText!.value,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontSize: 16.fSize),
                    ),
                  ),
                  SizedBox(
                    height: 2.v,
                  ),
                  Obx(
                    () => Text(
                      userprofile2ItemModelObj.userRoleText!.value,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(
                          0XFFFFFFFF,
                        ),
                        fontSize: 11.fSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6.v,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 14.v,
                        width: 14.adaptSize,
                        child:
                            SvgPicture.asset("assets/images/img_layer_1.svg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "2000",
                                style: theme.textTheme.labelLarge!,
                              ),
                              TextSpan(
                                text: "/min",
                                style: theme.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Userprofile3ItemWidget extends StatelessWidget {
  Userprofile3ItemWidget(this.userprofile3ItemModelObj, {super.key});

  Userprofile3ItemModel userprofile3ItemModelObj;

  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
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
              child: Obx(
                () => Image.asset(
                  userprofile3ItemModelObj.onlineStatusIma!.value,
                  height: 220.v,
                  width: 156.adaptSize,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 37,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44.adaptSize,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
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
                                color: appTheme.green400,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofile3ItemModelObj.onlineStatusTex!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 33.adaptSize,
                        margin: const EdgeInsets.only(left: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: SizedBox(
                                height: 10.v,
                                width: 10.adaptSize,
                                child: SvgPicture.asset(
                                    "assets/images/img_star.svg"),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofile3ItemModelObj.ratingText!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 126.v,
                  ),
                  Obx(
                    () => Text(
                      userprofile3ItemModelObj.usernameText!.value,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontSize: 16.fSize),
                    ),
                  ),
                  SizedBox(
                    height: 2.v,
                  ),
                  Obx(
                    () => Text(
                      userprofile3ItemModelObj.userRoleText!.value,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(
                          0XFFFFFFFF,
                        ),
                        fontSize: 11.fSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6.v,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 14.v,
                        width: 14.adaptSize,
                        child:
                            SvgPicture.asset("assets/images/img_layer_1.svg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "2000",
                                style: theme.textTheme.labelLarge!,
                              ),
                              TextSpan(
                                text: "/min",
                                style: theme.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Userprofile4ItemWidget extends StatelessWidget {
  Userprofile4ItemWidget(this.userprofile4ItemModelObj, {super.key});

  Userprofile4ItemModel userprofile4ItemModelObj;

  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
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
              child: Obx(
                () => Image.asset(
                  userprofile4ItemModelObj.onlineImage!.value,
                  height: 220.v,
                  width: 156.adaptSize,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 37,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44.adaptSize,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
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
                                color: appTheme.green400,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofile4ItemModelObj.onlineText!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 33.adaptSize,
                        margin: const EdgeInsets.only(left: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: SizedBox(
                                height: 10.v,
                                width: 10.adaptSize,
                                child: SvgPicture.asset(
                                    "assets/images/img_star.svg"),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofile4ItemModelObj.ratingText!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 126.v,
                  ),
                  Obx(
                    () => Text(
                      userprofile4ItemModelObj.usernameText!.value,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontSize: 16.fSize),
                    ),
                  ),
                  SizedBox(
                    height: 2.v,
                  ),
                  Obx(
                    () => Text(
                      userprofile4ItemModelObj.roleText!.value,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(
                          0XFFFFFFFF,
                        ),
                        fontSize: 11.fSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6.v,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 14.v,
                        width: 14.adaptSize,
                        child:
                            SvgPicture.asset("assets/images/img_layer_1.svg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "2000",
                                style: theme.textTheme.labelLarge!,
                              ),
                              TextSpan(
                                text: "/min",
                                style: theme.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Userprofile5ItemWidget extends StatelessWidget {
  Userprofile5ItemWidget(this.userprofile5ItemModelObj, {super.key});

  Userprofile5ItemModel userprofile5ItemModelObj;

  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
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
              child: Obx(
                () => Image.asset(
                  userprofile5ItemModelObj.onlineImage!.value,
                  height: 220.v,
                  width: 156.adaptSize,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 37,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44.adaptSize,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
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
                                color: appTheme.green400,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofile5ItemModelObj.onlineText!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 33.adaptSize,
                        margin: const EdgeInsets.only(left: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: SizedBox(
                                height: 10.v,
                                width: 10.adaptSize,
                                child: SvgPicture.asset(
                                    "assets/images/img_star.svg"),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofile5ItemModelObj.ratingText!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 126.v,
                  ),
                  Obx(
                    () => Text(
                      userprofile5ItemModelObj.usernameText!.value,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontSize: 16.fSize),
                    ),
                  ),
                  SizedBox(
                    height: 2.v,
                  ),
                  Obx(
                    () => Text(
                      userprofile5ItemModelObj.roleText!.value,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(
                          0XFFFFFFFF,
                        ),
                        fontSize: 11.fSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6.v,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 14.v,
                        width: 14.adaptSize,
                        child:
                            SvgPicture.asset("assets/images/img_layer_1.svg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "2000",
                                style: theme.textTheme.labelLarge!,
                              ),
                              TextSpan(
                                text: "/min",
                                style: theme.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Userprofile6ItemWidget extends StatelessWidget {
  Userprofile6ItemWidget(this.userprofile6ItemModelObj, {super.key});

  Userprofile6ItemModel userprofile6ItemModelObj;

  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
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
              child: Obx(
                () => Image.asset(
                  userprofile6ItemModelObj.onlineStatusIma!.value,
                  height: 220.v,
                  width: 156.adaptSize,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 37,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44.adaptSize,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
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
                                color: appTheme.green400,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofile6ItemModelObj.onlineStatusTex!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 33.adaptSize,
                        margin: const EdgeInsets.only(left: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: SizedBox(
                                height: 10.v,
                                width: 10.adaptSize,
                                child: SvgPicture.asset(
                                    "assets/images/img_star.svg"),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofile6ItemModelObj.ratingText!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 126.v,
                  ),
                  Obx(
                    () => Text(
                      userprofile6ItemModelObj.usernameText!.value,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(fontSize: 16.fSize),
                    ),
                  ),
                  SizedBox(
                    height: 2.v,
                  ),
                  Obx(
                    () => Text(
                      userprofile6ItemModelObj.userRoleText!.value,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(
                          0XFFFFFFFF,
                        ),
                        fontSize: 11.fSize,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6.v,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 14.v,
                        width: 14.adaptSize,
                        child:
                            SvgPicture.asset("assets/images/img_layer_1.svg"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "2000",
                                style: theme.textTheme.labelLarge!,
                              ),
                              TextSpan(
                                text: "/min",
                                style: theme.textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UserprofileItemWidget extends StatelessWidget {
  UserprofileItemWidget(this.userprofileItemModelObj, {super.key});

  UserprofileItemModel userprofileItemModelObj;

  var controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.v,
      width: 156.adaptSize,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Obx(
                () => Image.asset(
                  userprofileItemModelObj.onlineStatusIma!.value,
                  height: 220.v,
                  width: 156.adaptSize,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 44.adaptSize,
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
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
                                color: appTheme.green400,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofileItemModelObj.onlineStatusTex!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 33.adaptSize,
                        margin: const EdgeInsets.only(left: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0X4C171717,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: SizedBox(
                                height: 10.v,
                                width: 10.adaptSize,
                                child: SvgPicture.asset(
                                    "assets/images/img_star.svg"),
                              ),
                            ),
                            Obx(
                              () => Text(
                                userprofileItemModelObj.ratingText!.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(
                                  0XFFFFFFFF,
                                )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 114.v,
                ),
                Container(
                  width: 156.adaptSize,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(24)),
                    gradient: LinearGradient(
                      begin: Alignment(
                        0.5,
                        0,
                      ),
                      end: Alignment(
                        0.5,
                        0.79,
                      ),
                      colors: [
                        Color(
                          0X00000000,
                        ),
                        Color(
                          0X99000000,
                        )
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 2.v,
                      ),
                      Obx(
                        () => Text(
                          userprofileItemModelObj.usernameText!.value,
                          style: theme.textTheme.labelLarge
                              ?.copyWith(fontSize: 16.fSize),
                        ),
                      ),
                      Obx(
                        () => Text(
                          userprofileItemModelObj.userRoleText!.value,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(
                              0XFFFFFFFF,
                            ),
                            fontSize: 11.fSize,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.v,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: SizedBox(
                              height: 14.v,
                              width: 14.adaptSize,
                              child: SvgPicture.asset(
                                  "assets/images/img_layer_1.svg"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "2000",
                                    style: theme.textTheme.labelLarge!,
                                  ),
                                  TextSpan(
                                    text: "/min",
                                    style: theme.textTheme.labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
