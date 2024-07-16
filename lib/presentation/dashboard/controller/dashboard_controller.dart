import 'package:experta/presentation/dashboard/models/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final PageController pageController = PageController();
  Rx<DashboardModel> dashboardModelObj = DashboardModel().obs;
  RxInt selectedIndex = 0.obs;

  void onPageChanged(int index) {
    selectedIndex.value = index;
  }

  void onBottomNavTapped(int index) {
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
