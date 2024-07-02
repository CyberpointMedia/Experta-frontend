import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/set_availability/edit_set_avail/controller/edit_set_avail_controller.dart';

class EditSetAvailableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditSetAvailableController());
  }
}
