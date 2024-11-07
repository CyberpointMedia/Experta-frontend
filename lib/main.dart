import 'package:experta/notification_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'core/app_export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Notification Manager
  await NotificationManager().init();

  PrefUtils prefUtils = PrefUtils();
  await prefUtils.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        translations: AppLocalization(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        title: 'experta',
        initialBinding: InitialBindings(),
        initialRoute: AppRoutes.initialRoute,
        getPages: AppRoutes.pages,
      );
    });
  }
}
