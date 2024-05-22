import 'package:experta/core/app_export.dart';

import '../models/feedsactive_item_model.dart';
import '../controller/feeds_active_controller.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FeedsactiveItemWidget extends StatelessWidget {
  FeedsactiveItemWidget(
    this.feedsactiveItemModelObj, {
    super.key,
  });

  FeedsactiveItemModel feedsactiveItemModelObj;

  var controller = Get.find<FeedsActiveController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => CustomImageView(
            imagePath: feedsactiveItemModelObj.naveenverna!.value,
            height: 38.adaptSize,
            width: 38.adaptSize,
            margin: EdgeInsets.only(bottom: 3.v),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Obx(
                      () => Text(
                        feedsactiveItemModelObj.naveenverna1!.value,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 2.h,
                        top: 4.v,
                      ),
                      child: Obx(
                        () => Text(
                          feedsactiveItemModelObj.text!.value,
                          style: CustomTextStyles.bodySmallBluegray300,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 2.h,
                        top: 4.v,
                      ),
                      child: Obx(
                        () => Text(
                          feedsactiveItemModelObj.dAgo!.value,
                          style: CustomTextStyles.bodySmallBluegray300,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.v),
                Obx(
                  () => Text(
                    feedsactiveItemModelObj.anjaliSentToMy!.value,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => CustomImageView(
            imagePath: feedsactiveItemModelObj.naveenverna2!.value,
            height: 24.adaptSize,
            width: 24.adaptSize,
            margin: EdgeInsets.only(
              left: 19.h,
              bottom: 17.v,
            ),
          ),
        ),
      ],
    );
  }
}
