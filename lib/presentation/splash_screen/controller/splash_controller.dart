import '../../../core/app_export.dart';
import '../models/splash_model.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  Rx<SplashModel> splashModelObj = SplashModel().obs;
  final String? token = PrefUtils().getToken();
  final ApiService apiService = ApiService();

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 3000), () async {
      if (token != null && token!.isNotEmpty) {
        try {
          final response = await apiService.checkToken(token!);
          if (response.containsKey('_id')) {
            // Token is valid, navigate to dashboard
            Get.offNamed(AppRoutes.dashboard);
          } else {
            // Token is invalid, navigate to sign-in page
            Get.offNamed(AppRoutes.signinPage);
          }
        } catch (e) {
          // Handle error, navigate to sign-in page
          Get.offNamed(AppRoutes.signinPage);
        }
      } else {
        // Navigate to onboarding screen if no token is found
        Get.offNamed(AppRoutes.signinPage);
      }
    });
  }
}
