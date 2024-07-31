import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/createPost/controller/create_post_controller.dart';

class CreatePostBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreatePostController());
  }
}
