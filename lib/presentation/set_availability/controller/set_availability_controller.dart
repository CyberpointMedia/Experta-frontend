// set_availability_controller.dart
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/set_availability/model/set_availability_model.dart';

class SetAvailabilityController extends GetxController {
  var isLoading = true.obs;
  var availabilityList = <SetAvailabilityModel>[].obs;
  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchAvailability();
  }

  Future<void> fetchAvailability() async {
    try {
      final data = await apiService.fetchAvailability();
      if (data['status'] == 'success') {
        var availabilityData = data['data'] as List;
        availabilityList.value = availabilityData
            .map((json) => SetAvailabilityModel.fromJson(json))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to load availability data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load availability data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAvailability(String id) async {
    try {
      final data = await apiService.deleteAvailability(id);
      if (data['status'] == 'success') {
        availabilityList.removeWhere((item) => item.id == id);
        Get.snackbar('Success', 'Slot deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete slot');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete slot: $e');
    }
  }
}
