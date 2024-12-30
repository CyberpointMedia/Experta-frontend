import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/share_profile/controller/share_profile_controller.dart';

class ShareProfileBinding extends Bindings {
 @override
  void dependencies() {
    Get.lazyPut(() => ShareProfileController());
  }
  
 }