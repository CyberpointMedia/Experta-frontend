import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/account_setting/controller/accont_controller.dart';

class AccountSettingBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => AccountSettingController());
  }
  
}