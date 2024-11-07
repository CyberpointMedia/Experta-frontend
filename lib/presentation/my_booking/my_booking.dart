import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:intl/intl.dart';

// Define the Booking class
class Booking {
  final String id;
  final String name;
  final String role;
  final String industry;
  final String profileImageUrl;
  final DateTime appointmentDate;
  final String duration;
  final String status;
  final bool isAccepted;
  final String appointmentType;
  final bool isFromExpertApi;

  Booking({
    required this.id,
    required this.name,
    required this.role,
    required this.industry,
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
  bool isPhoneSelected = true;
  final ApiService apiService = ApiService();

  Future<List<Booking>> fetchBookings() async {
    try {
      final clientData = await apiService.fetchClientBookings();
      final expertData = await apiService.fetchExpertBookings();

      final List<Booking> mappedBookings = [
        ...clientData.map<Booking>((booking) {
          // Safely access nested properties
          final expertInfo = booking['expert'] ?? {};
          final basicInfo = expertInfo['basicInfo'] ?? {};
          final industryOccupation = expertInfo['industryOccupation'] ?? {};
          final industry = industryOccupation['industry'] ?? {};
          final occupation = industryOccupation['occupation'] ?? {};

          return Booking(
            id: booking['_id'] ?? {},
            name: basicInfo['displayName']?.toString() ?? 'Unknown',
            role: occupation['name']?.toString() ?? '',
            industry: industry['name']?.toString() ?? '',
            profileImageUrl: basicInfo['profilePic']?.toString() ?? '',
            appointmentDate: DateTime.parse(
                booking['startTime'] ?? DateTime.now().toIso8601String()),
            duration: '${booking['duration']?.toString() ?? '0'} minute',
            status: booking['status']?.toString() ?? 'pending',
            isAccepted: booking['status'] == 'confirmed',
            appointmentType: booking['type']?.toString() ?? '',
            isFromExpertApi: false,
          );
        }),
        ...expertData.map<Booking>((booking) {
          // Safely access nested properties
          final clientInfo = booking['client'] ?? {};
          final basicInfo = clientInfo['basicInfo'] ?? {};
          final industryOccupation = clientInfo['industryOccupation'] ?? {};
          final industry = industryOccupation['industry'] ?? {};
          final occupation = industryOccupation['occupation'] ?? {};

          return Booking(
            id: booking['_id'] ?? {},
            name: basicInfo['displayName']?.toString() ?? 'Unknown',
            role: occupation['name']?.toString() ?? '',
            industry: industry['name']?.toString() ?? '',
            profileImageUrl: basicInfo['profilePic']?.toString() ?? '',
            appointmentDate: DateTime.parse(
                booking['startTime'] ?? DateTime.now().toIso8601String()),
            duration: '${booking['duration']?.toString() ?? '0'} minute',
            status: booking['status']?.toString() ?? 'pending',
            isAccepted: booking['status'] == 'confirmed',
            appointmentType: booking['type']?.toString() ?? '',
            isFromExpertApi: true,
          );
        }),
      ];

      return mappedBookings;
    } catch (e, stackTrace) {
      print('Failed to load bookings: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
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
                      color: appTheme.deepOrangeA20.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAppBar(),
              _buildTabSelector(),
              Expanded(
                child: FutureBuilder<List<Booking>>(
                  future: fetchBookings(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text('Error: ${snapshot.error}'),
                            ElevatedButton(
                              onPressed: () => setState(() {}),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No bookings available'),
                      );
                    }

                    final bookings = snapshot.data!;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Visibility(
                            visible: isPhoneSelected,
                            child: BookingList(
                              bookings: bookings
                                  .where((booking) => booking.appointmentDate
                                      .isAfter(DateTime.now()))
                                  .toList(),
                              isUpcomingTab: true,
                            ),
                          ),
                          Visibility(
                            visible: !isPhoneSelected,
                            child: BookingList(
                              bookings: bookings
                                  .where((booking) => booking.appointmentDate
                                      .isBefore(DateTime.now()))
                                  .toList(),
                              isUpcomingTab: false,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffe4e4e4)),
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _buildTab(true, 'Upcoming'),
            _buildTab(false, 'Past'),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(bool isUpcoming, String text) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isPhoneSelected = isUpcoming),
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: (isPhoneSelected == isUpcoming)
                ? Colors.black
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
                color: (isPhoneSelected == isUpcoming)
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
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
    print('Building BookingList with ${bookings.length} bookings');
    print('isUpcomingTab: $isUpcomingTab');

    if (bookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No bookings available',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        print('Building booking card for ${booking.name}');
        return BookingCard(booking: booking, isUpcomingTab: isUpcomingTab);
      },
    );
  }
}

// Widget to display individual booking cards

class BookingCard extends StatefulWidget {
  final Booking booking;
  final bool isUpcomingTab;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isUpcomingTab,
  });

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  final ApiService apiService = ApiService();
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Row(
              children: [
                SizedBox(
                  width: 55,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.booking.profileImageUrl),
                        radius: 24,
                      ),
                      Positioned(
                        top: 24,
                        left: 35,
                        bottom: 0,
                        child: widget.booking.appointmentType == 'video'
                            ? CustomImageView(
                                height: 18.adaptSize,
                                width: 18.adaptSize,
                                imagePath: 'assets/images/bookings/video.svg',
                              )
                            : CustomIconButton(
                                height: 18.adaptSize,
                                width: 18.adaptSize,
                                padding: EdgeInsets.all(3.h),
                                decoration: IconButtonStyleHelper.fillGreenTL24,
                                child: CustomImageView(
                                  imagePath: ImageConstant.call,
                                )),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(widget.booking.name,
                            style: theme.textTheme.titleLarge!
                                .copyWith(fontSize: 16)),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified,
                          color: Colors.deepPurple,
                          size: 16.0,
                        ),
                      ],
                    ),
                    Text(widget.booking.role,
                        style: theme.textTheme.titleSmall!.copyWith(
                            color: appTheme.gray600,
                            fontSize: 12,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Text(
              'Appointment date',
              style: theme.textTheme.bodySmall!.copyWith(
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: Colors.black, size: 14.0),
                const SizedBox(width: 4.0),
                Text(
                  '${DateFormat('EEE, d MMM yyyy').format(widget.booking.appointmentDate)} • ${DateFormat('hh:mm a').format(widget.booking.appointmentDate)} - ${DateFormat('hh:mm a').format(widget.booking.appointmentDate.add(Duration(minutes: int.parse(widget.booking.duration.split(' ')[0]))))}',
                  style: theme.textTheme.bodySmall!.copyWith(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Call Duration',
                      style: theme.textTheme.bodySmall!.copyWith(
                          fontSize: 12.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Colors.black, size: 16.0),
                        const SizedBox(width: 4.0),
                        Text(
                          widget.booking.duration,
                          style: theme.textTheme.bodySmall!.copyWith(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  width: 80,
                ),
                if (!widget.booking.isFromExpertApi ||
                    widget.booking.isFromExpertApi &&
                        widget.booking.status.toLowerCase() == 'accepted' ||
                    widget.booking.isFromExpertApi &&
                        widget.booking.status.toLowerCase() == 'rejected')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: theme.textTheme.bodySmall!.copyWith(
                            fontSize: 12.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          Text(
                            "•",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: widget.booking.status.toLowerCase() ==
                                      'accepted'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            '${widget.booking.status[0].toUpperCase()}${widget.booking.status.substring(1)}',
                            style: theme.textTheme.bodySmall!.copyWith(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (widget.booking.isFromExpertApi &&
              widget.isUpcomingTab &&
              widget.booking.status.toLowerCase() == 'pending')
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 45.adaptSize,
                    width: 145.adaptSize,
                    child: CustomElevatedButton(
                        buttonStyle: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          print("Accept button pressed!");
                          apiService.updateBookingStatus(
                              widget.booking.id, "accepted");
                          setState(() {});
                        },
                        text: 'Accept'),
                  ),
                  SizedBox(
                    height: 45.adaptSize,
                    width: 145.adaptSize,
                    child: CustomElevatedButton(
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: appTheme.gray300),
                        ),
                      ),
                      onPressed: () {
                        print("Reject button pressed!");
                        apiService.updateBookingStatus(
                            widget.booking.id, "rejected");
                        setState(() {});
                      },
                      text: "Reject",
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
