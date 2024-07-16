import 'package:experta/core/app_export.dart';
import 'package:experta/routes/app_routes.dart';
import 'package:experta/widgets/app_bar/appbar_leading_image.dart';
import 'package:experta/widgets/app_bar/appbar_subtitle_six.dart';
import 'package:experta/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch arguments
    final arguments = Get.arguments as Map<String, dynamic>;
    final DateTime selectedDate = arguments['selectedDate'];
    final String selectedDuration = arguments['selectedDuration'];
    final String selectedSlot = arguments['selectedSlot'];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // Adjust the height as needed
        child: _buildAppBar(), // Add the AppBar here
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 12, 25, 80), // Adjust padding to provide space for the button
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners for the card
                    ),
                    elevation: 4.0, // Adds shadow to the card
                    child: Padding(
                      padding: const EdgeInsets.all(16), // Increased padding for the card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Date & Time',
                            '${DateFormat.EEEE().format(selectedDate)}, ${DateFormat.MMMMd().format(selectedDate)}\n$selectedSlot',
                          ),
                          const Divider(),
                          _buildAppointmentType('Video Call'), // Separate widget for Appointment Type
                          const Divider(),
                          _buildInfoRow(Icons.access_time, 'Call Duration', selectedDuration),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildAppointmentWith(),
                  const SizedBox(height: 20),
                  _buildPaymentInfo(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 25,
            right: 25,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle booking
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.yellowAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust vertical padding for spacing
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 32), // Increased icon size
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black, // Set dark black color for the text
                    fontWeight: FontWeight.normal, // Changed to normal weight
                    fontSize: 18, // Increased text size
                  ),
                ),
                const SizedBox(height: 8), // Reduced height from 25 to 8
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal, // Changed to normal weight
                    fontSize: 16, // Increased text size for value
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentType(String appointmentType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.videocam, color: Colors.blue, size: 32), // Video Call icon added
          const SizedBox(width: 16), // Space between the icon and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Appointment Type',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal, // Changed to normal weight
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appointmentType,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal, // Changed to normal weight
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentWith() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Appointment with',
          style: TextStyle(
            color: Colors.black, // Dark black color for the text
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners for the card
          ),
          elevation: 4.0, // Adds shadow to the card
          child: const Padding(
            padding: EdgeInsets.all(16), // Increased padding for the card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      //backgroundImage: AssetImage('assets/profile_image.jpg'), // Make sure the image path is correct
                      radius: 24,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Taranvir Kaur',
                          style: TextStyle(
                            color: Colors.black, // Dark black color for the text
                            fontWeight: FontWeight.normal, // Changed to normal weight
                            fontSize: 16, // Normal text size
                          ),
                        ),
                        Text(
                          'Social Media Influencer',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16, // Increased text size
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Info',
          style: TextStyle(
            color: Colors.black, // Dark black color for the text
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        // Container with transparent color for "Total credits"
        Container(
          color: Colors.transparent,
          child: const Text(
            'Total credits',
            style: TextStyle(
              color: Colors.black, // Set dark black color for the text2
              fontWeight: FontWeight.normal, // Changed to normal weight
              fontSize: 14, // Normal text size
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      height: 80.0, // Adjusted height for the app bar
      leadingWidth: 40.0,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: const EdgeInsets.only(left: 16.0),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0), // Adjust top padding for the title
        child: AppbarSubtitleSix(text: "Booking Detail"),
      ),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
