
import 'package:experta/presentation/wallet/controller/wallet_controller.dart';
import 'package:experta/core/app_export.dart';
class WalletBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => WalletController());
  }
  
}