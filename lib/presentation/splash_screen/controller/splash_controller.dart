
// import 'package:experta/testinf.dart';

import '../../../core/app_export.dart';
import '../models/splash_model.dart';

/// A controller class for the SplashScreen.
///
/// This class manages the state of the SplashScreen, including the
/// current splashModelObj
class SplashController extends GetxController {
  Rx<SplashModel> splashModelObj = SplashModel().obs;

  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      // Get.to(const Lottieiles());
      Get.offNamed(
       
        AppRoutes.onboardingScreen,
        //AppRoutes.Bookappointment,
        //AppRoutes.sucessfuly,
        //AppRoutes.newpost,
        //AppRoutes.rating,
      );
    });
  }
}
