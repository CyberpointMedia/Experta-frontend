import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/give_rating/controller/give_rating_controller.dart';


class RatingPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RatingPageController());
  }
}
