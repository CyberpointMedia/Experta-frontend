import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/additional_info/controller/additional_controller.dart';

class AdditionalInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdditionalInfoController());
  }
}
