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
  final bool isFromExpertApi;

  Booking({
    required this.name,
    required this.role,
    required this.profileImageUrl,
    required this.appointmentDate,
    required this.duration,
    required this.status,
    required this.isAccepted,
    required this.appointmentType,
    required this.isFromExpertApi,
  });
}

// Main booking page widget
class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  List<Booking> bookings = [];
  bool isPhoneSelected = true;
  final ApiService apiService = ApiService(); 

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      final clientData = await apiService.fetchClientBookings();
      final expertData = await apiService.fetchExpertBookings();

      setState(() {
        bookings = [
          ...clientData.map<Booking>((booking) => Booking(
                name: booking['expert']['displayName'],
                role: booking['expert']['occupation'] ?? '',
                profileImageUrl: booking['expert']['profilePic'],
                appointmentDate: DateTime.parse(booking['startTime']),
                duration: '${booking['duration']} minute',
                status: booking['status'],
                isAccepted: booking['status'] == 'confirmed',
                appointmentType: booking['type'],
                isFromExpertApi: false,
              )),
          ...expertData.map<Booking>((booking) => Booking(
                name: booking['client']['displayName'],
                role: booking['client']['occupation'] ?? '',
                profileImageUrl: booking['client']['profilePic'],
                appointmentDate: DateTime.parse(booking['startTime']),
                duration: '${booking['duration']} minute',
                status: booking['status'],
                isAccepted: booking['status'] == 'confirmed',
                appointmentType: booking['type'],
                isFromExpertApi: true,
              )),
        ];
      });
    } catch (e) {
      // Handle error
      print('Failed to load bookings: $e');
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
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
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }

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
                      color: Colors.deepOrange.withOpacity(0.35),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAppBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 25),
                child: Container(
                  height: 48,
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
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: isPhoneSelected
                                  ? Colors.black
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
                                      ? Colors.white
                                      : Colors.black,
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
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: !isPhoneSelected
                                  ? Colors.black
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
                                      ? Colors.white
                                      : Colors.black,
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
              SingleChildScrollView(
                child: Visibility(
                  visible: isPhoneSelected,
                  child: BookingList(
                    bookings: bookings
                        .where((booking) =>
                            booking.appointmentDate.isAfter(DateTime.now()))
                        .toList(),
                    isUpcomingTab: true,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Visibility(
                  visible: !isPhoneSelected,
                  child: BookingList(
                    bookings: bookings
                        .where((booking) =>
                            booking.appointmentDate.isBefore(DateTime.now()))
                        .toList(),
                    isUpcomingTab: false,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget to display a list of bookings
class BookingList extends StatelessWidget {
  final List<Booking> bookings;
  final bool isUpcomingTab;

  const BookingList({
    super.key,
    required this.bookings,
    required this.isUpcomingTab,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: bookings.isEmpty
          ? const Center(
              child: Text('No bookings available'),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return BookingCard(
                    booking: booking, isUpcomingTab: isUpcomingTab);
              },
            ),
    );
  }
}

// Widget to display individual booking cards
class BookingCard extends StatelessWidget {
  final Booking booking;
  final bool isUpcomingTab;

  const BookingCard(
      {super.key, required this.booking, required this.isUpcomingTab});

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
                  backgroundImage: NetworkImage(booking.profileImageUrl),
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
            const Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey, size: 16.0),
                SizedBox(width: 4.0),
                Text(
                  'Appointment:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                const SizedBox(width: 24.0),
                Expanded(
                  child: Text(
                    '${DateFormat('EEE, d MMM yyyy, hh:mm a').format(booking.appointmentDate)} - ${DateFormat('hh:mm a').format(booking.appointmentDate.add(Duration(minutes: int.parse(booking.duration.split(' ')[0]))))}',
                    style:
                        const TextStyle(fontSize: 16.0, color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.timer, color: Colors.grey, size: 16.0),
                        SizedBox(width: 4.0),
                        Text(
                          'Call Duration:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      booking.duration,
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.grey, size: 16.0),
                        SizedBox(width: 4.0),
                        Text(
                          'Status:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    if (booking.isAccepted)
                      Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 16.0),
                          const SizedBox(width: 4.0),
                          Text(
                            booking.status,
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.black),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (isUpcomingTab && booking.isFromExpertApi)
              Row(
                children: [
                  if (!booking.isAccepted)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Accept
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(50),
                          backgroundColor: Colors.yellow,
                        ),
                        child: const Text('Accept',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  const SizedBox(width: 16.0),
                  if (!booking.isAccepted)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle Reject
                        },
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Reject',
                            style: TextStyle(color: Colors.black)),
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
