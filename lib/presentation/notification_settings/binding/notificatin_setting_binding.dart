import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/notification_settings/controller/notification_setting_controller.dart';

class NotificatinSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationSettingController());
  }
}
