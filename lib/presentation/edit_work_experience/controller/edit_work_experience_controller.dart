import 'dart:developer';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/edit_work_experience/model/edit_work_experience_model.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';

class EditWorkExperienceController extends GetxController {
  // Observable model object for work experience
  Rx<EditWorkExperienceModel> basicInfoModelObj = EditWorkExperienceModel().obs;

  // API service instance
  final ApiService apiService = ApiService();

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text editing controllers for form fields
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  // Observable boolean for current working status
  RxBool isCurrentlyWorking = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize form fields if editing an existing work experience
    final WorkExperience? workExperience = Get.arguments;
    if (workExperience != null) {
      jobTitleController.text = workExperience.jobTitle;
      companyNameController.text = workExperience.companyName;
      startDateController.text = formatDate(workExperience.startDate);
      endDateController.text =
          formatDate(workExperience.endDate ?? DateTime.now());
      isCurrentlyWorking.value = workExperience.isCurrentlyWorking;
    }
  }

  // Format DateTime to a string in 'yyyy-MM-dd' format
  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Save work experience data
  Future<void> saveWorkExperience(String? id) async {
    if (formKey.currentState!.validate()) {
      final workExperience = {
        "jobTitle": jobTitleController.text,
        "companyName": companyNameController.text,
        "isCurrentlyWorking": isCurrentlyWorking.value,
        "startDate": startDateController.text,
        "endDate": isCurrentlyWorking.value ? "" : endDateController.text,
      };

      if (id != null) {
        workExperience["_id"] = id;
      }

      try {
        final response =
            await apiService.createOrUpdateWorkExperience(workExperience);
        log("$response");
        Get.offAndToNamed(AppRoutes.professionalInfo);
      } catch (e) {
        Get.snackbar('Error', 'Failed to save work experience');
      }
    }
  }
}
