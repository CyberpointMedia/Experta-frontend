import 'package:experta/presentation/Aadhaar_Details/aadhar_details.dart';
import 'package:experta/presentation/Aadhaar_Details/binding/aadhar_details_binding.dart';
import 'package:experta/presentation/Basic_Info/basic_info.dart';
import 'package:experta/presentation/about_us/about_us.dart';
import 'package:experta/presentation/about_us/binding/about_us_binding.dart';
import 'package:experta/presentation/account_setting/account_setting.dart';
import 'package:experta/presentation/account_setting/binding/account_setting_binding.dart';
import 'package:experta/presentation/add_bank%20_account/add_bank_account.dart';
import 'package:experta/presentation/add_bank%20_account/binding/add_bank_account_binding.dart';
import 'package:experta/presentation/add_upi/add_upi.dart';
import 'package:experta/presentation/add_upi/binding/add_upi_binding.dart';
import 'package:experta/presentation/additional_info/additional_info_page.dart';
import 'package:experta/presentation/additional_info/binding/additional_binding.dart';
import 'package:experta/presentation/additional_info/binding/edit_interest_binding.dart';
import 'package:experta/presentation/additional_info/edit_interest.dart';
import 'package:experta/presentation/blocked/binding/blocked_binding.dart';
import 'package:experta/presentation/blocked/blocked.dart';
import 'package:experta/presentation/booking_detail/binding/booking_detail_binding.dart';
import 'package:experta/presentation/booking_detail/booking_detail.dart';
import 'package:experta/presentation/call_settings/bindings/call_setting_bindings.dart';
import 'package:experta/presentation/call_settings/call_settings.dart';
import 'package:experta/presentation/category/category_controller.dart';
import 'package:experta/presentation/category/category_screen.dart';
import 'package:experta/presentation/change_date_of_birth/binding/change_date_of_birth_binding.dart';
import 'package:experta/presentation/change_date_of_birth/change_date_of_birth.dart';
import 'package:experta/presentation/change_email/binding/change_email_binding.dart';
import 'package:experta/presentation/change_email/change_email.dart';
import 'package:experta/presentation/change_gender/binding/change_gender_binding.dart';
import 'package:experta/presentation/change_gender/change_gender.dart';
import 'package:experta/presentation/change_user_name/change_user_name.dart';
import 'package:experta/presentation/createPost/binding/create_post_binding.dart';
import 'package:experta/presentation/createPost/create_post.dart';
import 'package:experta/presentation/dashboard/binding/dashboard_binding.dart';
import 'package:experta/presentation/dashboard/dashboard.dart';
import 'package:experta/presentation/edit_education/binding/edit_education_list_binding.dart';
import 'package:experta/presentation/edit_education/edit_education.dart';
import 'package:experta/presentation/edit_profile/edit_profile_binding/edit_profile_binding.dart';
import 'package:experta/presentation/edit_profile/edit_profile_setting.dart';
import 'package:experta/presentation/edit_work_experience/binding/edit_work_experience_binding.dart';
import 'package:experta/presentation/edit_work_experience/edit_work_experience.dart';
import 'package:experta/presentation/education/binding/education_list_binding.dart';
import 'package:experta/presentation/education/education_edit.dart';
import 'package:experta/presentation/feeds_active_screen/binding/feeds_active_binding.dart';
import 'package:experta/presentation/feeds_active_screen/feeds_active_screen.dart';
import 'package:experta/presentation/followers/binding/followers_binding.dart';
import 'package:experta/presentation/followers/followers.dart';
import 'package:experta/presentation/following/following.dart';
import 'package:experta/presentation/give_rating/binding/give_rating_binding.dart';
import 'package:experta/presentation/give_rating/give_rating.dart';
import 'package:experta/presentation/home_controller.dart';
import 'package:experta/presentation/home_screen.dart';
import 'package:experta/presentation/message_chat_with_user_default_screen/binding/message_chat_with_user_default_binding.dart';
import 'package:experta/presentation/message_chat_with_user_default_screen/message_chat_with_user_default_screen.dart';
import 'package:experta/presentation/my_booking/binding/my_booking_binding.dart';
import 'package:experta/presentation/my_booking/my_booking.dart';
import 'package:experta/presentation/new_post/binding/new_post_bindings.dart';
import 'package:experta/presentation/new_post/new_post.dart';
import 'package:experta/presentation/notification/notification_controller.dart';
import 'package:experta/presentation/notification/notification_screen.dart';
import 'package:experta/presentation/onboarding_screen/binding/onboarding_binding.dart';
import 'package:experta/presentation/onboarding_screen/onboarding_screen.dart';
import 'package:experta/presentation/pan_detrail/binding/pan_detail_binding.dart';
import 'package:experta/presentation/pan_detrail/pan_detail.dart';
import 'package:experta/presentation/payment/binding/payment_binding.dart';
import 'package:experta/presentation/payment/payment.dart';
import 'package:experta/presentation/payment_method/binding/payment_method_binding.dart';
import 'package:experta/presentation/payment_method/payment_method.dart';
import 'package:experta/presentation/phone_number/binding/phone_number_binding.dart';
import 'package:experta/presentation/phone_number/phone_number.dart';
import 'package:experta/presentation/professional_info/binding/professional_binding.dart';
import 'package:experta/presentation/professional_info/professional_info.dart';
import 'package:experta/presentation/recents/binding/recents_binding.dart';
import 'package:experta/presentation/recents/recent.dart';
import 'package:experta/presentation/search_screen/binding/search_binding.dart';
import 'package:experta/presentation/search_screen/search_screen.dart';
import 'package:experta/presentation/security_privacy/binding/security_privacy_binding.dart';
import 'package:experta/presentation/security_privacy/security_privacy.dart';
import 'package:experta/presentation/set_availability/bindings/set_availability_bindings.dart';
import 'package:experta/presentation/set_availability/edit_set_avail/bindings/edit_set_avail_bindings.dart';
import 'package:experta/presentation/set_availability/edit_set_avail/edit_set_avail.dart';
import 'package:experta/presentation/set_availability/set_availability.dart';
import 'package:experta/presentation/set_pricing/bindings/set_pricing_bindings.dart';
import 'package:experta/presentation/set_pricing/set_pricing.dart';
import 'package:experta/presentation/setting_screen/binding/setting_binding.dart';
import 'package:experta/presentation/setting_screen/setting_screen.dart';
import 'package:experta/presentation/signin_page/signin_binding/signin_binding.dart';
import 'package:experta/presentation/signin_page/signin_page.dart';
import 'package:experta/presentation/splash_screen/binding/splash_binding.dart';
import 'package:experta/presentation/splash_screen/splash_screen.dart';
import 'package:experta/presentation/userProfile/binding/profile_binding.dart';
import 'package:experta/presentation/userProfile/user_profile_page.dart';
import 'package:experta/presentation/verifynumber_screen/binding/verifynumber_binding.dart';
import 'package:experta/presentation/verifynumber_screen/verifynumber_screen.dart';
import 'package:experta/presentation/wallet/binding/wallet_binding.dart';
import 'package:experta/presentation/wallet/wallet.dart';
import 'package:experta/presentation/work_experience/binding/experience_binding.dart';
import 'package:experta/presentation/work_experience/work_experience.dart';
import 'package:experta/widgets/custom_page_transition.dart';
import 'package:get/get.dart';

