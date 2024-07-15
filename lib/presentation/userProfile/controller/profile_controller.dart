import 'package:experta/core/app_export.dart';
import 'package:experta/data/apiClient/api_service.dart';
import 'package:experta/presentation/userProfile/models/profile_model.dart';

class ProfileController extends GetxController {
  var userData = ProfileModel().obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData('664ef83426880cc7d7f204f8');
  }

  void fetchUserData(String userId) async {
    try {
      isLoading(true);
      var data = await ApiService().getUserData(userId);
      userData.value = ProfileModel.fromJson(data);
    } catch (e) {
      // Handle error
      print("Error fetching user data: $e");
    } finally {
      isLoading(false);
    }
  }
}
