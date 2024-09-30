import 'package:experta/presentation/blocked/controller/blocked_controller.dart';
import 'package:experta/presentation/blocked/models/blocked_model.dart';
import 'package:get/get.dart';


class BlockSearchController extends GetxController {
  final BlockedController blockedController = Get.find<BlockedController>();
  var searchQuery = ''.obs;

  List<BlockedUser> get filteredUsers {
    if (searchQuery.value.isEmpty) {
      return blockedController.blockedUsers.toList();
    } else {
      return blockedController.blockedUsers.where((user) {
        return user.displayName.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }
}