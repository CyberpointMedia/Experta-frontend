import 'dart:developer';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/feeds_active_screen/models/feeds_active_model.dart';

class FeedsActiveController extends GetxController {
  var feeds = <Datum>[].obs; 
  var isLoading = true.obs; 
  var isComment = false.obs; // Observable boolean for comment state
  ApiService apiServices = ApiService();
  final String? address = PrefUtils().getaddress(); // Fetching address

  @override
  void onInit() {
    super.onInit();
    fetchFeeds(); // Fetching feeds when controller is initialized
  }

  Future<void> fetchFeeds() async {
    try {
      isLoading(true);
      var response = await apiServices.fetchFeeds('post'); // Fetching feeds from API
      var feedsActiveModel = FeedsActiveModel.fromJson(response); // Parsing response into model
      feeds.value = feedsActiveModel.data; // Assigning parsed data to observable list
    } catch (e) {
      log("Error fetching feeds: $e"); // Logging error
    } finally {
      isLoading(false); // Setting loading state to false after fetch
    }
  }

  Future<void> likeUnlikePost(String postId) async {
    try {
      log("Attempting to like/unlike post with ID: $postId");
      var response = await apiServices.likeUnlikePost(postId); // Sending like/unlike request
      log("API response for like/unlike: $response");

      if (response['status'] == 'success') {
        int index = feeds.indexWhere((feed) => feed.id == postId); // Finding post index
        log("Index of the feed item: $index");

        if (index != -1) {
          feeds[index].totalLikes = response['data']['likes'].length; // Updating totalLikes
          feeds.refresh(); // Refreshing observable list
          log("Updated likes for post ID $postId: ${feeds[index].totalLikes}");
        } else {
          log("Feed item not found for post ID: $postId");
        }
      } else {
        log("Failed to like/unlike post: ${response['message']}");
      }
    } catch (e) {
      log("Error liking/unliking post: $e");
    }
  }

  Future<void> postComment(String postId, String comment) async {
    try {
      log("Attempting to post comment on post with ID: $postId");
      var response = await apiServices.postComment(postId, comment); // Sending comment request
      log("API response for post comment: $response");

      if (response['status'] == 'success') {
        int index = feeds.indexWhere((feed) => feed.id == postId); // Finding post index
        log("Index of the feed item: $index");

        if (index != -1) {
          var comments = response['data'] as List<dynamic>; // Fetching comments list from response
          feeds[index].comments = comments.map((c) => Comment.fromJson(c)).toList(); // Updating comments
          feeds[index].totalComments = comments.length; // Updating totalComments

          feeds.refresh(); // Refreshing observable list
          log("Updated comments for post ID $postId: ${feeds[index].totalComments}");
        } else {
          log("Feed item not found for post ID: $postId");
        }
      } else {
        log("Failed to post comment: ${response['message']}");
      }
    } catch (e) {
      log("Error posting comment: $e");
    }
  }
}
