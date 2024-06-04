import 'package:experta/presentation/setting_screen/controller/setting_controller.dart';
import 'package:get/get.dart';

/// A binding class for the SettingScreen.
///
/// This class ensures that the SettingController is created when the
/// SettingScreen is first loaded.
class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingController());
  }
}
