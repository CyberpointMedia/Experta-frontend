// followers_and_following_controller.dart
import 'package:experta/data/apiClient/api_service.dart';
import 'package:experta/presentation/followers/models/followers_model.dart';
import 'package:get/get.dart';

class FollowersAndFollowingController extends GetxController {
  var followers = <FollowersAndFollowing>[].obs;
  var following = <FollowersAndFollowing>[].obs;
  var isLoading = true.obs;

  final ApiService apiService =ApiService();


  @override
  void onInit() {
    super.onInit();
    fetchFollowersAndFollowing('664ef83426880cc7d7f204f8'); // Replace with dynamic userId
  }

  void fetchFollowersAndFollowing(String userId) async {
    try {
      isLoading(true);
      var data = await apiService.getFollowersAndFollowing(userId);
      followers.value = data['followers'];
      following.value = data['following'];
    } finally {
      isLoading(false);
    }
  }
}
