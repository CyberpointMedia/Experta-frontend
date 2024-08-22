import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/controller/home_controller.dart';
import 'package:experta/presentation/dashboard/models/dashboard_model.dart';
import 'package:experta/presentation/feeds_active_screen/controller/feeds_active_controller.dart';
import 'package:experta/presentation/message_screen/controller/message_controller.dart';
import 'package:experta/presentation/search_screen/controller/search_controller.dart';
import 'package:experta/presentation/userProfile/controller/profile_controller.dart';

class DashboardController extends GetxController {
  final PageController pageController = PageController();
  Rx<DashboardModel> dashboardModelObj = DashboardModel().obs;
  RxMap<String, dynamic> pageArguments = <String, dynamic>{}.obs;
  RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // Lazy load the controllers
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => SearchPageController(), fenix: true);
    Get.lazyPut(() => MessageController(), fenix: true);
    Get.lazyPut(() => FeedsActiveController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
  }

  void onPageChanged(int index) {
    selectedIndex.value = index;
  }

  void onBottomNavTapped(int index) {
    if (pageController.hasClients) {
      // Remove controllers of other pages
      if (index != 0) Get.delete<HomeController>();
      if (index != 1) Get.delete<SearchPageController>();
      if (index != 2) Get.delete<MessageController>();
      if (index != 3) Get.delete<FeedsActiveController>();
      if (index != 4) Get.delete<ProfileController>();

      // Navigate to the selected page
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      selectedIndex.value = index;
    }
  }

  void navigateToPage(int index, dynamic arguments) {
    pageArguments.value = arguments;
    pageController.jumpToPage(index);
    selectedIndex.value = index;
  }

  void navigateToPage2(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    selectedIndex.value = index;
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }
}
