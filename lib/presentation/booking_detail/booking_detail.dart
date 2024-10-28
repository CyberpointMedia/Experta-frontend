import 'dart:developer';
import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/sucessfully/sucessfully.dart';
import 'package:experta/presentation/user_details/user_details.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_button_one.dart';
import 'package:experta/widgets/custom_icon_button.dart';
import 'package:intl/intl.dart';

class BookingDetailPage extends StatefulWidget {
  const BookingDetailPage({super.key});

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  final ApiService apiService = ApiService();
  int? balance;
  bool isLoading = true;
  DateTime? selectedDate;
  String selectedDuration = "";
  String selectedSlot = "";
  String profile = '';
  String firstname = '';
  String lastname = '';
  String industry = '';
  String occupation = '';
  String price = '';
  String id = '';

  @override
  void initState() {
    super.initState();
    fetchWalletBalance();
    final arguments = Get.arguments;
    selectedDate = arguments['selectedDate'];
    selectedDuration = arguments['selectedDuration'];
    selectedSlot = arguments['selectedSlot'];
    profile = arguments['profile'] ?? '';
    firstname = arguments['firstname'] ?? '';
    lastname = arguments['lastname'] ?? '';
    industry = arguments['industry'] ?? '';
    occupation = arguments['occupation'] ?? '';
    price = arguments['price'] ?? '';
    id = arguments['id'] ?? '';
  }

  Future<void> fetchWalletBalance() async {
    ApiService apiServices = ApiService();
    int? fetchedBalance = await apiServices.getWalletBalance();

    setState(() {
      balance = fetchedBalance;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 270,
            top: 50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                  tileMode: TileMode.decal, sigmaX: 60, sigmaY: 60),
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
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(
                                  'Date & Time',
                                  '${DateFormat.EEEE().format(selectedDate!)}, ${DateFormat.MMMMd().format(selectedDate!)}\n$selectedSlot',
                                  leading: CustomIconButton(
                                      height: 44.adaptSize,
                                      width: 44.adaptSize,
                                      padding: EdgeInsets.all(10.h),
                                      decoration:
                                          IconButtonStyleHelper.fillPrimary,
                                      onTap: () {
                                        log("$selectedDate");
                                        log(selectedSlot);
                                      },
                                      child: CustomImageView(
                                          imagePath: ImageConstant.calender)),
                                ),
                                const Divider(),
                                _buildAppointmentType(
                                  'Video Call',
                                  leading: CustomIconButton(
                                      height: 44.adaptSize,
                                      width: 44.adaptSize,
                                      padding: EdgeInsets.all(10.h),
                                      decoration: IconButtonStyleHelper
                                          .fillPrimaryContainerT123,
                                      child: CustomImageView(
                                          imagePath: ImageConstant.videocam)),
                                ),
                                const Divider(), // Divider added here
                                _buildInfoRow(
                                  'Call Duration',
                                  selectedDuration,
                                  leading: CustomIconButton(
                                      height: 44.adaptSize,
                                      width: 44.adaptSize,
                                      padding: EdgeInsets.all(10.h),
                                      decoration:
                                          IconButtonStyleHelper.fillGray,
                                      child: CustomImageView(
                                        imagePath: ImageConstant.clock,
                                        color: appTheme.black900,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildAppointmentWith(),
                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 10),
                        _buildPaymentInfo(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              // "Continue" button positioned at the bottom
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                child: CustomElevatedButton(
                  text: "Book Now",
                  onPressed: () {
                    _createBooking(context);
                    // Get.toNamed(AppRoutes.sUcessfuly);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _createBooking(BuildContext context) async {
    // Your selected date and slot
    DateTime selectedData = selectedDate!;
    String selectedSlots = selectedSlot;

    // Split the slot to get start and end times
    List<String> times = selectedSlots.split(' - ');
    String startTimeString = times[0];
    String endTimeString = times[1];

    // Parse the start and end times
    DateTime startTime = DateFormat.jm().parse(startTimeString);
    DateTime endTime = DateFormat.jm().parse(endTimeString);

    // Combine with the selected date
    DateTime combinedStartTime = DateTime(
      selectedData.year,
      selectedData.month,
      selectedData.day,
      startTime.hour,
      startTime.minute,
    );

    DateTime combinedEndTime = DateTime(
      selectedData.year,
      selectedData.month,
      selectedData.day,
      endTime.hour,
      endTime.minute,
    );

    // Convert to ISO 8601 format
    String isoStartTime = combinedStartTime.toIso8601String();
    String isoEndTime = combinedEndTime.toIso8601String();

    // Create booking data
    final bookingData = {
      "expertId": id,
      "startTime": "${isoStartTime}Z",
      "endTime": "${isoEndTime}Z",
      "type": "video"
    };
    log("$bookingData");
    try {
      final response = await apiService.createBooking(bookingData);

      if (response['status'] == 'success') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const BookingConfirmationPage()),
        );

        Future.delayed(const Duration(seconds: 5), () {
          Get.back();
        });
      } else {
        _showErrorDialog(
            context, "NO this is ${response['error']['errorMessage']}");
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
                  style: theme.textTheme.bodyMedium!.copyWith(
                      color: appTheme.black900,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium!
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentType(String appointmentType, {Widget? leading}) {
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
                  'Appointment Type',
                  style: theme.textTheme.bodyMedium!.copyWith(
                      color: appTheme.black900,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  appointmentType,
                  style: theme.textTheme.bodyMedium!
                      .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentWith() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointment with',
          style: theme.textTheme.bodyMedium!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: appTheme.black900),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CustomImageView(
                  height: 48,
                  width: 48,
                  imagePath: profile,
                  radius: BorderRadius.circular(48),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$firstname $lastname",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: appTheme.black900),
                    ),
                    Text(
                      '$industry | $occupation',
                      style: theme.textTheme.bodyMedium!
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w300),
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
        Text(
          'Payment Info',
          style: theme.textTheme.bodyMedium!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: appTheme.black900),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              'Total credits',
              style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: appTheme.black900),
            ),
            const Spacer(),
            SizedBox(
              height: 14.0,
              width: 14.0,
              child: CustomImageView(imagePath: ImageConstant.imgLayer1),
            ),
            const SizedBox(width: 8.0),
            Text(
              price,
              style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: appTheme.black900),
            ),
          ],
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 56.v,
      leadingWidth: 40.h,
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
          balance: balance ?? 0,
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
    Get.toNamed(AppRoutes.wallet);
  }
}
