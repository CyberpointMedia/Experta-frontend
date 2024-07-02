import 'package:experta/core/app_export.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class FollowingsBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => FollowingsBinding());
  }
  
}