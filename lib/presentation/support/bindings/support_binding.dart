import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/support/controller/support_controller.dart';

class SupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupportController());
  }
}