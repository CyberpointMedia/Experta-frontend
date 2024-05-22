import 'package:experta/presentation/feeds_active_screen/feeds_active_screen.dart';
import 'package:experta/presentation/home_screen.dart';
import 'package:experta/presentation/message_screen/message_screen.dart';
import 'package:experta/presentation/search_screen/search_screen.dart';
import 'package:experta/presentation/userProfile/user_profile_page.dart';
import 'package:experta/presentation/user_profile_screen.dart';
import 'package:experta/widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {});
        },
        children: const [
          HomeScreen(),
          SearchScreen(),
          MessageScreen(),
          FeedsActiveScreen(),
          UserProfilePage(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return CustomBottomBar(
      onChanged: (BottomBarEnum type) {
        int index = BottomBarEnum.values.indexOf(type);
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      },
    );
  }
}
