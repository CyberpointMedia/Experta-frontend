import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/edit_experties/controller/edit_experties_controller.dart';

class EditExpertiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditExpertiesController());
  }
}
