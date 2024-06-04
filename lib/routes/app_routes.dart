import 'package:experta/presentation/Basic_Info/basic_info.dart';
import 'package:experta/presentation/category/category_controller.dart';
import 'package:experta/presentation/category/category_screen.dart';
import 'package:experta/presentation/dashboard/binding/dashboard_binding.dart';
import 'package:experta/presentation/dashboard/dashboard.dart';
import 'package:experta/presentation/edit_profile/edit_profile_binding/edit_profile_binding.dart';
import 'package:experta/presentation/edit_profile/edit_profile_setting.dart';
import 'package:experta/presentation/feeds_active_screen/binding/feeds_active_binding.dart';
import 'package:experta/presentation/feeds_active_screen/feeds_active_screen.dart';
import 'package:experta/presentation/home_controller.dart';
import 'package:experta/presentation/home_screen.dart';
import 'package:experta/presentation/message_chat_with_user_default_screen/binding/message_chat_with_user_default_binding.dart';
import 'package:experta/presentation/message_chat_with_user_default_screen/message_chat_with_user_default_screen.dart';
import 'package:experta/presentation/notification/notification_controller.dart';
import 'package:experta/presentation/notification/notification_screen.dart';
import 'package:experta/presentation/onboarding_screen/binding/onboarding_binding.dart';
import 'package:experta/presentation/onboarding_screen/onboarding_screen.dart';
import 'package:experta/presentation/professional_info/binding/professional_binding.dart';
import 'package:experta/presentation/professional_info/professional_info.dart';
import 'package:experta/presentation/search_screen/binding/search_binding.dart';
import 'package:experta/presentation/search_screen/search_screen.dart';
import 'package:experta/presentation/setting_screen/binding/setting_binding.dart';
import 'package:experta/presentation/setting_screen/setting_screen.dart';
import 'package:experta/presentation/signin_page/signin_binding/signin_binding.dart';
import 'package:experta/presentation/signin_page/signin_page.dart';
import 'package:experta/presentation/splash_screen/binding/splash_binding.dart';
import 'package:experta/presentation/splash_screen/splash_screen.dart';
import 'package:experta/presentation/verifynumber_screen/binding/verifynumber_binding.dart';
import 'package:experta/presentation/verifynumber_screen/verifynumber_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String onboardingScreen = '/onboarding_screen';

  static const String splashScreen = '/splash_screen';

  static const String signinPage = '/signin_page';
  static const String appNavigationScreen = '/app_navigation_screen';

  static const String verifynumberScreen = '/verifynumber_screen';

  static const String homePage = '/home_screen';

  static const String searchPage = '/search_screen';

  static const String notification = '/notification_screen';

  static const String category = '/category_screen';

  static const String dashboard = '/dashboard';

  static const String messageChatWithUserDefaultScreen =
      '/message_chat_with_user_default_screen';

  static const String feeds = '/feeds_active_screen';

  static const String initialRoute = '/initialRoute';

  static const String settingScreen = '/setting_screen';

  static const String editProfileSetting = '/edit_profile_setting';

  static const String basicProfile = '/basic_info';

  static const String professionalInfo = '/professional_info';

  static List<GetPage> pages = [
    GetPage(
      name: onboardingScreen,
      page: () => const OnboardingScreen(),
      bindings: [
        OnboardingBinding(),
      ],
    ),
    GetPage(
      name: signinPage,
      page: () => SigninPage(),
      bindings: [
        SignInBinding(),
      ],
    ),
    GetPage(
      name: verifynumberScreen,
      page: () => const VerifynumberScreen(),
      bindings: [
        VerifynumberBinding(),
      ],
    ),
    GetPage(
      name: homePage,
      page: () => const HomeScreen(),
      bindings: [
        HomeBinding(),
      ],
    ),
    GetPage(
      name: searchPage,
      page: () => const SearchScreen(),
      bindings: [
        SearchBinding(),
      ],
    ),
    GetPage(
        name: notification,
        page: () => const NotificationScreen(),
        bindings: [
          NotificationBinding(),
        ]),
    GetPage(
        name: editProfileSetting,
        page: () => const EditProfileSettings(),
        bindings: [
          EditProfileSettingBinding(),
        ]),
    GetPage(
        name: basicProfile,
        page: () => const BasicProfileInfo(),
        bindings: [
          EditProfileSettingBinding(),
        ]),
    GetPage(name: settingScreen, page: () => const SettingScreen(), bindings: [
      SettingBinding(),
    ]),
    GetPage(name: feeds, page: () => const FeedsActiveScreen(), bindings: [
      FeedsActiveBinding(),
    ]),
    GetPage(name: dashboard, page: () => const DashboardPage(), bindings: [
      DashboardBinding(),
    ]),
    GetPage(
        name: messageChatWithUserDefaultScreen,
        page: () => const MessageChatWithUserDefaultScreen(),
        bindings: [
          MessageChatWithUserDefaultBinding(),
        ]),
    GetPage(
        name: professionalInfo,
        page: () => const EditProfessionalInfo(),
        bindings: [
          EditProfessionalInfoBinding(),
        ]),
    GetPage(name: category, page: () => CategoryScreen(), bindings: [
      CategoryBinding(),
    ]),
    GetPage(
      name: initialRoute,
      page: () => const SplashScreen(),
      bindings: [
        SplashBinding(),
      ],
    ),
  ];
}
