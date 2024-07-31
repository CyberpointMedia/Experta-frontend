import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/user_details/controller/details_controller.dart';

class DetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailsController());
  }
}
