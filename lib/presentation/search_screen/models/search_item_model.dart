import '../../../core/app_export.dart';/// This class is used in the [search_item_widget] screen.
class SearchItemModel {SearchItemModel({this.accent, this.id, }) { accent = accent  ?? Rx(ImageConstant.imgAccent24);id = id  ?? Rx(""); }

Rx<String>? accent;

Rx<String>? id;

 }
