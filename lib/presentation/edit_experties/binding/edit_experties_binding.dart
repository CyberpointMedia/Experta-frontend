import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/edit_experties/controller/edit_experties_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class EditExpertiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditExpertiesController());
  }
}
