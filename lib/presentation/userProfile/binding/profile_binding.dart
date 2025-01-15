import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/userProfile/controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}
