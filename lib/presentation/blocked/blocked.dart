import 'package:experta/widgets/custom_search_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:experta/presentation/blocked/controller/blocked_controller.dart';
import 'package:experta/presentation/blocked/models/blocked_model.dart';

class BlockedPage extends StatelessWidget {
  final BlockedController controller = Get.put(BlockedController());

  BlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(); // Navigate back to the settings page
          },
        ),
      ),
      body: Column(
        children: [
          const Padding( 
            padding: EdgeInsets.all(16.0),
            child: CustomSearchView(
              hintText: 'Search user',
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.blockedUsers.isEmpty) {
                return const Center(child: Text('No blocked users'));
              }
              return ListView.builder(
                itemCount: controller.blockedUsers.length,
                itemBuilder: (context, index) {
                  final user = controller.blockedUsers[index];
                  return UserTile(
                    user: user,
                    onUnblock: () {
                      controller.unblockUser(user);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final BlockedUser user;
  final VoidCallback onUnblock;

  const UserTile({super.key, required this.user, required this.onUnblock});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.profilePic.isNotEmpty
            ? NetworkImage(user.profilePic)
            : null,
        child: user.profilePic.isEmpty ? const Icon(Icons.person) : null,
      ),
      title: Row(
        children: [
          Text(user.displayName.isNotEmpty ? user.displayName : 'Anonymous'),
          if (user.isVerified) ...[
            const SizedBox(width: 4),
            const Icon(Icons.verified, color: Colors.blue, size: 16),
          ],
        ],
      ),
      subtitle: Text(user.industry.isNotEmpty ? user.industry : 'No industry'),
      trailing: ElevatedButton(
        onPressed: onUnblock,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(color: Colors.black),
          ),
          fixedSize: const Size(100, 36),
        ),
        child: const Text('Unblock'),
      ),
    );
  }
}
