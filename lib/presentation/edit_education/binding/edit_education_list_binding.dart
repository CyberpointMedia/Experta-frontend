import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/edit_education/edit_education_controller.dart';

class EditEducationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditEducationController());
  }
}
