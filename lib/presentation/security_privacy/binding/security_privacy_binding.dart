import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/security_privacy/controller/security_privacy_controller.dart';

class SecuritryPrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SecurityPrivacyController());
    }
}