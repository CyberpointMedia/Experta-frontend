import 'package:experta/presentation/block_user/controller/block_user_controller.dart';
import 'package:get/get.dart';


class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController());
  }
}
