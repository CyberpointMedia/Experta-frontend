import 'package:experta/core/app_export.dart';
import 'package:experta/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class BookingConfirmationPage extends StatelessWidget {
  const BookingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 140.h,
                height: 140.v,
                decoration: BoxDecoration(
                  color: appTheme.green400.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child:  Center(
                  child: Container(
  width: 92.h,
  height: 92.v,
  decoration: BoxDecoration(
    color: appTheme.green400,
    shape: BoxShape.circle, 
  ),
  child: Center( 
    child: CustomImageView(
      imagePath: ImageConstant.success,
      height: 20.v,
      width: 30.h,
      fit: BoxFit.contain,
    ),
  ),
),


                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Successfully',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Set the color to dark black
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your appointment booking confirmed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