import '../presentation/change_user_name/binding/change_user_name_binding.dart';

class AppRoutes {
  static const String onboardingScreen = '/onboarding_screen';

  static const String splashScreen = '/splash_screen';

  static const String signinPage = '/signin_page';
  static const String appNavigationScreen = '/app_navigation_screen';

  static const String verifynumberScreen = '/verifynumber_screen';

  static const String homePage = '/home_screen';

  static const String searchPage = '/search_screen';

  static const String profile = "/user_profile_page";

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

  static const String experience = '/work_experience';

  static const String changeUserName = "/change_user_name";

  static const String education = "/education_edit";

  static const String editEducation = "/edit_education";

  static const String additional = "/additional_info_page";

  static const String editInterest = "/edit_interest";

  static const String callSettings = "/call_settings";

  static const String setAvailability = "/set_availability";

  static const String editSetAvail = "/edit_set_avail";

  static const String setPricing = "/set_pricing";
  static const String editExperience = '/edit_work_experience';

  static const String wallet = "/wallet";

  static const String bank = "/Varify_account";

  static const String security = "/security_privacy";

  static const String block = "/blocked";

  static const String follower = "/followers";

  static const String following = "/following";

  static const String paymentmethod = "/payment_method";

  static const String addupi = "/add_upi";

