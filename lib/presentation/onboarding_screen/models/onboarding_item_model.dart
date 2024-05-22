import '../../../core/app_export.dart';/// This class is used in the [onboarding_item_widget] screen.
class OnboardingItemModel {OnboardingItemModel({this.rectangle, this.id, }) { rectangle = rectangle  ?? Rx(ImageConstant.imgRectangle101);id = id  ?? Rx(""); }

Rx<String>? rectangle;

Rx<String>? id;

 }
