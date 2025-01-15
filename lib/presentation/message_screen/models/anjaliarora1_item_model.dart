import '../../../core/app_export.dart';

/// This class is used in the [anjaliarora1_item_widget] screen.
class Anjaliarora1ItemModel {
  Anjaliarora1ItemModel({
    this.anjaliArora,
    this.anjaliArora1,
    this.anjaliArora2,
    this.helloGoodMorning,
    this.time,
    this.frame,
    this.id,
  }) {
    anjaliArora = anjaliArora ?? Rx(ImageConstant.imgRectangle258x58);
    anjaliArora1 = anjaliArora1 ?? Rx("Anjali Arora");
    anjaliArora2 = anjaliArora2 ?? Rx(ImageConstant.imgVerified);
    helloGoodMorning = helloGoodMorning ?? Rx("Hello, Good morning✨");
    time = time ?? Rx("11:47 PM");
    frame = frame ?? Rx("4");
    id = id ?? Rx("");
  }

  Rx<String>? anjaliArora;

  Rx<String>? anjaliArora1;

  Rx<String>? anjaliArora2;

  Rx<String>? helloGoodMorning;

  Rx<String>? time;

  Rx<String>? frame;

  Rx<String>? id;
}
