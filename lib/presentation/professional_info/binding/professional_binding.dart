import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/professional_info/controller/professional_controller.dart';

class EditProfessionalInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfessionalInfoController());
  }
}
