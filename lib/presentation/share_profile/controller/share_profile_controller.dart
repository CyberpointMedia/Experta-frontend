import 'package:get/get.dart';


class ShareProfileController extends GetxController {
  // User details
  final String name = "Naveen Verma"; // You can update this dynamically from an API or database
  final String designation = "UI/UX Designer"; // Designation of the user
  final String profileImage = "https://example.com/profile.jpg"; // User's profile image

  // QR data, which can be a URL, ID, or any unique information you want to encode in the QR code
  final String qrData = "https://example.com/user-profile?id=123"; // Example URL or unique ID

  // Method to handle sharing the QR code or user profile link
  // void shareQR() {
  //   Share.share("Check out my profile: $qrData");
  // }
}
