import 'package:experta/presentation/followers/controller/followers_controller.dart';
import 'package:experta/presentation/followers/models/followers_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FollowersPage extends StatelessWidget {
  final FollowersAndFollowingController controller = Get.put(FollowersAndFollowingController());

  FollowersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Followers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search followers',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: controller.followers.length,
                  itemBuilder: (context, index) {
                    return FollowerTile(follower: controller.followers[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class FollowerTile extends StatelessWidget {
  final FollowersAndFollowing follower;

  const FollowerTile({super.key, required this.follower});

  bool _isSvg(String url) {
    return url.toLowerCase().endsWith('.svg');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          ClipOval(
            child: SizedBox(
              width: 40.0, // Adjust the size as needed
              height: 40.0,
              child: _isSvg(follower.basicInfo!.profilePic ?? "")
                  ? SvgPicture.network(
                      follower.basicInfo!.profilePic ?? "",
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      follower.basicInfo!.profilePic ?? "",
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 6,
              backgroundColor: follower.online ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      title: Text(follower.basicInfo?.displayName ?? 'No display name'),
      subtitle: Text(follower.basicInfo?.bio ?? 'No bio available'),
      trailing: ElevatedButton(
        onPressed: () {
          // Add your remove function here
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0), // Rectangular shape
          ),
          backgroundColor: Colors.white,
          minimumSize: const Size(100, 50), // Set width and height
        ),
        child: const Text(
          'Remove',
          style: TextStyle(
            color: Colors.black, // Text color black
          ),
        ),
      ),
    );
  }
}
