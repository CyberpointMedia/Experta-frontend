import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/share_profile/controller/share_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareProfilePage extends StatelessWidget {
  final ShareProfileController controller = Get.put(ShareProfileController());

  ShareProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background blur circle
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
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
                      color: Colors.orange.withOpacity(0.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Main Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAppBar(),
              const SizedBox(height: 16.0), // Space between appbar and content
              // Profile Picture and Info
              CircleAvatar(
                radius: 40.adaptSize, // Profile picture size
                backgroundImage: AssetImage("assets/profile_image.jpg"), // Replace with actual profile image path
              ),
               SizedBox(height: 10.adaptSize), // Spacing between avatar and text
              Text(
                "Naveen Verma", // Replace with dynamic username
                style: TextStyle(
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
               SizedBox(height: 5.adaptSize),
              Text(
                "UI/UX Designer", // Replace with dynamic job title
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: Colors.grey,
                ),
              ),
               SizedBox(height: 20.adaptSize), // Spacing before QR code
              // QR Code Container
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: Offset(0, 2), // Shadow position
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/qr_code.png", // Replace with actual QR code asset path
                  width: 150.adaptSize,
                  height: 150.adaptSize,
                  fit: BoxFit.cover,
                ),
              ),
              const Spacer(), // Pushes the button to the bottom
              // Share QR Button
              GestureDetector(
                onTap: () {
                  // Define the share functionality here
                  print("Share QR tapped");
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50.0,
                  margin: const EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade700,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Center(
                    child: Text(
                      "Share My QR",
                      style: TextStyle(
                        fontSize: 18.adaptSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Custom AppBar Widget
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Get.back(); // Back navigation
        },
      ),
      centerTitle: true,
      title: Text(
        "Share Profile",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18.fSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
