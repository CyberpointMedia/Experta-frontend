import 'package:experta/core/app_export.dart';

class BookAppointmentBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => BookAppointmentBinding());
  }
  
}