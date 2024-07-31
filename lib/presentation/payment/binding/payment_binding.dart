import 'package:experta/presentation/payment/controller/payment_controller.dart';
import 'package:experta/core/app_export.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => PaymentController());
  }
  
}
