import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_icon_button.dart';

import 'widgets/feedsactive_item_widget.dart';
import 'models/feedsactive_item_model.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'controller/feeds_active_controller.dart';

class FeedsActiveScreen extends StatefulWidget {
  const FeedsActiveScreen({super.key});

  @override
  State<FeedsActiveScreen> createState() => _FeedsActiveScreenState();
}

class _FeedsActiveScreenState extends State<FeedsActiveScreen> {
  FeedsActiveController controller = Get.put(FeedsActiveController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("lbl_feeds".tr, style: theme.textTheme.titleLarge),
        leading: CustomImageView(
            imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
            margin: const EdgeInsets.all(15),
            onTap: () {
              onTapImgArrowLeft();
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlineGradientButton(
                padding: EdgeInsets.only(
                    left: 1.h, top: 1.v, right: 1.h, bottom: 1.v),
                strokeWidth: 1.h,
                gradient: LinearGradient(
                    begin: const Alignment(0.09, -0.08),
                    end: const Alignment(0.75, 1.1),
                    colors: [
                      theme.colorScheme.onPrimaryContainer.withOpacity(1),
                      theme.colorScheme.onPrimaryContainer.withOpacity(0),
                      theme.colorScheme.onPrimaryContainer.withOpacity(1)
                    ]),
                corners: const Corners(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                child: CustomIconButton(
                    height: 40.adaptSize,
                    width: 40.adaptSize,
                    padding: EdgeInsets.all(8.h),
                    decoration: IconButtonStyleHelper.outline,
                    onTap: () {
                      onTapBtnBellTwo();
                    },
                    child:
                        CustomImageView(imagePath: ImageConstant.imgBell02))),
          )
        ],
      ),
      body: Stack(alignment: Alignment.bottomCenter, children: [
        Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomImageView(
                            imagePath: ImageConstant.imgPlay,
                            height: 48.adaptSize,
                            width: 48.adaptSize),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 10.h, top: 15.v, bottom: 10.v),
                            child: Text("lbl_anjali_arora".tr,
                                style: CustomTextStyles.titleMediumSemiBold)),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 2.h, top: 19.v, bottom: 13.v),
                            child: Text("lbl2".tr,
                                style: CustomTextStyles.bodySmallBluegray300)),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 2.h, top: 19.v, bottom: 13.v),
                            child: Text("lbl_3d_ago".tr,
                                style: CustomTextStyles.bodySmallBluegray300)),
                        const Spacer(),
                        CustomImageView(
                            imagePath:
                                ImageConstant.imgMoreHorizontalBlueGray300,
                            height: 24.adaptSize,
                            width: 24.adaptSize,
                            margin: EdgeInsets.only(top: 12.v, bottom: 10.v))
                      ]),
                ),
                SizedBox(height: 2.v),
                Container(
                    height: 6.adaptSize,
                    width: 6.adaptSize,
                    margin: EdgeInsets.only(left: 10.h),
                    decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onPrimaryContainer.withOpacity(1),
                        borderRadius: BorderRadius.circular(3.h))),
                SizedBox(height: 2.v),
                Container(
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(left: 10.h),
                    decoration: BoxDecoration(
                        color:
                            theme.colorScheme.onPrimaryContainer.withOpacity(1),
                        borderRadius: BorderRadius.circular(8.h)))
              ],
            ),
            Container(
              height: 480.v,
              width: 343.h,
              decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.h),
                      bottom: Radius.circular(20.h))),
              child: Column(
                children: [
                  Container(
                      width: 293.h,
                      margin:
                          EdgeInsets.only(left: 32.h, top: 10.v, bottom: 10.v),
                      child: Text("msg_happy_mother_s_day".tr,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium)),
                  CustomImageView(
                      imagePath: ImageConstant.imgRectangle23250x311,
                      height: 250.v,
                      width: 311.h,
                      radius: BorderRadius.circular(10.h),
                      alignment: Alignment.center),
                  _buildHeart(),
                ],
              ),
            ),
          ],
        ),
      ]),
    ));
  }

  /// Section Widget
  Widget _buildHeart() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 15.v),
            decoration: AppDecoration.fillGray10001
                .copyWith(borderRadius: BorderRadiusStyle.customBorderBL20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    CustomImageView(
                        imagePath: ImageConstant.imgNavFeeds,
                        height: 24.adaptSize,
                        width: 24.adaptSize),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 4.h, top: 3.v, bottom: 3.v),
                        child: Text("lbl_250".tr,
                            style: theme.textTheme.titleSmall)),
                    CustomImageView(
                        imagePath: ImageConstant.imgInbox2,
                        height: 24.adaptSize,
                        width: 24.adaptSize,
                        margin: EdgeInsets.only(left: 10.h)),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 4.h, top: 3.v, bottom: 3.v),
                        child: Text("lbl_80".tr,
                            style: theme.textTheme.titleSmall))
                  ]),
                  SizedBox(height: 15.v),
                  Obx(() => ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 14.v);
                      },
                      itemCount: controller.feedsActiveModelObj.value
                          .feedsactiveItemList.value.length,
                      itemBuilder: (context, index) {
                        FeedsactiveItemModel model = controller
                            .feedsActiveModelObj
                            .value
                            .feedsactiveItemList
                            .value[index];
                        return FeedsactiveItemWidget(model);
                      }))
                ])));
  }

  /// Navigates to the previous screen.
  onTapImgArrowLeft() {
    Get.back();
  }

  /// Navigates to the notificationScreen when the action is triggered.
  onTapBtnBellTwo() {
    Get.toNamed(
      AppRoutes.notification,
    );
  }
}
