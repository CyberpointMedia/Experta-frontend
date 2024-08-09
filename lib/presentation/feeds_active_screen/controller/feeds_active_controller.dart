import 'dart:developer';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/feeds_active_screen/models/feeds_active_model.dart';

class FeedsActiveController extends GetxController {
  var feeds = <Datum>[].obs;
  var commen = <Comment>[].obs;
  var isLoading = true.obs;
  ApiService apiServices = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchFeeds();
  }

  void fetchFeeds() async {
    try {
      isLoading(true);
      var response =
          await apiServices.fetchFeeds('664ef83426880cc7d7f204f8', 'feed');
      var feedsActiveModel = FeedsActiveModel.fromJson(response);
      feeds.value = feedsActiveModel.data;
    } catch (e) {
      print("Error fetching feeds: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> likeUnlikePost(String postId) async {
    try {
      log("Attempting to like/unlike post with ID: $postId");
      var response = await apiServices.likeUnlikePost(postId);
      log("API response for like/unlike: $response");
      if (response['status'] == 'success') {
        // Find the index of the feed item
        int index = feeds.indexWhere((feed) => feed.id == postId);
        log("Index of the feed item: $index");
        if (index != -1) {
          // Update the specific feed item
          feeds[index].totalLikes = response['data']['likes'].length;
          feeds.refresh(); // Notify listeners
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
    var response = await apiServices.postComment(postId, comment);
    log("API response for post comment: $response");
    if (response['status'] == 'success') {
      // Find the index of the feed item
      int index = feeds.indexWhere((feed) => feed.id == postId);
      log("Index of the feed item: $index");
      if (index != -1) {
        // Update the specific feed item
        feeds[index].totalComments = response['data']['comments'].length;
        feeds[index].comments = response['data']['comments'].map<Comment>((commentData) {
          return Comment.fromJson(commentData);
        }).toList();
        feeds.refresh(); // Notify listeners
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
