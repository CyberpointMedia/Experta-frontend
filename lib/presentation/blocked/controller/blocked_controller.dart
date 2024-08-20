import 'package:experta/data/apiClient/api_service.dart';
import 'package:get/get.dart';
import 'package:experta/presentation/blocked/models/blocked_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BlockedController extends GetxController {
  var blockedUsers = <BlockedUser>[].obs;
  var isLoading = true.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchBlockedUsers();
  }

  void fetchBlockedUsers() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getAllBlockedUsers();
      if (response['status'] == 'success') {
        blockedUsers.value = (response['data'] as List)
            .map((user) => BlockedUser.fromJson(user))
            .toList();
      } else {
        Fluttertoast.showToast(msg: 'Failed to load blocked users');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void unblockUser(BlockedUser user) async {
    try {
      final response = await _apiService.unblockUser(user.id);
      if (response['status'] == 'success') {
        blockedUsers.remove(user);
        Fluttertoast.showToast(msg: 'User unblocked successfully');
      } else {
        Fluttertoast.showToast(msg: 'Failed to unblock user');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error occurred: $e');
    }
  }
}