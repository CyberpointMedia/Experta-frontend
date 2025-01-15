import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/education/controller/education_controller.dart';

class EducationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EducationController());
  }
}
