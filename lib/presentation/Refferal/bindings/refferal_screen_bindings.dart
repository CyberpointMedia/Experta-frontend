import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Refferal/controller/refferal_screen_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class RefferalScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RefferalScreenController());
  }
}