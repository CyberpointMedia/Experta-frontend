import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/transaction/controller/transection_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransectionController());
  }
}
