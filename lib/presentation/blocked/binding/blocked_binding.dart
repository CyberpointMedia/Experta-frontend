import 'package:experta/core/app_export.dart';

class BlockedBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => BlockedBinding());
  }
  
}