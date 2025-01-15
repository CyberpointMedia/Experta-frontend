import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/recents/controller/recents_controller.dart';

class RecentsBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => RecentsController());
  }
}