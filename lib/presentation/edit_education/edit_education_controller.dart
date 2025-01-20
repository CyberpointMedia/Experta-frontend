import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';
import 'package:experta/data/apiClient/api_service.dart';

class EditEducationController extends GetxController {
  final ApiService apiService = ApiService();

  final TextEditingController degreeController = TextEditingController();
  final TextEditingController schoolCollegeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);
  final Education? education = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    if (education != null) {
      degreeController.text = education!.degree;
      schoolCollegeController.text = education!.schoolCollege;
      startDate.value = education!.startDate;
      endDate.value = education!.endDate;
      startDateController.text = formatDate(education!.startDate);
      endDateController.text = formatDate(education!.endDate);
    }
  }

  Future<void> saveEducation(String? educationId) async {
    if (formKey.currentState?.validate() ?? false) {
      if (startDate.value == null || endDate.value == null) {
        Get.snackbar('Error', 'Please select both start and end dates');
        return;
      }

      final newEducation = Education(
        id: educationId ?? '',
        degree: degreeController.text,
        schoolCollege: schoolCollegeController.text,
        startDate: startDate.value!,
        endDate: endDate.value!,
      );

      try {
        await apiService.saveEducation(newEducation);
        Get.back();
      } catch (e) {
        Get.snackbar('Error', 'Failed to save education: $e');
      }
    }
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    degreeController.clear();
    schoolCollegeController.clear();
    startDateController.clear();
    endDateController.clear();
    super.dispose();
  }
}
