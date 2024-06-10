import 'package:experta/presentation/Basic_Info/basic_info.dart';
import 'package:experta/presentation/account_setting/account_setting.dart';
import 'package:experta/presentation/account_setting/binding/account_setting_binding.dart';
import 'package:experta/presentation/category/category_controller.dart';
import 'package:experta/presentation/category/category_screen.dart';
import 'package:experta/presentation/change_date_of_birth/binding/change_date_of_birth_binding.dart';
import 'package:experta/presentation/change_date_of_birth/change_date_of_birth.dart';
import 'package:experta/presentation/change_email/binding/change_email_binding.dart';
import 'package:experta/presentation/change_user_name/binding/change_user_name_binding.dart';
import 'package:experta/presentation/change_user_name/change_user_name.dart';
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
import 'package:experta/presentation/payment/binding/payment_binding.dart';
import 'package:experta/presentation/payment/payment.dart';
import 'package:experta/presentation/phone_number/binding/phone_number_binding.dart';
import 'package:experta/presentation/phone_number/phone_number.dart';
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
import 'package:experta/presentation/wallet/binding/wallet_binding.dart';
import 'package:experta/presentation/wallet/wallet.dart';
import 'package:get/get.dart';
import '../presentation/change_email/change_email.dart';

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

  static const String accountSetting = "/account_setting";

  static const String changeUserName = "/change_user_name";

  static const String changeDateOfBirth = "/change_date_of_birth";

  static const String changeEmail = "/change_email";

  static const String phoneNumber = "/phone_number";

  static const String payment = "/payment";

 static const String wallet = "/wallet";






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
      name: accountSetting,
      page: () => const AccountSettings(),
      bindings: [
        AccountSettingBinding(),
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
      name: wallet,
      page: () => const Wallet(),
      bindings: [
        WalletBinding(),
      ],
    ),
     GetPage(
      name: changeUserName,
      page: () => const ChangeUsername(),
      bindings: [
        ChangeUserNameBinding(),
      ],
    ),
    GetPage(
      name: changeEmail,
      page: () => const ChangeEmail(),
      bindings: [
        ChangeEmailBinding(),
      ],
    ),
    GetPage(
      name: phoneNumber,
      page: () => const PhoneNumber(),
      bindings: [
        PhoneNumberBinding(),
      ],
    ),
    GetPage(
      name: payment,
      page: () => const Payment(),
      bindings: [
        PaymentBinding(),
      ],
    ),
    GetPage(
      name: changeDateOfBirth,
      page: () =>  const ChangeDateOfBirth(),
      bindings: [
        ChangeDateOfBirthBinding(),
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
