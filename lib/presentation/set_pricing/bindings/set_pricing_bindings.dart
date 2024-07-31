import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/set_pricing/controller/set_pricing_controller.dart';

class SetPricingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetPricingController());
  }
}
