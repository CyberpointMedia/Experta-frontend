import 'package:experta/core/app_export.dart';
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
      body: Padding(
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
                              Icons.calendar_today,
                              'Date & Time',
                              '${DateFormat.EEEE().format(selectedDate)}, ${DateFormat.MMMMd().format(selectedDate)}\n$selectedSlot',
                            ),
                            const Divider(),
                            _buildAppointmentType('Video Call'),
                            const Divider(),
                            _buildInfoRow(Icons.access_time, 'Call Duration', selectedDuration),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildAppointmentWith(),
                    const Divider(), // Divider added here
                    const SizedBox(height: 20),
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

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 32),
          const SizedBox(width: 16),
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
          const Icon(Icons.videocam, color: Colors.blue, size: 32),
          const SizedBox(width: 16),
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
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          color: Colors.transparent,
          child: const Text(
            'Total credits',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
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
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: AppbarSubtitleSix(text: "Booking Detail"),
      ),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
