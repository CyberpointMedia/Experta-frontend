import 'dart:developer';
import 'dart:ui';

import 'package:experta/core/app_export.dart';
import 'package:experta/widgets/app_bar/appbar_trailing_button_one.dart';
import 'package:experta/widgets/custom_drop_down.dart';
import 'package:experta/widgets/custom_text_form_field.dart';
import 'package:intl/intl.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  int? balance;
  bool isLoading = true;
  DateTime selectedDate = DateTime.now();
  String selectedDuration = '10 minutes';
  String selectedSlot = '';
  List<Map<String, dynamic>> availabilityData = [];
  List<String> availableSlots = [];
  ApiService apiServices = ApiService();
  final List<String> durations = [
    '10 minutes',
    '20 minutes',
    '30 minutes',
    '45 minutes',
    '60 minutes'
  ];
  final ScrollController _scrollController = ScrollController();
  late List<SelectionPopupModel> durationModels;
  String profile = '';
  String firstname = '';
  String lastname = '';
  String industry = '';
  String occupation = '';
  String price = '';
  String id = '';
  String type = '';

  String amount = '';

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    profile = arguments['profile'] ?? '';
    firstname = arguments['firstname'] ?? '';
    lastname = arguments['lastname'] ?? '';
    industry = arguments['industry'] ?? '';
    occupation = arguments['occupation'] ?? '';
    price = arguments['price'] ?? '';
    id = arguments['id'] ?? '';
    type = arguments['type'] ?? '';

    fetchWalletBalance();
    fetchAvailabilityData();
    durationModels = durations.asMap().entries.map((entry) {
      return SelectionPopupModel(id: entry.key.toString(), title: entry.value);
    }).toList();
    if (!durations.contains(selectedDuration)) {
      selectedDuration = durations.first;
    }
    amount = (int.parse(selectedDuration.split(' ')[0]) * int.parse(price))
        .toString();
  }

  Future<void> fetchWalletBalance() async {
    int? fetchedBalance = await apiServices.getWalletBalance();

    setState(() {
      balance = fetchedBalance;
      isLoading = false;
    });
  }

  Future<void> fetchAvailabilityData() async {
    try {
      print('Fetching availability data for user ID: $id');
      final data = await apiServices.getUserAvailability(id);
      print('Received data: $data');

      setState(() {
        availabilityData = List<Map<String, dynamic>>.from(data['data']);
        print('Availability data set: $availabilityData');
        filterAvailableSlots();
      });
    } catch (e) {
      print('Error fetching availability data: $e');
    }
  }

  void filterAvailableSlots() {
    availableSlots.clear();
    String selectedDay = DateFormat.E().format(selectedDate).toLowerCase();
    print('Filtering slots for day: $selectedDay');
    int durationMinutes = int.parse(selectedDuration.split(' ')[0]);

    for (var availability in availabilityData) {
      print('Checking availability: ${availability['weeklyRepeat']}');
      if (availability['weeklyRepeat'].contains(selectedDay)) {
        DateTime startTime =
            DateFormat('HH:mm').parse(availability['startTime']);
        DateTime endTime = DateFormat('HH:mm').parse(availability['endTime']);
        if (endTime.isBefore(startTime)) {
          endTime = endTime.add(const Duration(days: 1));
        }

        DateTime currentTime = startTime;
        while (currentTime
            .add(Duration(minutes: durationMinutes))
            .isBefore(endTime)) {
          String slot = '${DateFormat.jm().format(currentTime)} - '
              '${DateFormat.jm().format(currentTime.add(Duration(minutes: durationMinutes)))}';
          availableSlots.add(slot);
          currentTime = currentTime.add(Duration(minutes: durationMinutes + 5));
        }
      }
    }

    setState(() {
      if (availableSlots.isNotEmpty) {
        selectedSlot = availableSlots.first;
      }
    });
  }

  String getFormattedDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }

  String getFormattedDay(DateTime date) {
    return DateFormat.E().format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      filterAvailableSlots();
      _scrollToDate(selectedDate);
    }
  }

  void _scrollToDate(DateTime date) {
    double scrollPosition = (date.day - 1) * 76.0;
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
            filterAvailableSlots();
            _scrollToDate(date);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? theme.primaryColor : Colors.grey.shade300,
                width: 1,
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
                    color: Colors.black,
                  ),
                ),
                Text(
                  DateFormat.E().format(date),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                if (isSelected) const SizedBox.shrink(),
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
              Flexible(
                child: Padding(
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
                              DateFormat.yMMMM().format(selectedDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down,
                                color: Colors.black),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.adaptSize),
                      SizedBox(
                        height: 80,
                        child: ListView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          children: _buildDateWidgets(selectedDate),
                        ),
                      ),
                      SizedBox(height: 20.adaptSize),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Call Duration',
                                    style: CustomTextStyles
                                        .titleMediumSFProTextBlack90001),
                              ),
                              SizedBox(height: 10.fSize),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: CustomDropDown(
                                  value: durationModels.firstWhere((model) =>
                                      model.title == selectedDuration),
                                  items: durationModels,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedDuration = newValue.title;
                                      amount = (int.parse(selectedDuration
                                                  .split(' ')[0]) *
                                              int.parse(price))
                                          .toString();
                                      filterAvailableSlots();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Amount',
                                    style: CustomTextStyles
                                        .titleMediumSFProTextBlack90001),
                              ),
                              SizedBox(height: 10.fSize),
                              CustomTextFormField(
                                width: MediaQuery.of(context).size.width * 0.43,
                                controller: TextEditingController(text: amount),
                                prefix: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, right: 5),
                                  child: CustomImageView(
                                      imagePath: ImageConstant.imgLayer1),
                                ),
                                readOnly: true, inputFormatters: [],
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20.adaptSize),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Available Slot',
                            style: CustomTextStyles
                                .titleMediumSFProTextBlack90001),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: availableSlots.length,
                          itemBuilder: (context, index) {
                            String slot = availableSlots[index];
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
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.yellow
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    slot,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomElevatedButton(
                        text: "lblcontinue".tr,
                        onPressed: () {
                          log("selectedDate $selectedDate, selectedDuration $selectedDuration, selectedSlot $selectedSlot ");
                          Get.offAndToNamed(AppRoutes.bookindeetail,
                              arguments: {
                                'selectedDate': selectedDate,
                                'selectedDuration': selectedDuration,
                                'selectedSlot': selectedSlot,
                                'profile': profile,
                                'firstname': firstname,
                                'lastname': lastname,
                                'industry': industry,
                                'occupation': occupation,
                                'price': price,
                                'id': id,
                                'type': type,
                              });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      height: 56.v,
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
