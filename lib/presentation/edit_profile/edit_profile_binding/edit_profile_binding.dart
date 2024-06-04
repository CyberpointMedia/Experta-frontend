import 'package:experta/presentation/edit_profile/edit_profile_controller/edit_profile_controller.dart';
import 'package:get/get.dart';

/// A binding class for the SettingScreen.
///
/// This class ensures that the SettingController is created when the
/// SettingScreen is first loaded.
class EditProfileSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditSettingController());
  }
}
