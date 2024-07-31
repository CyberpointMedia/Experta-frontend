import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/followers/models/followers_model.dart';

class FollowersAndFollowingController extends GetxController {
  var followers = <Follow>[].obs;
  var following = <Follow>[].obs;
  var isLoading = true.obs;
  final String? address = PrefUtils().getaddress();
  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchFollowersAndFollowing(address.toString()); // Replace with dynamic userId
  }

  void fetchFollowersAndFollowing(String userId) async {
    try {
      isLoading(true);
      var response = await apiService.getFollowersAndFollowing(userId);
      var data = FollowersAndFollowing.fromJson(response);

      followers.value = data.data.followers;
      following.value = data.data.following;
    } catch (e) {
      print(e);
      // Handle the error accordingly
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeConnection(String targetUserId, String type) async {
    try {
      final body = {"targetUserId": targetUserId, "action": type};
      await apiService.removeConnection(body);

      if (type == "unfollow") {
        following.removeWhere((follower) => follower.id == targetUserId);
      } else {
        followers.removeWhere((follower) => follower.id == targetUserId);
      }

      // Show a success message once
      String message = type == "unfollow" ? 'User unfollowed successfully' : 'User removed successfully';
      Get.snackbar('Success', message);
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to unfollow user: $e');
    }
  }
}
