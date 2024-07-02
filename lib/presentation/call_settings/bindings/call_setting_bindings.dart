import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/call_settings/controller/call_setting_controller.dart';

class CallSettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CallSettingsController());
  }
}
