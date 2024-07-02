import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Basic_Info/controller/basic_info_controller.dart';

class EditWorkExperienceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BasicProfileInfoController());
  }
}
