import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/see_all_review/controller/controller.dart';

class AllReviewsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllReviewsController());
  }
}
