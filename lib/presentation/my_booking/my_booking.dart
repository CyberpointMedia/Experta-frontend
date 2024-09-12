import 'package:flutter/material.dart';
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
class MyBookingPage extends StatelessWidget {
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

  MyBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      initialIndex: 0, // Set the default tab index to 0 (Upcoming)
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Booking'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Handle notification action
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0), // Circular tabs
                color: Colors.grey[200],
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0), // Circular indicator
                  color: Colors.black,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Past'),
                ],
                indicatorPadding: EdgeInsets.zero, // Remove padding if needed
                indicatorColor: Colors.transparent, // Remove the default underline
                unselectedLabelStyle: const TextStyle(color: Colors.black), // Color for unselected tabs
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Upcoming bookings tab
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
              ),
              child: BookingList(
                bookings: bookings, // Show all bookings in Upcoming tab
                isUpcomingTab: true, // Indicate that this is the Upcoming tab
              ),
            ),
            // Past bookings tab
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
              ),
              child: BookingList(
                bookings: bookings.where((booking) {
                  // Filter for past bookings
                  return booking.appointmentDate.isBefore(DateTime.now());
                }).toList(),
                isUpcomingTab: false, // Indicate that this is the Past tab
              ),
            ),
          ],
        ),
      ),
    );
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

void main() {
  runApp(MaterialApp(
    home: MyBookingPage(),
  ));
}
