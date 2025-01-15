import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/recorded_session/controller/recorded_session_controller.dart';

class RecordedSessionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecordedSessionController());
  }
}
