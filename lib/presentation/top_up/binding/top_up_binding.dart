import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/top_up/controller/top_up_controller.dart';

class TopUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TopUpController());
  }
}
