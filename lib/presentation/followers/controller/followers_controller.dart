import 'package:get/get.dart';
import 'package:experta/presentation/followers/models/followers_model.dart';
import 'package:experta/data/apiClient/api_service.dart';

class FollowersAndFollowingController extends GetxController {
  var followers = <Follow>[].obs;
  var following = <Follow>[].obs;
  var isLoading = true.obs;
  final ApiService apiService = ApiService();

  late String userId;
  late String userProfile;

  @override
  void onInit() {
    super.onInit();
    print( "${Get.arguments['id']}");
    if (Get.arguments != null && Get.arguments['id'] != null) {
      userId = Get.arguments['id'];
      userProfile = Get.arguments["userProfile"];
      fetchFollowersAndFollowing(userId);
    } else {
      print('Error: User ID is not provided in arguments');
    }
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
      } else if (type == "removeFollower") {
        followers.removeWhere((follower) => follower.id == targetUserId);
      }

      Get.snackbar('Success', 'User removed successfully');
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to remove user: $e');
    }
  }
}
