import 'package:experta/core/app_export.dart';

import '../models/anjaliarora_item_model.dart';
import '../controller/message_controller.dart';

// ignore: must_be_immutable
class AnjaliaroraItemWidget extends StatelessWidget {
  AnjaliaroraItemWidget(
    this.anjaliaroraItemModelObj, {
    super.key,
  });

  AnjaliaroraItemModel anjaliaroraItemModelObj;

  var controller = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58.h,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 2.v),
          child: Column(
            children: [
              SizedBox(
                height: 58.adaptSize,
                width: 58.adaptSize,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(
                      () => CustomImageView(
                        imagePath: anjaliaroraItemModelObj.anjaliArora!.value,
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
                            color: theme.colorScheme.onPrimaryContainer
                                .withOpacity(1),
                            width: 2.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5.v),
              SizedBox(
                width: 29.h,
                child: Obx(
                  () => Text(
                    anjaliaroraItemModelObj.anjaliArora1!.value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.labelLargeGray900Medium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
