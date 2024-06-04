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

/// This class is used in the [chipviewdancing_item_widget] screen.
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class ChipviewdancingItemModel {
  Rx<String>? dancingsinging = Rx("💃🏻 Dancing & Singing");

  Rx<bool>? isSelected = Rx(false);
}

/// This class is used in the [chipviewvisual_item_widget] screen.
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class ChipviewvisualItemModel {
  Rx<String>? visualDesign = Rx("Visual design");

  Rx<bool>? isSelected = Rx(false);
}

/// This class defines the variables used in the [iphone_14_15_pro_max_one_screen],
/// and is typically used to hold data that is passed between different parts of the application.
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class Iphone1415ProMaxOneModel {
  Rx<List<ChipviewvisualItemModel>> chipviewvisualItemList =
      Rx(List.generate(6, (index) => ChipviewvisualItemModel()));

  Rx<List<ChipviewdancingItemModel>> chipviewdancingItemList =
      Rx(List.generate(5, (index) => ChipviewdancingItemModel()));
}

/// A controller class for the Iphone1415ProMaxOneScreen.
///
/// This class manages the state of the Iphone1415ProMaxOneScreen, including the
/// current iphone1415ProMaxOneModelObj
class Iphone1415ProMaxOneController extends GetxController {
  Rx<Iphone1415ProMaxOneModel> iphone1415ProMaxOneModelObj =
      Iphone1415ProMaxOneModel().obs;
}

/// A binding class for the Iphone1415ProMaxOneScreen.
///
/// This class ensures that the Iphone1415ProMaxOneController is created when the
/// Iphone1415ProMaxOneScreen is first loaded.
class Iphone1415ProMaxOneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Iphone1415ProMaxOneController());
  }
}
