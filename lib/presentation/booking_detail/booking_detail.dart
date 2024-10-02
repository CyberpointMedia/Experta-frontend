import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_button_one.dart';
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
        preferredSize: const Size.fromHeight(80.0),
        child: _buildAppBar(),
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        padding: const EdgeInsets.fromLTRB(25, 12, 25, 20), // Adjust padding to avoid overflow
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              'Date & Time',
                              '${DateFormat.EEEE().format(selectedDate)}, ${DateFormat.MMMMd().format(selectedDate)}\n$selectedSlot',
                              leading: CircleAvatar(
                                backgroundColor: Colors.yellow.shade100,
                                child: const Icon(Icons.calendar_today, color: Colors.yellow),
                              ),
                            ),
                            const Divider(),
                            _buildAppointmentType('Video Call'),
                            const Divider(), // Divider added here
                            _buildInfoRow(
                              'Call Duration',
                              selectedDuration,
                              leading: CircleAvatar(
                                backgroundColor: Colors.green.shade100,
                                child: const Icon(Icons.call, color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildAppointmentWith(),
                    const SizedBox(height: 80),
                    const Divider(), // Divider added here
                    const SizedBox(height: 50),
                    _buildPaymentInfo(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // "Continue" button positioned at the bottom
            CustomElevatedButton(
              text: "lblcontinue".tr,
              onPressed: () {
                Get.toNamed(AppRoutes.sUcessfuly);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {Widget? leading}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (leading != null) leading,
          if (leading != null) const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
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
          CircleAvatar(
            backgroundColor: Colors.red.shade100,
            child: const Icon(Icons.videocam, color: Colors.red),
          ),
          const SizedBox(width: 35),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Appointment Type',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appointmentType,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
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
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 4.0,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Taranvir Kaur',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Social Media Influencer',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
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
        const Divider(), // Divider added here
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
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text(
              'Total credits',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 14.0,
              width: 14.0,
              child: CustomImageView(imagePath: ImageConstant.imgLayer1),
            ),
            const SizedBox(width: 8.0), // Add some spacing between the image and text
            const Text(
              '2800',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      height: 80.0,
      leadingWidth: 40.0,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
        margin: const EdgeInsets.only(left: 16.0),
        onTap: () {
          onTapArrowLeft();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitleSix(text: "Booking detail"),
      actions: [
        AppbarTrailingButtonOne(
          margin: EdgeInsets.only(right: 12.h, top: 8.v),
          onTap: onTapThreeThousand,
        ),
      ],
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }

  void onTapThreeThousand() {
    // Handle custom button tap
  }
}
