import 'package:get/get.dart';
import 'notification_screen.dart';

/// This class defines the variables used in the [notification_screen],
/// and is typically used to hold data that is passed between different parts of the application.
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class NotificationModel {
  Rx<List<NotificationlistItemModel>> notificationlistItemList = Rx([
    NotificationlistItemModel(accentOne: "assets/images/img_accent.png".obs)
  ]);
}

/// This class is used in the [notificationlist_item_widget] screen.
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class NotificationlistItemModel {
  NotificationlistItemModel({this.accentOne, this.id}) {
    accentOne = accentOne ?? Rx("assets/images/img_accent.png");
    id = id ?? Rx("");
  }

  Rx<String>? accentOne;

  Rx<String>? id;
}

/// A controller class for the NotificationScreen.
///
/// This class manages the state of the NotificationScreen, including the
/// current notificationModelObj
class NotificationController extends GetxController {
  Rx<NotificationModel> notificationModelObj = NotificationModel().obs;
}

/// A binding class for the NotificationScreen.
///
/// This class ensures that the NotificationController is created when the
/// NotificationScreen is first loaded.
class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
  }
}
