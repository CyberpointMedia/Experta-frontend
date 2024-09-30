import 'dart:ui';
import 'package:experta/core/app_export.dart';
import 'package:intl/intl.dart';

// Define the Booking class
class Booking {
  final String name;
  final String role;
  final String profileImageUrl;
  final DateTime appointmentDate;
  final String duration;
  final String status;
  final bool isAccepted;
  final String appointmentType;

  Booking({
    required this.name,
    required this.role,
    required this.profileImageUrl,
    required this.appointmentDate,
    required this.duration,
    required this.status,
    required this.isAccepted,
    required this.appointmentType,
  });
}

// Main booking page widget
class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  final List<Booking> bookings = [
    Booking(
      name: 'Naveen Verma',
      role: 'UX/UI Designer',
      profileImageUrl: 'assets/images/naveen.png',
      appointmentDate: DateTime(2024, 1, 2, 9, 35),
      duration: '30 minute',
      status: '', // No status for Naveen Verma
      isAccepted: false,
      appointmentType: '',
    ),
    Booking(
      name: 'Anjali Arora',
      role: 'Social Media Influencer',
      profileImageUrl: 'assets/images/anjali.png',
      appointmentDate: DateTime(2024, 1, 2, 9, 35),
      duration: '30 minute',
      status: 'Active', // Active status for Anjali Arora
      isAccepted: true,
      appointmentType: '',
    ),
  ];

  bool isPhoneSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
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
                      color: appTheme.deepOrangeA20.withOpacity(0.35),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomAppBar(
                  height: 40.h,
                  leadingWidth: 40.h,
                  leading: AppbarLeadingImage(
                    imagePath: ImageConstant.imgArrowLeftOnerrorcontainer,
                    margin: EdgeInsets.only(left: 16.h),
                    onTap: () {
                      onTapArrowLeft();
                    },
                  ),
                  centerTitle: true,
                  title: AppbarSubtitleSix(text: "My Bookings"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
                  child: Container(
                    height: 48.v,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffe4e4e4)),
                      color: const Color(0xffffffff),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPhoneSelected = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isPhoneSelected
                                    ? const Color(0xff171717)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  'Upcoming',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    color: isPhoneSelected
                                        ? const Color(0xffffffff)
                                        : const Color(0xff000000), // Dark black color
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPhoneSelected = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: !isPhoneSelected
                                    ? const Color(0xff171717)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  'Past',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    color: !isPhoneSelected
                                        ? const Color(0xffffffff)
                                        : const Color(0xff000000), // Dark black color
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isPhoneSelected,
                  child: BookingList(
                    bookings: bookings.where((booking) => booking.appointmentDate.isAfter(DateTime.now())).toList(),
                    isUpcomingTab: true,
                  ),
                ),
                Visibility(
                  visible: !isPhoneSelected,
                  child: BookingList(
                    bookings: bookings.where((booking) => booking.appointmentDate.isBefore(DateTime.now())).toList(),
                    isUpcomingTab: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}

// Widget to display a list of bookings
class BookingList extends StatelessWidget {
  final List<Booking> bookings;
  final bool isUpcomingTab;

  const BookingList({super.key, required this.bookings, required this.isUpcomingTab});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const Center(
        child: Text('No bookings available'),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return BookingCard(booking: booking, isUpcomingTab: isUpcomingTab);
      },
    );
  }
}

// Widget to display individual booking cards
class BookingCard extends StatelessWidget {
  final Booking booking;
  final bool isUpcomingTab;

  const BookingCard({super.key, required this.booking, required this.isUpcomingTab});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(booking.profileImageUrl),
                ),
                const SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          booking.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (booking.isAccepted)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 16.0,
                          ),
                      ],
                    ),
                    Text(
                      booking.role,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Appointment Date and Time combined
            const Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey, size: 16.0),
                SizedBox(width: 4.0),
                Text(
                  'Appointment:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54), // Lighter shade of black
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                const SizedBox(width: 24.0), // Indent for alignment
                Expanded(
                  child: Text(
                    '${DateFormat('EEE, d MMM yyyy, hh:mm a').format(booking.appointmentDate)} - ${DateFormat('hh:mm a').format(booking.appointmentDate.add(const Duration(minutes: 30)))}',
                    style: const TextStyle(fontSize: 16.0, color: Colors.black54), // Lighter shade of black
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            // Columns for Call Duration/Status and their values
            Row(
              children: [
                // Column for Call Duration and its value
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.timer, color: Colors.grey, size: 16.0),
                        SizedBox(width: 4.0),
                        Text(
                          'Call Duration:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54), // Lighter shade of black
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      booking.duration,
                      style: const TextStyle(fontSize: 16.0, color: Colors.black), // Darker color
                    ),
                  ],
                ),
                const Spacer(), // Pushes the next column to the right side
                // Column for Status and its value
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.grey, size: 16.0),
                        SizedBox(width: 4.0),
                        Text(
                          'Status:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54), // Lighter shade of black
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    if (booking.isAccepted)
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green, size: 16.0), // Icon for accepted status
                          const SizedBox(width: 4.0),
                          Text(
                            booking.status,
                            style: const TextStyle(fontSize: 16.0, color: Colors.black), // Black color for status
                          ),
                        ],
                      ),
                    // Add 'Active' text for Anjali Arora
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Accept and Reject buttons with equal size
            if (isUpcomingTab) // Show buttons only if in Upcoming tab
              Row(
                children: [
                  if (!booking.isAccepted)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Accept
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(50), // Increased button size, fixed height
                          backgroundColor: Colors.yellow,
                        ),
                        child: const Text('Accept', style: TextStyle(color: Colors.black)), // Darker black color
                      ),
                    ),
                  const SizedBox(width: 16.0), // Add spacing between the buttons
                  if (!booking.isAccepted)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle Reject
                        },
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size.fromHeight(50), // Increased button size, fixed height
                        ),
                        child: const Text('Reject', style: TextStyle(color: Colors.black)), // Darker black color
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
