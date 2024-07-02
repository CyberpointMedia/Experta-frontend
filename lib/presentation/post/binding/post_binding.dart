import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/post/controller/post_controller.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => PostController());
  }
}