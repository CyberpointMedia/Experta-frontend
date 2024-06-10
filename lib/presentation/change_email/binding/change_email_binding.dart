import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class ChangeEmailBinding extends Bindings {
@override
  void dependencies() {
   Get.lazyPut(() => ChangeEmailBinding ());
  }
  
}