  static const String addbankaccount = "/add_bank_account";

  static const String pandetail = "/pan_detail";

  static const String adhardetail = "/Aadhar_DetailS";

  static const String changegender = "/change_gender";

  static const String accountSetting = "/account_setting";

  static const String aboutus = "/about_us";

  static const String createPost = "/create_post";

  static const String recent = "/recents";

  static const String changeDateOfBirth = "/change_date_of_birth";

  static const String changeEmail = "/change_email";

  static const String phoneNumber = "/phone_number";

  static const String payment = "/payment";

  static const String newPost = "/new_post";

  // ignore: constant_identifier_names
  static const String Bookindeetail = "/booking_detail";

static const String rating= "/give_rating";

static const String mybook = "/my_booking";

  static List<GetPage> pages = [
    GetPage(
      name: onboardingScreen,
      page: () => const OnboardingScreen(),
      bindings: [
        OnboardingBinding(),
      ],
    ),
    GetPage(
      name: recent,
      page: () =>  RecentsPage(),
      bindings: [
        RecentsBinding(),
      ],
    ),
    GetPage(
      name: aboutus,
      page: () => const AboutUs(),
      bindings: [
        AboutUsBinding(),
      ],
    ),
    GetPage(
      name: changegender,
      page: () => const ChangeGender(),
      bindings: [
        ChangeGenderBinding(),
      ],
    ),
    GetPage(
      name: addbankaccount,
      page: () => const AddBankAccount(),
      bindings: [
        AddBankAccountBinding(),
      ],
    ),
    
    GetPage(
      name: pandetail,
      page: () => const PanDetail(),
      bindings: [
        PanDetailBinding(),
      ],
    ),
    GetPage(
      name: paymentmethod,
      page: () => const PaymentMethod(),
      bindings: [
        PaymentMethodBinding(),
      ],
    ),
    GetPage(
      name: addupi,
      page: () => const AddUpi(),
      bindings: [
        AddUpiBinding(),
      ],
    ),
    GetPage(
      name: security,
      page: () => const SecurityPrivacy(),
      bindings: [
        SecuritryPrivacyBinding(),
      ],
    ),
    GetPage(
      name: adhardetail,
      page: () => const AadharDetails(),
      bindings: [
        AadharDetailBinding(),
      ],
    ),
    GetPage(
      name: signinPage,
      page: () => const SigninPage(),
      bindings: [
        SignInBinding(),
      ],
    ),
    GetPage(
      name: follower,
      page: () => FollowersPage(),
      bindings: [
        FollowersBinding(),
      ],
    ),
    GetPage(
      name: block,
      page: () => BlockedPage(),
      bindings: [
        BlockedBinding(),
      ],
    ),
    GetPage(
        name: experience,
        page: () => const WorkExperiencePage(),
        bindings: [
          WorkExperienceBinding(),
        ]),
    GetPage(
      name: accountSetting,
      page: () => const AccountSettings(),
      bindings: [
        AccountSettingBinding(),
      ],
    ),
    // GetPage(
    //   name: bank,
    //   page: () => const VerifyAccount(),
    //   bindings: [
    //     VerifyAccountBinding(),
    //   ],
    // ),
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
    // GetPage(
    //     name: editExperience,
    //     page: () => const EditWorkExperiencePage(),
    //     customTransition: CustomPageTransition(),
    //     bindings: [
    //       EditWorkExperienceBinding(),
    //     ]),
    GetPage(
      name: wallet,
      page: () => const Wallet(),
      bindings: [
        WalletBinding(),
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
      page: () => const ChangeDateOfBirth(),
      bindings: [
        ChangeDateOfBirthBinding(),
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
      page: () =>  const ChangeUserName(),
    bindings: [
        ChangeUserNameBinding(),
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
    GetPage(name: dashboard, page: () => DashboardPage(), bindings: [
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
    GetPage(
        name: experience,
        page: () => const WorkExperiencePage(),
        bindings: [
          WorkExperienceBinding(),
        ]),
    GetPage(
        name: editExperience,
        page: () => const EditWorkExperiencePage(),
        customTransition: CustomPageTransition(),
        bindings: [
          EditWorkExperienceBinding(),
        ]),
    GetPage(
        name: education,
        page: () => const EducationList(),
        customTransition: CustomPageTransition(),
        bindings: [
          EducationBinding(),
        ]),
    GetPage(
        name: editEducation,
        page: () => const EditEducationPage(),
        customTransition: CustomPageTransition(),
        bindings: [
          EditEducationBinding(),
        ]),
    GetPage(
        name: additional,
        page: () => const AdditionalInfoPage(),
        customTransition: CustomPageTransition(),
        bindings: [
          AdditionalInfoBinding(),
        ]),
    GetPage(
        name: editInterest,
        page: () => const EditInterestPage(),
        customTransition: CustomPageTransition(),
        bindings: [
          EditInterestBinding(),
        ]),
    GetPage(
        name: callSettings,
        page: () => const CallSettings(),
        customTransition: CustomPageTransition(),
        bindings: [
          CallSettingsBindings(),
        ]),
    GetPage(
        name: setAvailability,
        page: () => const SetAvailability(),
        customTransition: CustomPageTransition(),
        bindings: [
          SetAvailabilityBindings(),
        ]),
    GetPage(
        name: editSetAvail,
        page: () => const EditSetAvailability(),
        customTransition: CustomPageTransition(),
        bindings: [
          EditSetAvailableBinding(),
        ]),
    GetPage(
        name: setPricing,
        page: () => const SetPricing(),
        customTransition: CustomPageTransition(),
        bindings: [
          SetPricingBindings(),
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
    GetPage(
      name: aboutus,
      page: () => const AboutUs(),
      bindings: [
        AboutUsBinding(),
      ],
    ),
    GetPage(
      name: changegender,
      page: () => const ChangeGender(),
      bindings: [
        ChangeGenderBinding(),
      ],
    ),
    GetPage(
      name: addbankaccount,
      page: () => const AddBankAccount(),
      bindings: [
        AddBankAccountBinding(),
      ],
    ),
    GetPage(
      name: following,
      page: () => FollowingPage(),
      bindings: [
        FollowersBinding(),
      ],
    ),
    GetPage(
      name: pandetail,
      page: () => const PanDetail(),
      bindings: [
        PanDetailBinding(),
      ],
    ),
    GetPage(
      name: paymentmethod,
      page: () => const PaymentMethod(),
      bindings: [
        PaymentMethodBinding(),
      ],
    ),
    GetPage(
      name: addupi,
      page: () => const AddUpi(),
      bindings: [
        AddUpiBinding(),
      ],
    ),
    GetPage(
      name: security,
      page: () => const SecurityPrivacy(),
      bindings: [
        SecuritryPrivacyBinding(),
      ],
    ),
    GetPage(
      name: adhardetail,
      page: () => const AadharDetails(),
      bindings: [
        AadharDetailBinding(),
      ],
    ),
    GetPage(
      name: follower,
      page: () => FollowersPage(),
      bindings: [
        FollowersBinding(),
      ],
    ),
    GetPage(
      name: block,
      page: () => BlockedPage(),
      bindings: [
        BlockedBinding(),
      ],
    ),
    GetPage(
        name: createPost,
        page: () => const CreatePost(),
        customTransition: CustomPageTransition(),
        bindings: [
          CreatePostBindings(),
        ]),
    GetPage(
        name: newPost,
        page: () => const NewPostPage(),
        customTransition: CustomPageTransition(),
        bindings: [
          NewPostBindings(),
        ]),
         GetPage(
        name: Bookindeetail,
        page: () => const BookingDetailPage(),
        customTransition: CustomPageTransition(),
        bindings: [
          BookingDetailBinding(),
        ]),
         GetPage(
        name: mybook,
        page: () => MyBookingPage(),
        customTransition: CustomPageTransition(),
        bindings: [
          MyBookingBinding(),
        ]),
        GetPage(
        name: profile,
        page: () => const UserProfilePage(),
        customTransition: CustomPageTransition(),
        bindings: [
          ProfileBinding(),
        ]),
        GetPage(
        name: rating,
        page: () => RatingPage(),
        bindings: [
          RatingPageBinding(),
        ]),
  ];
}
