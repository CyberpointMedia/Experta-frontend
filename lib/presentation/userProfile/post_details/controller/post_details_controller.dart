import 'dart:developer';
import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/feeds_active_screen/models/feeds_active_model.dart';

class PostDetailsPageController extends GetxController {
  var feeds = <Datum>[].obs;
  var commen = <Comment>[].obs;
  var isLoading = true.obs;
  var isComment = false.obs;
  ApiService apiServices = ApiService();
  final String? address = PrefUtils().getaddress();

  @override
  void onInit() {
    super.onInit();
    // fetchFeeds();
  }

  Future<void> fetchFeeds(String userId) async {
    try {
      isLoading(true);
      var response =
          await apiServices.fetchPostByUser(userId, 'post');
      var feedsActiveModel = FeedsActiveModel.fromJson(response);
      feeds.value = feedsActiveModel.data;
      // Populate commen list with comments from feeds
      commen.value =
          feedsActiveModel.data.expand((datum) => datum.comments).toList();
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
          var comments = response['data'];
          feeds[index].totalComments = comments.length;
          // Assuming you want to update the latest comment
          if (comments.isNotEmpty) {
            var latestComment = comments.last;
            // Ensure commen list has enough elements
            if (commen.length > index) {
              commen[index].comment = latestComment['comment'] ?? '';
            } else {
              commen.add(Comment.fromJson(latestComment));
            }
          }
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
