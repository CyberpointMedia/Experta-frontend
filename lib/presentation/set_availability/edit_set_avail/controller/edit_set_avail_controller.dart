import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/set_availability/model/set_availability_model.dart';
import 'package:intl/intl.dart';

class EditSetAvailableController extends GetxController {
  TextEditingController textField1 = TextEditingController();
  TextEditingController textField2 = TextEditingController();
  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();
  final ApiService apiService = ApiService();
  var selectedDays = List<bool>.filled(7, false).obs;

  Future<void> selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: theme.primaryColor,
            scaffoldBackgroundColor: theme.primaryColor,
            colorScheme: ColorScheme.light(
              primary: theme.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              highlightColor: theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final now = DateTime.now();
      final selectedTime =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      final formatted12Hour = DateFormat('hh:mm a').format(selectedTime);
      final formatted24Hour = DateFormat('HH:mm').format(selectedTime);
      controller.text = '$formatted12Hour ($formatted24Hour)';
    }
  }

  // Method to update the selected days
  void updateSelectedDayIndex(int index) {
    selectedDays[index] = !selectedDays[index];
    selectedDays.refresh();
  }

  // Method to set the initial selected days based on the weeklyRepeat list
  void setInitialSelectedDays(List<String> weeklyRepeat) {
    final daysMap = {
      "sun": 0,
      "mon": 1,
      "tue": 2,
      "wed": 3,
      "thu": 4,
      "fri": 5,
      "sat": 6,
    };
    for (var day in weeklyRepeat) {
      if (daysMap.containsKey(day)) {
        selectedDays[daysMap[day]!] = true;
      }
    }
  }

  // Method to create or update availability
  Future<void> saveAvailability(SetAvailabilityModel? availability) async {
    // Function to extract 24-hour format time from the text field
    String extract24HourFormat(String time) {
      final regex = RegExp(r'\((\d{2}:\d{2})\)');
      final match = regex.firstMatch(time);
      return match != null ? match.group(1)! : time;
    }

    final body = {
      if (availability != null) '_id': availability.id,
      'startTime': extract24HourFormat(textField1.text),
      'endTime': extract24HourFormat(textField2.text),
      'weeklyRepeat': selectedDays
          .asMap()
          .entries
          .where((entry) => entry.value)
          .map((entry) {
        switch (entry.key) {
          case 0:
            return 'sun';
          case 1:
            return 'mon';
          case 2:
            return 'tue';
          case 3:
            return 'wed';
          case 4:
            return 'thu';
          case 5:
            return 'fri';
          case 6:
            return 'sat';
          default:
            return '';
        }
      }).toList(),
    };

    try {
      final response = await apiService.createUserAvailability(body);
      // Handle success response
      debugPrint('Success: ${response['status']}');
      if (response['status'] == "success") {
        Get.offAndToNamed(AppRoutes.callSettings);
      }
    } catch (e) {
      // Handle exception
      debugPrint('Exception: $e');
    }
  }
}
