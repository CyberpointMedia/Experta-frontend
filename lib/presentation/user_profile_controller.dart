import 'package:get/get.dart';
import 'user_profile_screen.dart';

/// This class is used in the [griduserprofile_item_widget] screen.
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class GriduserprofileItemModel {
  GriduserprofileItemModel({this.id}) {
    id = id ?? Rx("");
  }

  Rx<String>? id;
}

/// This class defines the variables used in the [user_profile_screen],
/// and is typically used to hold data that is passed between different parts of the application.
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class UserProfileModel {
  Rx<List<GriduserprofileItemModel>> griduserprofileItemList =
      Rx(List.generate(11, (index) => GriduserprofileItemModel()));
}

/// A controller class for the UserProfileScreen.
///
/// This class manages the state of the UserProfileScreen, including the
/// current userProfileModelObj
class UserProfileController extends GetxController {
  Rx<UserProfileModel> userProfileModelObj = UserProfileModel().obs;
}

/// A binding class for the UserProfileScreen.
///
/// This class ensures that the UserProfileController is created when the
/// UserProfileScreen is first loaded.
class UserProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProfileController());
  }
}
