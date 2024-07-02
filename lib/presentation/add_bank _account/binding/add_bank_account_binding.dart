import 'package:experta/core/app_export.dart';


class AddBankAccountBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => AddBankAccountBinding());
  }
  
}