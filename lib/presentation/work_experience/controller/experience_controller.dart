import 'dart:developer';

import 'package:experta/core/app_export.dart';
import 'package:experta/data/apiClient/api_service.dart';
import 'package:experta/presentation/professional_info/model/professional_model.dart';

class WorkExperienceController extends GetxController {
  RxList<WorkExperience> workExperienceList = <WorkExperience>[].obs;
  ApiService apiService = ApiService();
  RxBool setLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWorkExperience();
  }

  void fetchData() {
    fetchWorkExperience();
  }

  Future<void> fetchWorkExperience() async {
    setLoading(true);
    try {
      final workExperience = await apiService.fetchWorkExperience();
      workExperienceList.value = workExperience;
    } catch (e) {
      log("Error fetching work experience: $e");
    } finally {
      setLoading(false);
    }
  }
}
