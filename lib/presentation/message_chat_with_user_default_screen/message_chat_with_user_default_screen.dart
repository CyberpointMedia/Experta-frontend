import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_one.dart';
import 'package:experta/widgets/app_bar/appbar_title_image.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_button_one.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_image.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'controller/message_chat_with_user_default_controller.dart';

class MessageChatWithUserDefaultScreen
    extends GetWidget<MessageChatWithUserDefaultController> {
  const MessageChatWithUserDefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
          height: 56.v,
          leadingWidth: 40.h,
          leading: AppbarLeadingImage(
              imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
              margin: EdgeInsets.only(left: 16.h, top: 16.v, bottom: 16.v),
              onTap: () {
                onTapArrowLeft();
              }),
          title: Padding(
              padding: EdgeInsets.only(left: 10.h),
              child: Row(children: [
                AppbarSubtitleOne(text: "lbl_taranvir_k".tr),
                AppbarTitleImage(
                    imagePath: ImageConstant.imgVerified,
                    margin: EdgeInsets.only(left: 2.h, top: 3.v, bottom: 2.v))
              ])),
          actions: [
            AppbarTrailingButtonOne(
                margin: EdgeInsets.only(left: 12.h, top: 8.v, right: 8.h),
                onTap: () {
                  onTapThreeThousand();
                }),
            AppbarTrailingImage(
                imagePath: ImageConstant.imgVideo,
                margin: EdgeInsets.fromLTRB(20.h, 18.v, 8.h, 10.v),
                onTap: () {
                  onTapVideo();
                }),
            AppbarTrailingImage(
                imagePath: ImageConstant.imgPhoneGray900,
                margin: EdgeInsets.fromLTRB(20.h, 18.v, 24.h, 10.v),
                onTap: () {
                  onTapPhone();
                })
          ],
          styleType: Styled.bgFill_3),
      body: SizedBox(
          width: double.maxFinite,
          child: Column(children: [
            CustomElevatedButton(
                height: 24.v,
                width: 137.h,
                text: "msg_wednesday_jan_17th".tr,
                margin: EdgeInsets.only(top: 20.v),
                buttonStyle: CustomButtonStyles.fillOnPrimaryContainer,
                buttonTextStyle: CustomTextStyles.bodySmallBluegray300,
                alignment: Alignment.topCenter),
            Padding(
                padding: EdgeInsets.only(
                    left: 188.h, right: 20.h, bottom: 10.v, top: 14.v),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.h, vertical: 14.v),
                          decoration: AppDecoration.fillPrimary.copyWith(
                              borderRadius:
                                  BorderRadiusStyle.customBorderTL201),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 2.v),
                                Text("msg_hey_how_s_it_going".tr,
                                    style: CustomTextStyles.bodyLargeGray900)
                              ])),
                      SizedBox(height: 5.v),
                      Padding(
                          padding: EdgeInsets.only(left: 14.h),
                          child: _buildFrame(time: "lbl_09_32_pm".tr))
                    ])),
            Padding(
                padding: EdgeInsets.only(left: 16.h, right: 142.h),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.h, vertical: 14.v),
                          decoration: AppDecoration.fillOnPrimaryContainer
                              .copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.customBorderTL20),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 2.v),
                                Text("msg_not_much_just_chilling".tr,
                                    style: CustomTextStyles.bodyLargeGray900)
                              ])),
                      SizedBox(height: 5.v),
                      Padding(
                          padding: EdgeInsets.only(left: 14.h),
                          child: _buildFrame(time: "lbl_09_32_pm".tr))
                    ])),
            Container(
                margin: EdgeInsets.only(left: 116.h),
                padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 13.v),
                decoration: AppDecoration.fillPrimary.copyWith(
                    borderRadius: BorderRadiusStyle.customBorderTL201),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 2.v),
                      SizedBox(
                          width: 193.h,
                          child: Text("msg_same_here_anything".tr,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyles.bodyLargeGray900))
                    ])),
            SizedBox(height: 5.v),
            Padding(
                padding: EdgeInsets.only(left: 130.h),
                child: _buildFrame(time: "lbl_09_32_pm".tr)),
            SizedBox(height: 14.v),
            Container(
                width: 253.h,
                margin: EdgeInsets.only(right: 90.h),
                padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 13.v),
                decoration: AppDecoration.fillOnPrimaryContainer
                    .copyWith(borderRadius: BorderRadiusStyle.customBorderTL20),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 2.v),
                      Container(
                          width: 195.h,
                          margin: EdgeInsets.only(right: 27.h),
                          child: Text("msg_nah_just_the_usual".tr,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyles.bodyLargeGray900))
                    ])),
            SizedBox(height: 5.v),
            Padding(
                padding: EdgeInsets.only(left: 14.h),
                child: _buildFrame(time: "lbl_09_32_pm".tr)),
            Container(
                margin: EdgeInsets.only(left: 87.h),
                padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 13.v),
                decoration: AppDecoration.fillPrimary.copyWith(
                    borderRadius: BorderRadiusStyle.customBorderTL201),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 2.v),
                      SizedBox(
                          width: 224.h,
                          child: Text("msg_haha_i_feel_that".tr,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyles.bodyLargeGray900))
                    ])),
            SizedBox(height: 5.v),
            Padding(
                padding: EdgeInsets.only(left: 101.h),
                child: _buildFrame(time: "lbl_09_32_pm".tr)),
            SizedBox(height: 5.v),
            // _buildMessageChatWith(),
            const Spacer(),
            _buildNinetyNine()
          ])),
    ));
  }

  Widget _buildNinetyNine() {
    return Container(
        margin: EdgeInsets.only(bottom: 5.v),
        // decoration: AppDecoration.outlineBlack90001,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Divider(),
          Padding(
              padding: EdgeInsets.only(left: 16.h, top: 6.v, right: 16.h),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                    child: CustomTextFormField(
                        controller: controller.messageController,
                        hintText: "msg_write_a_message".tr,
                        hintStyle: CustomTextStyles.titleMediumBluegray300,
                        textInputAction: TextInputAction.done,
                        prefix: Container(
                            margin: EdgeInsets.fromLTRB(15.h, 14.v, 10.h, 14.v),
                            child: CustomImageView(
                                imagePath: ImageConstant.imgSmile,
                                height: 24.adaptSize,
                                width: 24.adaptSize)),
                        prefixConstraints: BoxConstraints(maxHeight: 52.v),
                        contentPadding: EdgeInsets.only(
                            top: 16.v, right: 30.h, bottom: 16.v),
                        borderDecoration:
                            TextFormFieldStyleHelper.outlineGrayTL26,
                        fillColor: appTheme.gray20002)),
                Padding(
                    padding: EdgeInsets.only(left: 6.h),
                    child: CustomIconButton(
                        height: 52.adaptSize,
                        width: 52.adaptSize,
                        padding: EdgeInsets.all(14.h),
                        decoration: IconButtonStyleHelper.fillPrimaryTL24,
                        child: CustomImageView(
                            imagePath:
                                ImageConstant.imgIconSolidPaperAirplane)))
              ]))
        ]));
  }

  /// Common widget
  Widget _buildFrame({required String time}) {
    return Row(children: [
      Text(time,
          style: CustomTextStyles.bodySmallBluegray300
              .copyWith(color: appTheme.blueGray300)),
      CustomImageView(
          imagePath: ImageConstant.imgDoubleCheck,
          height: 14.adaptSize,
          width: 14.adaptSize,
          margin: EdgeInsets.only(left: 4.h))
    ]);
  }

  /// Navigates to the previous screen.
  onTapArrowLeft() {
    Get.back();
  }

  /// Navigates to the settingsWalletOneScreen when the action is triggered.
  onTapThreeThousand() {
    // Get.toNamed(
    //   AppRoutes.settingsWalletOneScreen,
    // );
  }

  /// Navigates to the videoCallOneScreen when the action is triggered.
  onTapVideo() {
    // Get.toNamed(
    //   AppRoutes.videoCallOneScreen,
    // );
  }

  /// Navigates to the audioCallOneScreen when the action is triggered.
  onTapPhone() {
    // Get.toNamed(
    //   AppRoutes.audioCallOneScreen,
    // );
  }
}
