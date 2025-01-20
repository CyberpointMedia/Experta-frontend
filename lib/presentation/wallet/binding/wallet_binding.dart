
import 'package:experta/presentation/wallet/controller/wallet_controller.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:experta/core/app_export.dart';
class WalletBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => WalletController());
  }
  
}