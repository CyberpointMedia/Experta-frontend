import 'dart:developer';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/Home/model/home_model.dart';
import 'package:experta/presentation/feeds_active_screen/models/feeds_active_model.dart';
import 'package:experta/presentation/userProfile/models/profile_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailsController extends GetxController {
  var userData = ProfileModel().obs;
  var usersByIndustry = <String, List<User>>{}.obs;
  var isLoading = true.obs;
  var feeds = <Datum>[].obs;
  final String? address = PrefUtils().getaddress();

  Future<void> fetchFeeds(String userId) async {
    try {
      isLoading(true);
      var response = await ApiService().fetchPostByUser(userId, 'post');
      var feedsActiveModel = FeedsActiveModel.fromJson(response);
      feeds.value = feedsActiveModel.data;
    } catch (e) {
      print("Error fetching feeds: $e");
    } finally {
      isLoading(false);
    }
  }

  void fetchUserData(String userId) async {
    try {
      isLoading(true);
      var data = await ApiService().getUserData(userId, address.toString());
      userData.value = ProfileModel.fromJson(data);
      log("the following value is === ${userData.value.data?.isFollowing}");
      isFollowing.value = userData.value.data?.isFollowing ?? false;
    } catch (e) {
      // Handle error
      print("Error fetching user data: $e");
    } finally {
      isLoading(false);
    }
  }

  void followUser(String followedByUserId) async {
    try {
      bool success = await ApiService().followUser(followedByUserId);
      if (success) {
        isFollowing.value = true;
        Fluttertoast.showToast(
          msg: "User followed successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to follow user",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // Method to check if a user is blocked
  bool isUserBlocked(String userId) {
    return blockedUsers.contains(userId);
  }

  // Filtering home users
  List<User> getFilteredUsers(List<User> allUsers) {
    return allUsers.where((user) => !isUserBlocked(user.id)).toList();
  }
}
