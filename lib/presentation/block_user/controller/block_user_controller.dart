import 'package:experta/presentation/block_user/model/block_user_model.dart';
import 'package:get/get.dart';


class SearchController extends GetxController {
  var searchText = ''.obs;
  var user = UserModel(
    profileImage: 'assets/anjali_arora.png', // Sample image
    name: 'Anjali Arora',
    profession: 'Social Media Influencer',
    isVerified: true,
  ).obs;

  // Simulate a block action
  void blockUser() {
    // Add block functionality here, such as calling a block API
    Get.snackbar('User Blocked', '${user.value.name} has been blocked');
  }

  // Simulate cancel action
  void cancelSearch() {
    searchText.value = '';
  }
}
