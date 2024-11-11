import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/share_profile/models/share_profile_model.dart';

class ShareProfileController extends GetxController {
  final ApiService _apiService = ApiService();
  Rx<ShareProfileResponse?> profileData = Rx<ShareProfileResponse?>(null);
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getShareProfile();
      profileData.value = response;
    } catch (e) {
      print('Error fetching profile data: $e');
      Get.snackbar('Error', 'Failed to load profile data');
    } finally {
      isLoading.value = false;
    }
  }
}
