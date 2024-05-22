import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_iconbutton.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:experta/widgets/custom_search_view.dart';

import 'widgets/anjaliarora_item_widget.dart';
import 'models/anjaliarora_item_model.dart';
import 'widgets/anjaliarora1_item_widget.dart';
import 'models/anjaliarora1_item_model.dart';
import 'package:flutter/material.dart';
import 'controller/message_controller.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  MessageController controller = Get.put(MessageController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          centerTitle: true,
          height: 48.v,
          title: AppbarSubtitle(
              text: "lbl_inbox".tr, margin: EdgeInsets.only(left: 15.h)),
          actions: [
            AppbarTrailingIconbutton(
                imagePath: ImageConstant.imgBell02,
                margin: EdgeInsets.symmetric(horizontal: 16.h),
                onTap: () {
                  onTapBellTwo();
                })
          ]),
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
          SizedBox(
              width: double.maxFinite,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 25.v),
                        child: CustomSearchView(
                          width: 343.h,
                          controller: controller.searchController,
                          hintText: "lbl_search".tr,
                        )),
                    SizedBox(height: 29.v),
                    SizedBox(
                        height: 100.v,
                        child: Obx(() => ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) {
                              return SizedBox(width: 20.h);
                            },
                            itemCount: controller.messageModelObj.value
                                .anjaliaroraItemList.value.length,
                            itemBuilder: (context, index) {
                              AnjaliaroraItemModel model = controller
                                  .messageModelObj
                                  .value
                                  .anjaliaroraItemList
                                  .value[index];
                              return AnjaliaroraItemWidget(model);
                            }))),
                    SizedBox(height: 9.v),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.h),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("lbl_recent_messages".tr,
                                          style:
                                              CustomTextStyles.titleMediumBold),
                                      SizedBox(height: 17.v),
                                      _buildAnjaliArora(),
                                      SizedBox(height: 10.v),
                                      _buildFrame()
                                    ]))))
                  ])),
        ],
      ),
    ));
  }

  Widget _buildAnjaliArora() {
    return Obx(() => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: 20.v);
        },
        itemCount:
            controller.messageModelObj.value.anjaliarora1ItemList.value.length,
        itemBuilder: (context, index) {
          Anjaliarora1ItemModel model = controller
              .messageModelObj.value.anjaliarora1ItemList.value[index];
          return Anjaliarora1ItemWidget(model, onTapFrame: () {
            onTapFrame();
          });
        }));
  }

  Widget _buildFrame() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CustomImageView(
          imagePath: ImageConstant.imgEllipse134,
          height: 58.adaptSize,
          width: 58.adaptSize,
          radius: BorderRadius.circular(29.h)),
      Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 15.h, top: 4.v, bottom: 7.v),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 270.h,
                        child: Row(children: [
                          Text("lbl_aachal_sharma".tr,
                              style: CustomTextStyles.titleMediumSemiBold),
                          CustomImageView(
                              imagePath: ImageConstant.imgVerified,
                              height: 16.adaptSize,
                              width: 16.adaptSize,
                              margin: EdgeInsets.only(
                                  left: 2.h, top: 2.v, bottom: 2.v)),
                          Spacer(),
                          Text("lbl_yesterday".tr,
                              textAlign: TextAlign.right,
                              style: CustomTextStyles.bodyMediumLight)
                        ])),
                    SizedBox(height: 6.v),
                    Text("msg_you_can_you_sent2".tr,
                        style: theme.textTheme.bodyLarge)
                  ])))
    ]);
  }

  onTapArrowLeft() {
    Get.back();
  }

  /// Navigates to the notificationScreen when the action is triggered.
  onTapBellTwo() {
    Get.toNamed(
      AppRoutes.notification,
    );
  }

  /// Navigates to the messageChatWithUserDefaultScreen when the action is triggered.
  onTapFrame() {
    Get.toNamed(
      AppRoutes.messageChatWithUserDefaultScreen,
    );
  }
}
