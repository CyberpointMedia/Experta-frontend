import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/share_profile_controller.dart';

class ShareProfilePage extends StatelessWidget {
  final ShareProfileController controller = Get.put(ShareProfileController());

   ShareProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(controller.profileImage),
            ),
            const SizedBox(height: 10),
            Text(
              controller.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              controller.designation,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            // QR code for the user
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              // child: QrImage(
              //   data: controller.qrData, // The data encoded in the QR code
              //   version: QrVersions.auto,
              //   size: 200.0,
              // ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle the share QR functionality
                // controller.shareQR();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0),
                child: Text(
                  "Share My QR",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
