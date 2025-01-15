import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/additional_info/controller/edit_interest_controller.dart';

class EditInterestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InterestController());
  }
}
