import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/set_availability/controller/set_availability_controller.dart';

class SetAvailabilityBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetAvailabilityController());
  }
}
