import 'package:experta/presentation/work_experience/controller/experience_controller.dart';
import 'package:get/get.dart';

/// A binding class for the VerifynumberScreen.
///
/// This class ensures that the VerifynumberController is created when the
/// VerifynumberScreen is first loaded.
class WorkExperienceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkExperienceController());
  }
}
