import 'dart:ui';

import 'package:experta/core/app_export.dart';

class NoInternetConnectionErrorWidget extends StatelessWidget {
  const NoInternetConnectionErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 270,
          top: 50,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              tileMode: TileMode.decal,
              sigmaX: 60,
              sigmaY: 60,
            ),
            child: Align(
              child: SizedBox(
                width: 252,
                height: 252,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(126),
                    color: appTheme.deepOrangeA20.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Text(
              "Ooops!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 59, left: 35.57),
              child: CustomImageView(
                imagePath: ImageConstant.nointernet,
                height: 296,
                width: 257,
              ),
            ),
            Text("no internet connection"),
            // Add circular "Try Again" button
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                onPressed: () {
                  // Add your retry logic here
                  print("Try Again");
                },
                color: appTheme.deepOrangeA20, // Button color
                shape: CircleBorder(),
                minWidth: 70, // Width of the circular button
                height: 70, // Height of the circular button
                child: Center(
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
