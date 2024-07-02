import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/payment_method/controller/payment_method_controller.dart';

class PaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => PaymentMethodController());
  }
  
}
