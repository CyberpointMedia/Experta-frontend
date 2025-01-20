import 'package:experta/presentation/dashboard/controller/dashboard_controller.dart';
import 'package:experta/presentation/feeds_active_screen/feeds_active_screen.dart';
import 'package:experta/presentation/Home/home_screen.dart';
import 'package:experta/presentation/message_screen/message_screen.dart';
import 'package:experta/presentation/search_screen/search_screen.dart';
import 'package:experta/presentation/userProfile/user_profile_page.dart';
import 'package:experta/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: const [
          HomeScreen(),
          SearchScreen(),
          MessageScreen(),
          FeedsActiveScreen(),
          UserProfilePage(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => CustomBottomBar(
          selectedIndex: controller.selectedIndex.value,
          onChanged: (BottomBarEnum type) {
            int index = BottomBarEnum.values.indexOf(type);
            controller.onBottomNavTapped(index);
          },
        ),
      ),
    );
  }
}
