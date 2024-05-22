import '../../../core/app_export.dart';
import '../models/search_item_model.dart';
import '../controller/search_controller.dart';
import 'package:flutter/material.dart' hide SearchController;

// ignore: must_be_immutable
class SearchItemWidget extends StatelessWidget {
  SearchItemWidget(
    this.searchItemModelObj, {
    super.key,
  });

  SearchItemModel searchItemModelObj;

  var controller = Get.find<SearchController>();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Obx(
        () => CustomImageView(
          imagePath: searchItemModelObj.accent!.value,
          height: 252.v,
          width: 154.h,
        ),
      ),
    );
  }
}
