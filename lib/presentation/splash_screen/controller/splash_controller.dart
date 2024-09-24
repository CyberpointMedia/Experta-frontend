import '../../../core/app_export.dart';
import '../models/splash_model.dart';

class SplashController extends GetxController {
  Rx<SplashModel> splashModelObj = SplashModel().obs;
  final String? token = PrefUtils().getToken();

  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (token != null && token!.isNotEmpty) {
        // Navigate to dashboard if token is found
        Get.offNamed(AppRoutes.dashboard);
      } else {
        // Navigate to onboarding screen if no token is found
        Get.offNamed(AppRoutes.onboardingScreen);
      }
    });
  }
}
