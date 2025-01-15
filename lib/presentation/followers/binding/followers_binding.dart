import 'package:experta/core/app_export.dart';

class FollowersBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => FollowersBinding());
  }
  
}