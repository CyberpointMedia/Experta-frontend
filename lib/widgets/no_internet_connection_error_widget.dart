import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/signin_page/signin_page.dart';

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
            Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: Text(
                "Ooops!",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 55),
              child: CustomImageView(
                imagePath: ImageConstant.nointernet,
              ),
            ),
            Text("You’r offline", style: theme.textTheme.titleLarge),
            Text("Something went wrong.", style: theme.textTheme.titleMedium),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 55),
              child: Text(
                "Try refreshing the page or checking your internet connection. We’ll see you in a moment!",
                style: theme.textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 55, vertical: 50),
                child: CustomElevatedButton(
                  text: "Try Again",
                  onPressed: () {
                    // Navigate to the NewPage when the button is pressed
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SigninPage(),
                        ));
                  },
                )),

            // Add circular "Try Again" button
            // Padding(
            //   padding: const EdgeInsets.only(top: 20.0),
            //   child: MaterialButton(
            //     onPressed: () {
            //       // Add your retry logic here
            //       print("Try Again");
            //     },
            //     color: appTheme.yellow6001e, // Button color

            //     minWidth: 10, // Width of the circular button
            //     height: 30, // Height of the circular button
            //     child: Center(
            //       child: Text(
            //         'Try Again',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
