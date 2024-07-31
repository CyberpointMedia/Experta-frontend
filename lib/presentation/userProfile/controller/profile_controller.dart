import 'dart:developer';

import 'package:experta/core/app_export.dart';
import 'package:experta/presentation/userProfile/models/profile_model.dart';

class ProfileController extends GetxController {
  var userData = ProfileModel().obs;
  var isLoading = true.obs;
  final String? address = PrefUtils().getaddress();

  @override
  void onInit() {
    super.onInit();
    fetchUserData(address.toString(),address.toString() );
  }

  void fetchUserData(String userId, String ownUserId) async {
    try {
      isLoading(true);
      var data = await ApiService().getUserData(userId, ownUserId);
      userData.value = ProfileModel.fromJson(data);
      log("hey your profile image path is : ${userData.value.data?.basicInfo?.profilePic}");
      await PrefUtils().setProfileImage('${userData.value.data?.basicInfo?.profilePic}');
      await PrefUtils().setProfileName("${userData.value.data?.basicInfo?.firstName ?? ''} ${userData.value.data?.basicInfo?.lastName ?? ''}");
    } catch (e) {
      // Handle error
      print("Error fetching user data: $e");
    } finally {
      isLoading(false);
    }
  }
}
