import 'package:experta/presentation/verifynumber_screen/controller/verifynumber_controller.dart';
import 'package:get/get.dart';

/// A binding class for the VerifynumberScreen.
///
/// This class ensures that the VerifynumberController is created when the
/// VerifynumberScreen is first loaded.
class VerifynumberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerifynumberController());
  }
}
