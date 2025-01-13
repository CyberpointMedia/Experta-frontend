import 'package:experta/notification_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/app_export.dart';
import '../models/splash_model.dart';

class SplashController extends GetxController {
  Rx<SplashModel> splashModelObj = SplashModel().obs;
  final String? token = PrefUtils().getToken();
  final ApiService apiService = ApiService();

  @override
  Future<void> onInit() async {
    super.onInit();
    _requestPermissions();
    await NotificationManager().init();
  }

  Future<void> _requestPermissions() async {
    // Check notification permission
    if (!(await Permission.notification.isGranted)) {
      final notificationStatus = await Permission.notification.request();
      print('Notification permission status: $notificationStatus');
      if (notificationStatus.isDenied) {
        _showPermanentlyDeniedDialog();
        return;
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // Check microphone permission
    if (!(await Permission.microphone.isGranted)) {
      final microphoneStatus = await Permission.microphone.request();
      print('Microphone permission status: $microphoneStatus');
      if (microphoneStatus.isDenied) {
        _showPermanentlyDeniedDialog();
        return;
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }

    // Check camera permission
    if (!(await Permission.camera.isGranted)) {
      final cameraStatus = await Permission.camera.request();
      print('Camera permission status: $cameraStatus');
      if (cameraStatus.isDenied) {
        _showPermanentlyDeniedDialog();
        return;
      }
    }
  }

  void _navigateBasedOnToken() {
    Future.delayed(const Duration(seconds: 5), () async {
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

  @override
  void onReady() {
    super.onReady();
    _navigateBasedOnToken();
  }

  void _showPermanentlyDeniedDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
            'Some permissions are permanently denied. Please enable them in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
