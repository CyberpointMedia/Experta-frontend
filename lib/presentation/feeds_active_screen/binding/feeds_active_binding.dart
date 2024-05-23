import 'package:experta/presentation/feeds_active_screen/controller/feeds_active_controller.dart';
import 'package:get/get.dart';

/// A binding class for the FeedsActiveScreen.
///
/// This class ensures that the FeedsActiveController is created when the
/// FeedsActiveScreen is first loaded.
class FeedsActiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FeedsActiveController());
  }
}
