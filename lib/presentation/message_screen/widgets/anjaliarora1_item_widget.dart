import 'package:experta/core/app_export.dart';

import '../models/anjaliarora1_item_model.dart';
import '../controller/message_controller.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Anjaliarora1ItemWidget extends StatelessWidget {
  Anjaliarora1ItemWidget(
    this.anjaliarora1ItemModelObj, {
    super.key,
    this.onTapFrame,
  });

  Anjaliarora1ItemModel anjaliarora1ItemModelObj;

  var controller = Get.find<MessageController>();

  VoidCallback? onTapFrame;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapFrame!.call();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 58.adaptSize,
            width: 58.adaptSize,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Obx(
                  () => CustomImageView(
                    imagePath: anjaliarora1ItemModelObj.anjaliArora!.value,
                    height: 58.adaptSize,
                    width: 58.adaptSize,
                    radius: BorderRadius.circular(
                      29.h,
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    decoration: BoxDecoration(
                      color: appTheme.green400,
                      borderRadius: BorderRadius.circular(
                        8.h,
                      ),
                      border: Border.all(
                        color:
                            theme.colorScheme.onPrimaryContainer.withOpacity(1),
                        width: 2.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 15.h,
              top: 6.v,
              bottom: 6.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        anjaliarora1ItemModelObj.anjaliArora1!.value,
                        style: CustomTextStyles.titleMediumSemiBold,
                      ),
                    ),
                    Obx(
                      () => CustomImageView(
                        imagePath: anjaliarora1ItemModelObj.anjaliArora2!.value,
                        height: 16.adaptSize,
                        width: 16.adaptSize,
                        margin: EdgeInsets.only(
                          left: 2.h,
                          bottom: 4.v,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.v),
                Obx(
                  () => Text(
                    anjaliarora1ItemModelObj.helloGoodMorning!.value,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(
              top: 6.v,
              bottom: 4.v,
            ),
            child: Column(
              children: [
                Obx(
                  () => Text(
                    anjaliarora1ItemModelObj.time!.value,
                    style: CustomTextStyles.bodyMediumGray900,
                  ),
                ),
                SizedBox(height: 6.v),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 24.adaptSize,
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.h,
                      vertical: 3.v,
                    ),
                    decoration: AppDecoration.fillGreen.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder10,
                    ),
                    child: Obx(
                      () => Text(
                        anjaliarora1ItemModelObj.frame!.value,
                        style: CustomTextStyles
                            .titleSmallOnPrimaryContainerSemiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
