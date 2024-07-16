import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/my_booking/controller/my_booking_controller.dart';

class MyBookingBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => MyBookingController());
  }
  
}
