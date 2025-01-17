import 'dart:developer';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/feeds_active_screen/models/feeds_active_model.dart';
import 'package:experta/presentation/userProfile/models/profile_model.dart';

class ProfileController extends GetxController {
  var userData = ProfileModel().obs;
  var isLoading = true.obs;
  var feeds = <Datum>[].obs;
  final String? address = PrefUtils().getaddress();

  @override
  void onInit() {
    super.onInit();
    fetchUserData(address.toString(), address.toString());
    fetchFeeds(address.toString());
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    fetchUserData(address.toString(), address.toString());
    fetchFeeds(address.toString());
    isLoading.value = false;
  }

  void fetchUserData(String userId, String ownUserId) async {
    try {
      isLoading(true);
      var data = await ApiService().getUserData(userId, ownUserId);
      userData.value = ProfileModel.fromJson(data);
      log("hey your profile image path is : ${userData.value.data?.basicInfo?.profilePic}");
      await PrefUtils()
          .setProfileImage('${userData.value.data?.basicInfo?.profilePic}');
      await PrefUtils().setProfileName(
          "${userData.value.data?.basicInfo?.firstName ?? ''} ${userData.value.data?.basicInfo?.lastName ?? ''}");
      await PrefUtils()
          .setUserName(userData.value.data?.basicInfo?.displayName ?? '');
    } catch (e) {
      // Handle error
      print("Error fetching user data: $e");
    } finally {
      isLoading(false);
    }
  }

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

  void removeExpertise(UserExpertise expertise) {}
}
