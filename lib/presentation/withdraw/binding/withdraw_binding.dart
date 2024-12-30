import 'package:experta/presentation/withdraw/controller/withdraw_controller.dart';
import 'package:get/get.dart';

class WithdrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WithdrawController());
  }
}
