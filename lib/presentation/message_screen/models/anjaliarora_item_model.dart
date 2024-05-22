import '../../../core/app_export.dart';

/// This class is used in the [anjaliarora_item_widget] screen.
class AnjaliaroraItemModel {
  AnjaliaroraItemModel({
    this.anjaliArora,
    this.anjaliArora1,
    this.id,
  }) {
    anjaliArora = anjaliArora ?? Rx(ImageConstant.imgRectangle258x58);
    anjaliArora1 = anjaliArora1 ?? Rx("Anjali Arora");
    id = id ?? Rx("");
  }

  Rx<String>? anjaliArora;

  Rx<String>? anjaliArora1;

  Rx<String>? id;
}
