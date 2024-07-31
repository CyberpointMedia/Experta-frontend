import 'package:experta/core/app_export.dart';

class FollowingsBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => FollowingsBinding());
  }
  
}