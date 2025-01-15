// bindings/settings_binding.dart
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/account_details_settings/controller/account_detail_controller.dart';


class SettingsBinding extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut(() => AccountDetailsController());
  }
}
