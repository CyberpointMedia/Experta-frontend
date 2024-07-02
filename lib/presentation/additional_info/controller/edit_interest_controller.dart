import 'dart:developer';

import 'package:experta/core/app_export.dart';
import 'package:experta/data/apiClient/api_service.dart';
import 'package:experta/presentation/additional_info/model/interest_model.dart';

class InterestController extends GetxController {
  var interests = <Interest>[].obs;
  var filteredInterests = <Interest>[].obs;
  var selectedInterests = <Interest>[].obs;
  var isLoading = true.obs;

  InterestController({List<Interest>? interests}) {
    if (interests != null) {
      this.interests.assignAll(interests);
      filteredInterests.assignAll(interests);
      selectedInterests.clear();
      selectedInterests.assignAll(interests);
      isLoading(false);
      fetchInterests();
    } else {
      fetchInterests();
    }
  }

  void fetchInterests() async {
    try {
      isLoading(true);
      var fetchedInterests = await ApiService().fetchAllInterests();
      interests.assignAll(fetchedInterests);
      filteredInterests.assignAll(fetchedInterests);
    } catch (e) {
      log("Error fetching interests: $e");
    } finally {
      isLoading(false);
    }
  }

  void filterInterests(String query) {
    filteredInterests.value = interests.where((interest) {
      return interest.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void resetInterests() {
    filteredInterests.assignAll(interests);
  }

  void toggleSelection(Interest interest) {
    if (selectedInterests.contains(interest)) {
      selectedInterests.remove(interest);
    } else if (selectedInterests.length < 5) {
      selectedInterests.add(interest);
    }
    update(); // Notify listeners about the change
  }

  Future<void> submitSelectedInterests() async {
    try {
      final response = await ApiService().submitUserInterests(
        selectedInterests.map((interest) => interest.id).toList(),
      );
      if (response["status"] == "success") {
        Get.offAndToNamed(AppRoutes.editProfileSetting);
      }
      log('Interests submitted successfully: $response');
    } catch (e) {
      log('Error submitting interests: $e');
    }
  }
}
