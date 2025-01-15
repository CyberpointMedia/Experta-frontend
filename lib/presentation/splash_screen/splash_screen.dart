import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:lottie/lottie.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends GetWidget<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
      body: Stack(
        children: [
          Positioned(
            left: 305,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                tileMode: TileMode.decal,
                sigmaX: 80,
                sigmaY: 80,
              ),
              child: Align(
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(126),
                      color: appTheme.deepOrangeA20.withOpacity(0.35),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 305,
            top: 0,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                tileMode: TileMode.decal,
                sigmaX: 80,
                sigmaY: 80,
              ),
              child: Align(
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(126),
                      color: appTheme.deepYello.withOpacity(0.07),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 305,
            bottom: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                tileMode: TileMode.decal,
                sigmaX: 80,
                sigmaY: 80,
              ),
              child: Align(
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(126),
                      color: appTheme.deepYello.withOpacity(0.07),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: _buildVector(),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildVector() {
    return Center(
      child: Lottie.asset("assets/jsonfiles/Experta.json"),
    );
  }
}
