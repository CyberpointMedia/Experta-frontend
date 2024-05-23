import 'package:get/get.dart';
import 'package:experta/presentation/signin_page/controller/signin_controller.dart';

/// A binding class for the OnboardingScreen.
///
/// This class ensures that the OnboardingController is created when the
/// OnboardingScreen is first loaded.
class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SigninController());
  }
}
