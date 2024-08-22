import 'package:experta/core/app_export.dart';
import 'package:intl/intl.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime selectedDate = DateTime.now();
  String selectedDuration = '30 minute';
  String selectedSlot = '09:35 am - 10:05 am';

  final List<String> durations = ['30 minute', '45 minute', '60 minute'];
  final List<String> timeSlots = [
    '09:00 am - 09:30 am',
    '09:35 am - 10:05 am',
    '10:10 am - 10:40 am',
    '10:45 am - 11:15 am',
    '11:20 am - 11:50 am',
  ];

  final ScrollController _scrollController = ScrollController();

  String getFormattedDate(DateTime date) {
    return DateFormat.yMMMMd().format(date); // Format to "January 1, 2024"
  }

  String getFormattedDay(DateTime date) {
    return DateFormat.E().format(date); // Format to "Mon"
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      _scrollToDate(selectedDate); // Scroll to the selected date
    }
  }

  void _scrollToDate(DateTime date) {
    double scrollPosition = (date.day - 1) * 76.0; // Assuming each date item is 76 pixels wide
    _scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<Widget> _buildDateWidgets(DateTime month) {
    List<Widget> widgets = [];
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(month.year, month.month, day);
      bool isSelected = date.day == selectedDate.day &&
          date.month == selectedDate.month &&
          date.year == selectedDate.year;

      widgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedDate = date;
            });
            _scrollToDate(date); // Scroll to the selected date
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white, // Background color remains white
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? Colors.amber : Colors.grey, // Golden border if selected
                width: isSelected ? 2 : 1, // Thicker border if selected
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat.d().format(date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Keep text color black
                  ),
                ),
                Text(
                  DateFormat.E().format(date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black, // Keep text color black
                  ),
                ),
                // Remove 'Selected' text conditionally
                if (isSelected)
                  const SizedBox.shrink(), // This will hide the 'Selected' text widget
              ],
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMM().format(selectedDate), // Format to "January, 2024"
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Set color to dark black
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 10), // Adding space between heading and date selector
            SizedBox(
              height: 80,
              child: ListView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                children: _buildDateWidgets(selectedDate),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Call Duration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Set color to dark black
                ),
              ),
            ),
            const SizedBox(height: 10), // Adding some space between the heading and dropdown
            DropdownButtonFormField<String>(
              value: selectedDuration,
              items: durations.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedDuration = newValue!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Available Slot',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Set color to dark black
                ),
              ),
            ),
            const SizedBox(height: 10), // Adding some space between the heading and slots
            Expanded(
              child: ListView.builder(
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  String slot = timeSlots[index];
                  bool isSelected = slot == selectedSlot;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSlot = slot;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white, // Always white background
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? Colors.amber : Colors.grey, // Golden border if selected
                          width: isSelected ? 2 : 1, // Thicker border if selected
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        slot,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.bookindeetail, arguments: {
                  'selectedDate': selectedDate,
                  'selectedDuration': selectedDuration,
                  'selectedSlot': selectedSlot,
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.yellow,
                padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: const Text('Continue'),
            ),
          ],
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
      title: AppbarSubtitleSix(text: "Book Appointment"),
    );
  }

  void onTapArrowLeft() {
    Get.back();
  }
}
