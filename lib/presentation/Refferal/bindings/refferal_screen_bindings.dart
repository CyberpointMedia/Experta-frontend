import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Refferal/controller/refferal_screen_controller.dart';

class RefferalScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RefferalScreenController());
  }
}