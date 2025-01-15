import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/new_post/controller/new_post_controller.dart';

class NewPostBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => NewPostController());
  }
  
}
